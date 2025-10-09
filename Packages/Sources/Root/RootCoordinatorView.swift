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

    //MARK: State
    @ObservableState
    public struct State: Equatable, Sendable {
        var root: RootViewReducer.State = .init()
        public init() {}
    }

    //MARK: Action
    @CasePathable
    public enum Action: Sendable {
        case root(RootViewReducer.Action)
    }

    public var body: some ReducerOf<Self> {

        Scope(state: \.root, action: \.root) {
            RootViewReducer()
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
    }
}
