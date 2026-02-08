import Combine
import ConnectWalletFeature
import Keychain
import OnboardingFeature
import Root
import SharedModels
import SwiftUI
import ComposableArchitecture
import TCAHelpers

@Reducer
public struct AppFeature {
    @Dependency(\.logger) var logger
    @Shared(.user) var user
    @Dependency(\.mainQueue) var mainQueue

    public init() {}

    @ObservableState
    public struct State: Equatable, Sendable {
        public var appDelegate = AppDelegateFeature.State()
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
        case appDelegate(AppDelegateFeature.Action)
        case destination(PresentationAction<Destination.Action>)
        case userChanged
    }

    @CasePathable
    public enum DelegateAction {}

    @CasePathable
    public enum ViewAction {
        case onAppear
    }

    public var body: some ReducerOf<Self> {
        Scope(state: \.appDelegate, action: \.internal.appDelegate) {
            AppDelegateFeature()
        }
        .ifLet(\.$destination, action: \.internal.destination)

        Reduce { state, action in
            switch action {
            case let .view(viewAction):
                switch viewAction {
                case .onAppear:
                    return .run { [user = $user] send in
                        for await _ in user.publisher.map({ $0 == nil }).removeDuplicates().values {
                            await send(.internal(.userChanged))
                        }
                    }
                }

            case let .internal(internalAction):
                switch internalAction {
                case let .destination(.presented(destinationAction)):
                    switch destinationAction {
                    case .onboarding(.delegate(.onGetStartedButtonPressed)):
                        state.destination = .connectWallet(.init())
                        return .none
                    default:
                        return .none
                    }

                case .destination:
                    return .none

                case .appDelegate:
                    return .none

                case .userChanged:
                    @Shared(.user) var user
                    state.destination = user != nil ? .rootView(.init()) : .onboarding(.init())
                    return .none
                }

            case .delegate:
                return .none
            }
        }
    }

    @Reducer
    public enum Destination {
        case connectWallet(ConnectWalletFeature)
        case launchImage
        case onboarding(OnboardingFeature)
        case rootView(RootFeature)
    }
}

extension AppFeature.Destination.State: Sendable, Equatable {}

public struct AppView: View {
    @Bindable var store: StoreOf<AppFeature>

    public init(store: StoreOf<AppFeature>) {
        self.store = store
    }

    public var body: some View {
        Group {
            if let destinationStore = store.scope(
                state: \.destination,
                action: \.internal.destination.presented
            ) {
                switch destinationStore.case {
                    case let .onboarding(childStore):
                        OnboardingView(store: childStore)
                    case let .connectWallet(childStore):
                        ConnectWalletView(store: childStore)
                    case let .rootView(childStore):
                        RootView(store: childStore)
                    case .launchImage:
                        LaunchImageView()
                }
            }
        }
        .transition(.opacity.animation(.easeInOut))
        .task {
            store.send(.view(.onAppear))
        }
    }
}
