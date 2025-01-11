//
//  File.swift
//
//
//  Created by Hilal Hakkani on 03/06/2024.
//

import APIClient
import AuthenticationClient
import Combine
import Dependencies
import Foundation
import Keychain
import NodeCryptoCore
import PhotosUI
import ResourceProvider
import SharedModels
import SharedViews
import SwiftUI

@Reducer
public struct EditProfile: Reducer, Sendable {
    @Dependency(\.imageUploader) var imageUploader
    public init() {}

    @ObservableState
    public struct State: Equatable, Sendable {
        @ObservationStateIgnored public var user: User
        public var isProfileSubmitted = false
        public var userImageData: Data?
        public var userImage: Image?
        public var imagePicker = ImagesPicker.State()
        public var isDisabled = false
        @Presents public var alert: AlertState<Action.Alert>?

        public init(user: User) {
            self.user = user
        }

        @CasePathable
        public enum Destination: Equatable, Sendable {
            case alert(AlertState<EditProfile.Action.Alert>)
        }
    }

    public enum Action: TCAFeatureAction, Sendable {
        case view(View)
        case `internal`(Internal)
        case delegate(Delegate)

        @CasePathable
        public enum View: Sendable, Equatable {
            case backButtonTapped
            case submitButtonTapped
            case removeImageButtonTapped
        }

        @CasePathable
        public enum Internal: BindableAction, Sendable {
            case binding(BindingAction<State>)
            case showProfileUpdatedCheckmark(Bool)
            case imageUploadResponse(Result<String, Error>)
            case didUpdateName(String)
            case didUpdateBio(String)
            case didUpdateEmail(String)
            case didUpdateTwitter(String)
            case didUpdateInstagram(String)
            case imagePicker(ImagesPicker.Action)
            case alert(PresentationAction<Alert>)
            case disableList(Bool)
        }

        @CasePathable
        public enum Delegate: Sendable, Equatable {
            case didTapBack
        }

        @CasePathable
        public enum Alert: Equatable, Sendable {
            case confirmRemoveImage
            case dismissAlert
        }
    }

    public var body: some ReducerOf<Self> {

        CombineReducers {

            BindingReducer(action: \.internal)

            Scope(state: \.imagePicker, action: \.internal.imagePicker) {
                ImagesPicker()
            }

            NestedAction(\.view) { state, action in
                switch action {
                    case .backButtonTapped:
                        return .send(.delegate(.didTapBack))

                    case .submitButtonTapped:
                        guard !state.isDisabled else { return .none }

                        return .run { [state, imageUploader] send in

                            // Disable list
                            await send(.internal(.showProfileUpdatedCheckmark(false)))
                            await send(.internal(.disableList(true)))

                            // First, update user's info
                              updateProfile(profileUser: state.user)

                            // Then, upload image
                            if let imageData = state.userImageData {
                                await send(
                                    .internal(
                                        .imageUploadResponse(
                                            Result {
                                                try await imageUploader.uploadImage(imageData)
                                            }
                                        )
                                    )
                                )
                            }
                            // Re-enable list
                            await send(.internal(.showProfileUpdatedCheckmark(true)))
                            await send(.internal(.disableList(false)))
                        }

                    case .removeImageButtonTapped:
                        state.alert = AlertState {
                            TextState("Remove Profile Image")
                        } actions: {
                            ButtonState(role: .destructive, action: .confirmRemoveImage) {
                                TextState("Remove")
                            }
                            ButtonState(role: .cancel, action: .dismissAlert) {
                                TextState("Cancel")
                            }
                        } message: {
                            TextState("Are you sure you want to remove your profile image?")
                        }
                        return .none
                }
            }

            // MARK: Internal Action Handler
            NestedAction(\.internal) { state, action in
                switch action {
                    case .binding:
                        return .none

                    case let .showProfileUpdatedCheckmark(value):
                        state.isProfileSubmitted = value
                        return .none

                    case let .disableList(value):
                        state.isDisabled = value
                        return .none

                    case let .imageUploadResponse(.success(url)):
                        state.user.profileImage = url
                        updateProfile(profileUser: state.user)
                        return .none

                    case let .imageUploadResponse(.failure(error)):
                        state.alert = AlertState {
                            TextState("Image Upload Failed")
                        } actions: {
                            ButtonState(action: .dismissAlert) {
                                TextState("OK")
                            }
                        } message: {
                            TextState(error.localizedDescription)
                        }
                        return .none

                    case let .didUpdateName(value):
                        state.user.fullName = value.trimmingCharacters(in: .whitespacesAndNewlines)
                        return .none

                    case let .didUpdateBio(value):
                        state.user.profileDescription = value.trimmingCharacters(in: .whitespacesAndNewlines)
                        return .none

                    case let .didUpdateEmail(value):
                        state.user.email = value.trimmingCharacters(in: .whitespacesAndNewlines)
                        return .none

                    case .didUpdateTwitter, .didUpdateInstagram:
                        return .none

                    case let .imagePicker(.delegate(.loadSingleImage(image, data))):
                        state.userImage = image
                        state.userImageData = data
                        return .none

                    case .alert(let action):
                        switch action {
                            case .presented(.confirmRemoveImage):
                                state.userImage = nil
                                state.userImageData = nil
                                state.user.profileImage = User.mock1.profileImage
                                updateProfile(profileUser: state.user)
                                return .none

                            case .presented(.dismissAlert):
                                return .none

                            case .dismiss:
                                return .none
                        }

                    default:
                        return .none
                }
            }
        }
        .ifLet(\.$alert, action: \.internal.alert)
    }

