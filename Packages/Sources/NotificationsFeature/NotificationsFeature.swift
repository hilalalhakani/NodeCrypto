import Foundation
import NodeCryptoCore
import SwiftUI

@Reducer
public struct NotificationsScreenReducer: Sendable {
    public init() {}

    @ObservableState
    public struct State: Equatable, Sendable {
        public init() {}
    }

    @CasePathable
    public enum Action: TCAFeatureAction, Sendable {
        case view(ViewAction)
        case `internal`(InternalAction)
        case delegate(DelegateAction)
    }

    @CasePathable
    public enum ViewAction: Sendable {
        case onAppear
    }

    @CasePathable
    public enum InternalAction: Sendable {
        case none
    }

    @CasePathable
    public enum DelegateAction: Sendable {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(.onAppear):
                return .none
            case .internal(.none):
                return .none
            }
        }
    }
}

public struct NotificationsScreen: View {
    let store: StoreOf<NotificationsScreenReducer>

    public init(store: StoreOf<NotificationsScreenReducer>) {
        self.store = store
    }

    public var body: some View {
        VStack(spacing: 20) {
            Text("Notifications")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("No notifications yet")
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .task {
            store.send(.view(.onAppear))
        }
    }
}
