import Combine
import ConnectWalletFeature
import Keychain
import NodeCryptoCore
import OnboardingFeature
import Root
import SharedModels
import SwiftUI

@Reducer
public struct AppViewReducer {
    @Dependency(\.logger) var logger
    @Shared(.user) var user
    @Dependency(\.mainQueue) var mainQueue

    public init() {}

    @ObservableState
    public struct State: Equatable, Sendable {
        public var appDelegate = AppDelegateReducer.State()
        @Presents public var destination: Destination.State? = .launchImage
        public init() {}
    }

    @CasePathable
    public enum Action: TCAFeatureAction {
        case view(ViewAction)
        case `internal`(InternalAction)
        case delegate(DelegateAction)
    }

    @CasePathable
    public enum InternalAction {
        case destination(PresentationAction<Destination.Action>)
        case appDelegate(AppDelegateReducer.Action)
        case userChanged
    }

    @CasePathable
    public enum DelegateAction {}

    @CasePathable
    public enum ViewAction {
        case onAppear
    }

    public var body: some ReducerOf<Self> {
        CombineReducers {

            Scope(state: \.appDelegate, action: \.internal.appDelegate) {
                AppDelegateReducer()
            }

            NestedAction(\.view) { state, viewAction in
                switch viewAction {
                    case .onAppear:
                        return .publisher {
                            $user.publisher
                                .receive(on: mainQueue)
                                .map({ $0 == nil })
                                .removeDuplicates()
                                .map { _ in Action.internal(.userChanged) }
                        }
                }
            }

            NestedAction(\.internal) { state, internalAction in
                switch internalAction {
                    case .destination(
                        .presented(.onboarding(.delegate(.onGetStartedButtonPressed)))
                    ):
                        state.destination = .connectWallet(.init())
                        return .none

                    case .destination:
                        return .none

                    case .appDelegate:
                        return .none
                    case .userChanged:
                        @Shared(.user) var user
                        if user != nil {
                            state.destination = .rootView(.init())
                        }
                        else {
                            state.destination = .onboarding(.init())
                        }
                        return .none
                }
            }
        }
        .ifLet(\.$destination, action: \.internal.destination)
    }

    @Reducer(state: .equatable, .sendable)
    public enum Destination {
        case onboarding(OnboardingViewReducer)
        case launchImage
        case connectWallet(ConnectWalletReducer)
        case rootView(RootViewReducer)
    }
}

//extension  AppViewReducer.Destination: Equatable {}

public struct AppView: View {
    public let store: StoreOf<AppViewReducer>

    public init(store: StoreOf<AppViewReducer>) {
        self.store = store
    }

    public var body: some View {
        destination
            .transition(.opacity.animation(.easeInOut))
            .task {
                store.send(.view(.onAppear))
            }
    }

    @ViewBuilder
    private var destination: some View {
        switch store.state.destination {
            case .onboarding:
                if let onboardingStore = store.scope(
                    state: \.destination?.onboarding,
                    action: \.internal.destination.onboarding
                ) {
                    OnboardingView(store: onboardingStore)
                }
            case .launchImage:
                LaunchImageView()

            case .connectWallet:
                if let connectWalletStore = store.scope(
                    state: \.destination?.connectWallet,
                    action: \.internal.destination.connectWallet
                ) {
                    NavigationStack {
                        ConnectWalletView(store: connectWalletStore)
                    }
                }

            case .rootView:
                if let rootViewStore = store.scope(
                    state: \.destination?.rootView,
                    action: \.internal.destination.rootView
                ) {
                    RootView(store: rootViewStore)
                }

            default:
                EmptyView()
        }
    }
}