     func updateProfile(profileUser: User) {
        // API call here
        // Update local user
         @Shared(.user) var user
        $user.withLock { $0 = profileUser }
    }
}

public struct EditProfileView: View {
    @Bindable var store: StoreOf<EditProfile>
    @FocusState private var focusedField: FocusedField?

    enum FocusedField {
        case name, bio, email, twitter, instagram
    }

    public init(store: StoreOf<EditProfile>) {
        self.store = store
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            profileHeader

            Color.connectWalletGradient1.opacity(0.2)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea(edges: [.bottom])
#if os(iOS)
                .cornerRadius(24, corners: [.topLeft, .topRight])
#endif
                .ignoresSafeArea(edges: [.bottom])
                .overlay {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 32) {
                            HStack(alignment: .top) {
                                userImage
                                userImageWarningLabelAndButton
                            }
                            fields
                        }
                        .padding(20)
                    }
                }
        }
        .animation(.easeInOut, value: focusedField)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
#if os(iOS)
        .toolbar {
            toolbarContent
        }
        .navigationBarBackButtonHidden(true)
#endif
        .alert(
            store: store.scope(
                state: \.$alert,
                action: \.internal.alert
            )
        )
        .disabled(store.isDisabled)
        .overlay {
            if store.isDisabled {
                ProgressView()
            }
        }
    }

    @ViewBuilder
    private var fields: some View {
        ProfileTextField(
            title: "DISPLAY NAME",
            text: $store.user.fullName.sending(\.internal.didUpdateName)
        )
        .focused($focusedField, equals: .name)
        .id(FocusedField.name)
#if os(iOS)
        .keyboardType(.asciiCapable)
#endif

        ProfileTextField(
            title: "BIO",
            text: $store.user.profileDescription.sending(\.internal.didUpdateBio),
            textFieldHeight: 72
        )
        .focused($focusedField, equals: .bio)
        .id(FocusedField.bio)
#if os(iOS)
        .keyboardType(.asciiCapable)
#endif

        ProfileTextField(
            title: "EMAIL",
            text: $store.user.email.sending(\.internal.didUpdateEmail)
        )
        .focused($focusedField, equals: .email)
        .id(FocusedField.email)
#if os(iOS)
        .keyboardType(.emailAddress)
#endif

        ProfileTextField(
            title: "INSTAGRAM",
            text: .constant("@kohaku"),
            overlayImageName: "instagram",
            accessoryViewTapped: {}
        )
        .focused($focusedField, equals: .instagram)
        .id(FocusedField.instagram)

        ProfileTextField(
            title: "Twitter",
            text: .constant("@kohaku"),
            overlayImageName: "twitter",
            accessoryViewTapped: {}
        )
        .focused($focusedField, equals: .twitter)
        .id(FocusedField.twitter)
    }

    @ViewBuilder var userImageWarningLabelAndButton: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("We recommend an image of at least 800x800px.")
                .foregroundStyle(Color.neutral4)
                .font(.custom(FontName.poppinsRegular.rawValue, size: 14))
            Button(
                action: { store.send(.view(.removeImageButtonTapped)) },
                label: {
                    Text("Remove")
                        .foregroundStyle(Color.neutral2)
                        .font(.custom(FontName.dmSansBold.rawValue, size: 14))
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .overlay {
                            Capsule()
                                .stroke(Color.neutral5, lineWidth: 2)
                        }
                }
            )
            .clipShape(.capsule(style: .circular))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    @ViewBuilder var profileHeader: some View {
        HStack(spacing: 14) {
            Image(systemName: "checkmark")
                .foregroundStyle(Color.primary4)
                .frame(width: 10, height: 10)

            Text("Auto Saved")
                .foregroundStyle(Color.neutral3)
                .font(.custom(FontName.poppinsRegular.rawValue, size: 12))
        }
        .opacity(store.isProfileSubmitted ? 1 : 0)
        .animation(.easeIn, value: store.isProfileSubmitted)
        .padding(.horizontal, 30)
    }

    @ViewBuilder
    private var userImage: some View {
        ImagePickerView(
            store: store.scope(
                state: \.imagePicker,
                action: \.internal.imagePicker
            ),
            label: {
                Group {
                    switch store.userImage {
                        case .none:
                            if let imageURL = URL(string: store.user.profileImage) {
                                AsyncImageView(url: imageURL)
                            }
                            else {
                                Circle()
                            }
                        case .some(let image):
                            image
                                .resizable()
                    }
                }
                .scaledToFill()
                .clipShape(.circle)
                .frame(width: 92, height: 92)
            }
        )
    }

