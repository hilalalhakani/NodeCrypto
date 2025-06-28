//
//  RootCoordinator.swift
//  Main
//
//  Created by Hilal Hakkani on 31/05/2025.
//

import Dependencies
import Foundation
import Keychain
import NodeCryptoCore
import ResourceProvider
import SharedModels
import SwiftUI

@Reducer
public struct RootCoordinatorReducer: Sendable {

    public init() {}

    @Reducer(state: .sendable, .equatable, action: .sendable)
    public enum Path {
        case uploadImage(UploadImageReducer)
    }

    //MARK: State
    @ObservableState
    public struct State: Equatable, Sendable {
        public var path = StackState<Path.State>()
        var root: RootViewReducer.State = .init()
        @Shared(.isTabBarVisible) var isTabBarVisible
        public init() {}
    }

    //MARK: Action
    @CasePathable
    public enum Action: Sendable {
        case path(StackActionOf<Path>)
        case root(RootViewReducer.Action)
        case singleButtonPressed
    }

    public var body: some ReducerOf<Self> {

        Scope(state: \.root, action: \.root) {
            RootViewReducer()
        }

        Reduce { state, action in
            switch action {
                case .singleButtonPressed:
                    state.path.append(.uploadImage(.init()))
                    return .none

                case .path, .root:
                    return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}

@Reducer
public struct UploadImageReducer: Sendable {
    public init() {}

    @ObservableState
    public struct State: Equatable, Sendable {
        public init() {}
    }

    @CasePathable
    public enum Action: Sendable {
        case dismiss
    }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .dismiss:
                return .none
            }
        }
    }
}

//MARK: RootCoordinatorView
public struct RootCoordinatorView: View {
    @Bindable var store: StoreOf<RootCoordinatorReducer>

    public init(store: StoreOf<RootCoordinatorReducer>) {
        self.store = store
    }

    public var body: some View {
        RootView(store: store.scope(state: \.root, action: \.root))
            .frame(maxHeight: .infinity)
            .onAppear {
                store.send(.singleButtonPressed)
            }
    }
}
