//
//  File.swift
//
//
//  Created by Hilal Hakkani on 03/06/2024.
//

import APIClient
import Combine
import Dependencies
import Foundation
import Keychain
import NodeCryptoCore
import PhotosUI
import ResourceProvider
import SharedModels
import SwiftUI
import UIKit

@Reducer
public struct EditProfileReducer {
    public init() {}
    @ObservableState
    public struct State: Equatable {
        @ObservationStateIgnored var user: User
        var profileSubmitted = false
        var userImageData: Data?

        public init(user: User) {
            self.user = user
        }
    }

    //MARK: Action
    @CasePathable
    public enum Action: TCAFeatureAction {
        case view(ViewAction)
        case `internal`(InternalAction)
        case delegate(DelegateAction)
    }

    //MARK: Internal Actions
    @CasePathable
    public enum InternalAction: BindableAction {
        case binding(BindingAction<State>)
        case showCheckMark(Bool)
        case onNameChanged(String)
        case onBioChanged(String)
        case onEmailChanged(String)
        case onTwitterChanged(String)
        case onInstagramChanged(String)
    }

    //MARK: Delegate Actions
    @CasePathable
    public enum DelegateAction {
        case backButtonPressed
    }

    @CasePathable
    public enum ViewAction {
        case backButtonPressed
        case submitPressed
        case onImageSelection(Data)
    }

    public var body: some ReducerOf<Self> {

        CombineReducers {

            BindingReducer(action: \.internal)

            //MARK: View Action Handler
            NestedAction(\.view) { state, action in
                switch action {
                    case .backButtonPressed:
                        return .send(.delegate(.backButtonPressed))

                    case .submitPressed:
                        return .run { [state] send in
                            @Dependency(\.userManager) var userManager
                            do {

                                var user = state.user

                                if let data = state.userImageData {
                                    @Dependency(\.imageUploader) var imageUploader
                                    let url = try await imageUploader.uploadImage(data)
                                    user.profileImage = url
                                }

                                await userManager.$user.withLock { [user] in
                                    $0 = user
                                }
                                await send(.internal(.showCheckMark(true)))
                            }
                            catch {
                                print(error)
                            }
                        }

                    case .onImageSelection(let data):
                        state.userImageData = data
                        return .none
                }
            }

            //MARK: Internal Action Handler
            NestedAction(\.internal) { state, action in
                switch action {
                    case .binding:
                        return .none
                    case .showCheckMark(let value):
                        state.profileSubmitted = value
                        return .none
                    case .onNameChanged(let value):
                        state.user.fullName = value
                        return .none

                    case .onBioChanged(let value):
                        state.user.profileDescription = value
                        return .none

                    case .onEmailChanged(let value):
                        state.user.email = value
                        return .none

                    case .onTwitterChanged(_):
                        return .none

                    case .onInstagramChanged(_):
                        return .none

                }
            }
        }

    }
}

public struct EditProfileView: View {
    @Perception.Bindable var store: StoreOf<EditProfileReducer>
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: Image? = nil
    @Dependency(\.userManager) var userManager
    @FocusState private var focusedField: FocusedField?

    enum FocusedField {
        case name, bio, email, twitter, instagram
    }

    public init(store: StoreOf<EditProfileReducer>) {
        self.store = store
    }

    public var body: some View {
        WithPerceptionTracking {
            VStack(alignment: .leading, spacing: 20) {
                profileHeader

                Color.connectWalletGradient1.opacity(0.2)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea(edges: [.bottom])
                    .cornerRadius(24, corners: [.topLeft, .topRight])
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
        }
    }

    @ViewBuilder
    private var fields: some View {
        ProfileTextField(
            title: "DISPLAY NAME",
            text: $store.user.fullName.sending(\.internal.onNameChanged)
        )
        .focused($focusedField, equals: .name)
        .id(FocusedField.name)
        .keyboardType(.asciiCapable)

        ProfileTextField(
            title: "BIO",
            text: $store.user.profileDescription.sending(\.internal.onBioChanged),
            textFieldHeight: 72
        )
        .focused($focusedField, equals: .bio)
        .id(FocusedField.bio)
        .keyboardType(.asciiCapable)

        ProfileTextField(
            title: "EMAIL",
            text: $store.user.email.sending(\.internal.onEmailChanged)
        )
        .focused($focusedField, equals: .email)
        .id(FocusedField.email)
        .keyboardType(.emailAddress)

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
                action: {},
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
        .opacity(store.profileSubmitted ? 1 : 0)
        .animation(.easeIn, value: store.profileSubmitted)
        .padding(.horizontal, 30)
    }

    @ViewBuilder
    private var userImage: some View {
        PhotosPicker(
            selection: $selectedItem,
            matching: .images,
            photoLibrary: .shared()
        ) {
            Group {
                if selectedItem.isNil,
                    let userProfileImage = userManager.user?.profileImage,
                   let url = URL(string: userProfileImage)
                {
                    AsyncImageView(url: url)
                }
                else {
                    selectedImage?
                        .resizable()
                }
            }
            .scaledToFill()
            .frame(width: 92, height: 92)
            .clipShape(.circle)
        }
        .frame(width: 92, height: 92)
        .buttonStyle(.plain)
        .onChange(of: selectedItem) { newItem in
            Task {
                if let image = try? await newItem?.loadTransferable(type: Image.self),
                    let imageData = try? await newItem?
                        .loadTransferable(
                            type: Data.self
                        )
                {
                    selectedImage = image
                    store.send(.view(.onImageSelection(imageData)))
                }
            }
        }
    }

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        #if os(iOS)
            ToolbarItem(placement: .topBarLeading) {
                Button(
                    action: {
                        store.send(.view(.backButtonPressed))
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
                        store.send(.view(.submitPressed))
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
        #endif
    }
}

struct KeyboardAwareModifier: ViewModifier {
    @State private var keyboardHeight: CGFloat = 0

    var keyboardHeightPublisher: AnyPublisher<CGFloat, Never> {
        Publishers
            .Merge(
                NotificationCenter
                    .default
                    .publisher(for: UIResponder.keyboardWillShowNotification)
                    .compactMap {
                        $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
                    }
                    .map { $0.cgRectValue.height },
                NotificationCenter
                    .default
                    .publisher(for: UIResponder.keyboardWillHideNotification)
                    .map { _ in 0 }
            )
            .eraseToAnyPublisher()
    }
    func body(content: Content) -> some View {
        content
            .padding(.bottom, keyboardHeight)
            .onReceive(keyboardHeightPublisher) { height in
                withAnimation { self.keyboardHeight = height }
            }
    }
}

extension View {
    func adaptsKeyboard() -> some View {
        self.modifier(KeyboardAwareModifier())
    }
}

#Preview {
    NavigationStack {
        EditProfileView(
            store: .init(
                initialState: .init(user: .mock1),
                reducer: { EditProfileReducer() }
            )
        )
    }
}
