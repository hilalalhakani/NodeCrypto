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
        case editProfile(EditProfileReducer)
    }

    //MARK: State
    @ObservableState
    public struct State: Equatable, Sendable {
        public var path = StackState<Path.State>()
        var profile: ProfileReducer.State
        let user: User
        @Shared(.isTabBarVisible) var isTabBarVisible: Bool = true

        public init(user: User) {
            profile = .init()
            self.user = user
        }
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

        CombineReducers {

            Scope(state: \.profile, action: \.profile) {
                ProfileReducer()
            }

            Reduce { state, action in
                switch action {
                    case .navigateToEditScreen:
                        @Dependency(\.userManager) var userManager
                        if let user = userManager.user {
                            state.path.append(.editProfile(.init(user: user)))
                        }
                        state.isTabBarVisible = false
                        return .none

                    case .profile(.delegate(.menuButtonPressed)):
                        return .send(.menuButtonPressed)

                    case .profile(.view(.menuButtonPressed)):
                        return .send(.menuButtonPressed)

                    case .path(.element(id: _, action: .editProfile(.delegate(.backButtonPressed)))):
                        _ = state.path.popLast()
                        state.isTabBarVisible = true
                        return .none

                    case .path:
                        return .none
                        
                    case .profile:
                        return .none
                    case .menuButtonPressed:
                        return .none
                }
            }

        }
        .forEach(\.path, action: \.path)
    }
}

//MARK: ProfileView
public struct ProfileCoordinatorView: View {
    @Perception.Bindable var store: StoreOf<ProfileCoordinatorReducer>

    public init(store: StoreOf<ProfileCoordinatorReducer>) {
        self.store = store
    }
    public var body: some View {
        WithPerceptionTracking {
            NavigationStack(
                path: $store.scope(state: \.path, action: \.path)
            ) {
                ProfileView(store: store.scope(state: \.profile, action: \.profile))
            } destination: { store in
                switch store.case {
                    case let .editProfile(editProfileStore):
                         EditProfileView(store: editProfileStore)
#if os(iOS)
                            .toolbar(.hidden, for: .tabBar)
#endif
                }
            }
            .frame(maxHeight: .infinity)
        }
    }
}
