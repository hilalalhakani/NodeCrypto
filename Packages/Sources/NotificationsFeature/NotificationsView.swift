//
//  SwiftUIView.swift
//  
//
//  Created by Hilal Hakkani on 01/09/2024.
//

import SwiftUI
import APIClient
import Dependencies
import Keychain
import AuthenticationClient
import ComposableArchitecture
import SharedModels
import TCAHelpers
import StyleGuide
import SharedViews

@Reducer
public struct NotificationReducer {

    public enum ItemsState: Equatable, Sendable {
        case empty
        case loaded
        case loading
    }

    public init() {}
    @Dependency(\.apiClient.profile) var profileAPI
    @Shared(.user) var user

    //MARK: State
    @ObservableState
    public struct State: Equatable, Sendable {
        var itemsState: ItemsState = .loading
        var notifications: IdentifiedArrayOf<SharedModels.Notification> = .init()
        public init() {}

        public init(itemsState: ItemsState, notifications: [SharedModels.Notification]) {
            self.itemsState = itemsState
            self.notifications  = .init(uniqueElements: notifications)
        }

    }

    //MARK: Action
    @CasePathable
    public enum Action: TCAFeatureAction, Sendable {
        case view(ViewAction)
        case `internal`(InternalAction)
        case delegate(DelegateAction)
    }

    //MARK: Internal Actions
    @CasePathable
    public enum InternalAction: Sendable {
        case onGetNotifications(Result<[SharedModels.Notification], Error>)
    }

    //MARK: Delegate Actions
    @CasePathable
    public enum DelegateAction: Sendable {}

    @CasePathable
    public enum ViewAction: Sendable {
        case onAppear
    }

    public var body: some ReducerOf<Self> {

        //MARK: Internal Action Handler
        NestedAction(\.internal) { state, action in
            switch action {
                case .onGetNotifications(.success(let nfts)):
                    state.itemsState = nfts.isEmpty ? .empty : .loaded
                    state.notifications = .init(uniqueElements: nfts)
                    return .none

                case .onGetNotifications(.failure):
                    state.itemsState = .empty
                    return .none
            }
        }

        //MARK: View Action Handler
        NestedAction(\.view) { state, action in
            switch action {
                case .onAppear:
                    return .run { [profileAPI]send in
                        await send(
                            .internal(
                                .onGetNotifications(
                                    .init(catching: {
                                        try await profileAPI.getNotifications()
                                    })
                                )
                            )
                        )
                    }
            }
        }

    }


}

public struct NotificationsView: View {

    @Bindable var store: StoreOf<NotificationReducer>

    public init(store: StoreOf<NotificationReducer>) {
        self.store = store
    }

    public var body: some View {
            VStack(alignment: .leading) {
                Text("Notifications")
                    .foregroundStyle(Color.neutral2)
                    .font(.custom(FontName.poppinsBold.rawValue, size: 24))
                    .padding(.horizontal, 16)
                Group {
                    switch store.itemsState {
                        case .loading:
                            ProgressView()
                        case .loaded:
                            notificationsList
                        case .empty:
                            emptyView
                    }
                }
                .transition(.opacity.animation(.easeInOut))
                .frame(maxWidth: .infinity ,maxHeight: .infinity)

            .task {
                store.send(.view(.onAppear))
            }
        }
    }

    var emptyView: some View {
        VStack {
            Image(.emptyNotifications)
            Text("No recents")
                .foregroundStyle(Color.neutral2)
                .font(.custom(FontName.dmSansBold.rawValue, size: 40))
            Button(action: {}, label: {
                Text("Get Home")
            })
            .buttonStyle(.borderedProminent)
            .foregroundStyle(Color.neutral8)
            .font(.custom(FontName.dmSansBold.rawValue, size: 16))
            .tint(Color.neutral1)
            .clipShape(.capsule)
        }
    }

    var notificationsList: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(store.notifications) { notification in
                    HStack(spacing: 12) {
                        Circle()
                            .foregroundStyle(Color.primary1)
                            .frame(width: 8, height: 8)

                        RemoteImageView(url: .init(string: notification.senderImageURLString)!)
                            .clipShape(.circle)
                            .frame(width: 42, height: 42)

                        VStack(alignment: .leading) {
                            HStack {
                                Text(notification.senderName)
                                    .foregroundStyle(Color.neutral2)
                                    .font(.custom(FontName.poppinsBold.rawValue, size: 14))
                                    .lineLimit(1)
                                Text("followed you")
                                    .foregroundStyle(Color.neutral4)
                                    .font(.custom(FontName.poppinsBold.rawValue, size: 14))
                                    .layoutPriority(1)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)

                            Text(notification.date)
                                .foregroundStyle(Color.neutral4)
                                .font(.custom(FontName.poppinsRegular.rawValue, size: 12))
                        }
                        Button(action: {}, label: {
                            Text("Follow")
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                        })
                        .foregroundStyle(Color.neutral2)
                        .font(.custom(FontName.dmSansBold.rawValue, size: 12))
                        .tint(.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 90, style: .circular)
                                .inset(by: 1)
                                .stroke(Color.neutral6)
                        )
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 16)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    NotificationsView(
        store: .init(initialState: .init(), reducer: { NotificationReducer() })
    )
}