#if os(iOS)
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button(
                action: {
                    store.send(.view(.backButtonTapped))
                },
                label: {
                    HStack(spacing: 16) {
                        Circle()
                            .foregroundColor(Color.neutral6)
                            .frame(width: 32, height: 32)
                            .overlay {
                                Image(systemName: "chevron.backward")
                                    .resizable()
                                    .foregroundStyle(Color.neutral2)
                                    .frame(width: 7, height: 12)
                                    .font(.headline)
                            }

                        Text("Edit Profile")
                            .font(.custom(FontName.poppinsBold.rawValue, size: 24))
                            .foregroundStyle(Color.neutral2)
                    }
                }
            )
        }

        ToolbarItem(placement: .topBarTrailing) {
            Button(
                action: {
                    store.send(.view(.submitButtonTapped))
                },
                label: {
                    Text("Done")
                        .font(.custom(FontName.poppinsBold.rawValue, size: 12))
                        .foregroundStyle(Color.neutral8)
                        .padding(12)
                        .background(
                            Color.primary1
                                .clipShape(.capsule)
                        )
                }
            )
        }

        ToolbarItem(placement: .keyboard) {
            HStack {
                Button("Done") {
                    withAnimation {
                        focusedField = nil
                    }
                }
                Spacer()
            }
        }
    }
#endif

}

#Preview {
    NavigationStack {
        EditProfileView(
            store: .init(
                initialState: .init(user: .mock1),
                reducer: { EditProfile() }
            )
        )
    }
}
