//
//  File.swift
//
//
//  Created by Hilal Hakkani on 05/06/2024.
//

import Dependencies
import Foundation
import NodeCryptoCore
import SharedModels
import SwiftUI

@Reducer
public struct HomeCoordinatorReducer: Sendable {

    public init() {}

    @Reducer(state: .sendable, .equatable, action: .sendable)
    public enum Path {
        case allCreators(AllCreatorsReducer)
    }

    //MARK: State
    @ObservableState
    public struct State: Equatable, Sendable {
        public var path = StackState<Path.State>()
        var home: HomeReducer.State = .init()
        public init() {}
    }

    //MARK: Action
    @CasePathable
    public enum Action: Sendable {
        case path(StackActionOf<Path>)
        case home(HomeReducer.Action)
    }

    public var body: some ReducerOf<Self> {

        Scope(state: \.home, action: \.home) {
            HomeReducer()
        }

        Reduce { state, action in
            switch action {
            case .path(.popFrom):
                return .none

            case .home(.delegate(.navigateToAllCreators(let creators))):
                state.path.append(.allCreators(.init(creators: creators)))
                return .none

            case .home:
                return .none

            case .path:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}

//MARK: HomeView
public struct HomeCoordinatorView: View {
    @Bindable var store: StoreOf<HomeCoordinatorReducer>

    public init(store: StoreOf<HomeCoordinatorReducer>) {
        self.store = store
    }

    public var body: some View {
        NavigationStack(
            path: $store.scope(state: \.path, action: \.path)
        ) {
            HomeView(store: store.scope(state: \.home, action: \.home))
        } destination: { store in
            switch store.case {
            case let .allCreators(allCreatorsStore):
                AllCreatorsView(store: allCreatorsStore)
            }
        }
    }
}
