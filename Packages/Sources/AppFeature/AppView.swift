import ConnectWalletFeature
import Keychain
import NodeCryptoCore
import OnboardingFeature
import SharedModels
import SwiftUI

@Reducer
public struct AppViewReducer {
    @Dependency(\.decode) var decode
    @Dependency(\.logger) var logger
    @Dependency(\.keychainManager) var keychainManager
    @Dependency(\.user) var currentUser

    public init() {}

    public struct Destination: Reducer {
        @CasePathable
        public enum State: Equatable {
            public static func == (lhs: AppViewReducer.Destination.State, rhs: AppViewReducer.Destination.State) -> Bool {
                switch (lhs, rhs) {
                case (.launchImage, .launchImage):
                    return true
                case (.onboarding(let stateLhs), .onboarding(let stateRhs)):
                    return stateLhs == stateRhs
                case (.connectWallet(let stateLhs), .connectWallet(let stateRhs)):
                    return stateLhs == stateRhs
                default:
                    return false
                }
            }

            case onboarding(OnboardingViewReducer.State)
            case launchImage
            case connectWallet(ConnectWalletReducer.State)
        }

        @CasePathable
        public enum Action: Equatable {
            public static func == (lhs: AppViewReducer.Destination.Action, rhs: AppViewReducer.Destination.Action) -> Bool {
                switch (lhs, rhs) {
                case (.onboarding(let lhsAction), .onboarding(let rhsAction)):
                    return lhsAction == rhsAction
                case (.connectWallet(let lhsAction), .connectWallet(let rhsAction)):
                    return lhsAction == rhsAction
                default:
                    return false
                }
            }

            case onboarding(OnboardingViewReducer.Action)
            case connectWallet(ConnectWalletReducer.Action)
        }

        public var body: some ReducerOf<Self> {
            EmptyReducer()
                .ifCaseLet(\.onboarding, action: \.onboarding) {
                    OnboardingViewReducer()
                }
                .ifCaseLet(\.connectWallet, action: \.connectWallet) {
                    ConnectWalletReducer()
                }
        }
    }

    @ObservableState
    public struct State: Equatable {
        public static func == (lhs: AppViewReducer.State, rhs: AppViewReducer.State) -> Bool {
            lhs.appDelegate == rhs.appDelegate && lhs.destination == rhs.destination
        }
        public var appDelegate = AppDelegateReducer.State()
        public var destination: Destination.State?
        public init() {}
    }

    public enum Action: TCAFeatureAction, Equatable {
        case view(ViewAction)
        case `internal`(InternalAction)
        case delegate(DelegateAction)

        public static func == (lhs: Action, rhs: Action) -> Bool {
            switch (lhs, rhs) {
            case (.view(let lhsAction), .view(let rhsAction)):
                return lhsAction == rhsAction
            case (.internal(let lhsAction), .internal(let rhsAction)):
                return lhsAction == rhsAction
            case (.delegate(let lhsAction), .delegate(let rhsAction)):
                return lhsAction == rhsAction
            default:
                return false
            }
        }
    }

    @CasePathable
    public enum InternalAction: Equatable {
        case onKeychainUser(Result<User, Error>)
        case destination(Destination.Action)
        case appDelegate(AppDelegateReducer.Action)

        public static func == (lhs: InternalAction, rhs: InternalAction) -> Bool {
            switch (lhs, rhs) {
            case (.onKeychainUser(let lhsResult), .onKeychainUser(let rhsResult)):

                switch (lhsResult, rhsResult) {
                case (.success(let lhsData), .success(let rhsData)):
                    return lhsData == rhsData
                case (.failure, .failure):
                    return true
                default:
                    return false
                }

            case (.destination(let lhsAction), .destination(let rhsAction)):
                return lhsAction == rhsAction

            case (.appDelegate(let lhsAction), .appDelegate(let rhsAction)):
                return lhsAction == rhsAction

            default:
                return false
            }
        }
    }

    public enum DelegateAction: Equatable {}

    @CasePathable
    public enum ViewAction: Equatable {
        case onAppear
    }

    public var body: some ReducerOf<Self> {
        Scope(state: \.appDelegate, action: \.internal.appDelegate) {
            AppDelegateReducer()
        }

        .ifLet(\.destination, action: \.internal.destination) {
            Destination()
        }

        Reduce { state, action in
            switch action {
            case let .view(viewAction):
                switch viewAction {
                case .onAppear:

                    return .run { send in
                        await send(
                            .internal(
                                .onKeychainUser(
                                    Result(catching: {
                                        let data = try await keychainManager.get(.user)
                                        return try decode(User.self, from: data)
                                    })
                                )
                            )
                        )
                    }
                }

            case .delegate:
                return .none

            case let .internal(internalAction):
                switch internalAction {
                case let .onKeychainUser(.success(user)):
                    _ = user
                    return .none

                case let .onKeychainUser(.failure(error)):
                    if (error as? KeychainManager.Error) != .itemNotFound {
                        logger.log(level: .error, "\(error.localizedDescription)")
                    }
                    state.destination = .onboarding(.init())
                    return .none

                case .destination(.onboarding(.delegate(.onGetStartedButtonPressed))):
                    state.destination = .connectWallet(.init())
                    return .none

                case .destination:
                    return .none

                case .appDelegate:
                    return .none
                }
            }
        }
    }
}

public struct AppView: View {
    public let store: StoreOf<AppViewReducer>

    public init(store: StoreOf<AppViewReducer>) {
        self.store = store
    }

    public var body: some View {
        IfLetStore(self.store.scope(state: \.destination, action: \.internal.destination)) { store in
            SwitchStore(store) { initialState in
                switch initialState {
                case .onboarding:
                    CaseLet(
                        /AppViewReducer.Destination.State.onboarding,
                         action: AppViewReducer.Destination.Action.onboarding,
                         then: OnboardingView.init
                    )
                case .launchImage:
                    LaunchImageView()

                case .connectWallet:
                    CaseLet(
                        /AppViewReducer.Destination.State.connectWallet,
                         action: AppViewReducer.Destination.Action.connectWallet,
                         then: ConnectWalletView.init
                    )

                }
            }
        }
        .task { store.send(.view(.onAppear)) }
    }
}
