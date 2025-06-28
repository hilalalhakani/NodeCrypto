//
//  File.swift
//
//
//  Created by Hilal Hakkani on 05/06/2024.
//

import Dependencies
import Foundation
import Keychain
import NodeCryptoCore
import ResourceProvider
import SharedModels
import SwiftUI

@Reducer
public struct ProfileCoordinatorReducer: Sendable {

    public init() {}

    @Reducer(state: .sendable, .equatable, action: .sendable)
    public enum Path {
        case editProfile(EditProfile)
    }

    //MARK: State
    @ObservableState
    public struct State: Equatable, Sendable {
        public var path = StackState<Path.State>()
        var profile: ProfileReducer.State = .init()
        @Shared(.isTabBarVisible) var isTabBarVisible
        public init() {}
    }

    //MARK: Action
    @CasePathable
    public enum Action: Sendable {
        case path(StackActionOf<Path>)
        case profile(ProfileReducer.Action)
        case navigateToEditScreen
        case menuButtonPressed
    }

    public var body: some ReducerOf<Self> {

        Scope(state: \.profile, action: \.profile) {
            ProfileReducer()
        }

        Reduce { state, action in
            switch action {
                case .navigateToEditScreen:
                    @Shared(.user) var user
                    if let user {
                        state.path.append(.editProfile(.init(user: user)))
                    }
                    state.$isTabBarVisible.withLock({ $0 = false })
                    return .none

                case .profile(.delegate(.menuButtonPressed)):
                    return .send(.menuButtonPressed)

                case .profile(.view(.menuButtonPressed)):
                    return .send(.menuButtonPressed)

                case .path(.element(id: _, action: .editProfile(.delegate(.didTapBack)))):
                    _ = state.path.popLast()
                    state.$isTabBarVisible.withLock({ $0 = true })
                    return .none

                case .path:
                    return .none

                case .profile:
                    return .none
                case .menuButtonPressed:
                    return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}

//MARK: ProfileView
public struct ProfileCoordinatorView: View {
    @Bindable var store: StoreOf<ProfileCoordinatorReducer>
    @Shared(.isTabBarVisible) var isTabBarVisible

    public init(store: StoreOf<ProfileCoordinatorReducer>) {
        self.store = store
    }

    public var body: some View {
        NavigationStack(
            path: $store.scope(state: \.path, action: \.path)
        ) {
            ProfileView(store: store.scope(state: \.profile, action: \.profile))
                .toolbar(isTabBarVisible ? .visible : .hidden, for: .tabBar)
        } destination: { store in
            switch store.case {
                case let .editProfile(editProfileStore):
                    EditProfileView(store: editProfileStore)
            }
        }
        .frame(maxHeight: .infinity)
    }
}
