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
    //    @Dependency(\.decode) var decode
    @Dependency(\.logger) var logger
    //    @Dependency(\.keychainManager) var keychainManager
    //    @Dependency(\.user) var currentUser
    @Dependency(\.userManager) var userManager
    @Dependency(\.mainQueue) var mainQueue

    public init() {}

    @ObservableState
    public struct State: Equatable {
        //        @Shared(.keychain(.user)) var keychainUser: User?
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
        case userChanged(User?)
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
                        if let user = userManager.user {
                            state.destination = .rootView(.init(user: user))
                        }
                        else {
                            state.destination = .onboarding(.init())
                        }

                        return .publisher {
                            userManager.publisher
                                .receive(on: mainQueue)
                                .map { Action.internal(.userChanged($0)) }
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
                    case .userChanged(let user):
                        if let user {
                            state.destination = .rootView(.init(user: user))
                        }
                        else {
                            state.destination = .onboarding(.init())
                        }
                        return .none
                }
            }
        }
        .ifLet(\.$destination, action: \.internal.destination)
        //        .subscribe(
        //            to: currentUser._stream,
        //            on: \.view.onAppear,
        //            with: \.internal.userChanged
        //        )
    }

    @Reducer(state: .equatable)
    public enum Destination {
        case onboarding(OnboardingViewReducer)
        case launchImage
        case connectWallet(ConnectWalletReducer)
        case rootView(RootViewReducer)
    }
}

public struct AppView: View {
    public let store: StoreOf<AppViewReducer>

    public init(store: StoreOf<AppViewReducer>) {
        self.store = store
    }

    public var body: some View {
        WithPerceptionTracking {
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
                        .transition(.opacity.animation(.easeInOut))
                    }

                case .rootView:
                    if let rootViewStore = store.scope(
                        state: \.destination?.rootView,
                        action: \.internal.destination.rootView
                    ) {
                        RootView(store: rootViewStore)
                            .transition(.opacity.animation(.easeInOut))
                    }

                default:
                    EmptyView()
            }
        }
        .task {
            store.send(.view(.onAppear))
        }
    }
}
