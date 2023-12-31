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

    @ObservableState
    public struct State: Equatable {
        public var appDelegate = AppDelegateReducer.State()
        public var destination: Destination.State?
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
        case onKeychainUser(Result<User, Error>)
        case destination(Destination.Action)
        case appDelegate(AppDelegateReducer.Action)
    }

    @CasePathable
    public enum DelegateAction {}

    @CasePathable
    public enum ViewAction {
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

    public struct Destination: Reducer {
        @CasePathable
        public enum State: Equatable {
            case onboarding(OnboardingViewReducer.State)
            case launchImage
            case connectWallet(ConnectWalletReducer.State)
        }

        @CasePathable
        public enum Action {
            case onboarding(OnboardingViewReducer.Action)
            case connectWallet(ConnectWalletReducer.Action)
        }

        public var body: some ReducerOf<Self> {

            Scope(state: \.onboarding, action: \.onboarding) {
                OnboardingViewReducer()
            }

            Scope(state: \.connectWallet, action: \.connectWallet) {
                ConnectWalletReducer()
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
                         then: { store in
                             NavigationStack {
                                 ConnectWalletView(store: store)
                             }
                             .transition(.opacity.animation(.easeInOut))
                          }
                    )

                }
            }
        }
        .task { store.send(.view(.onAppear)) }
    }
}
