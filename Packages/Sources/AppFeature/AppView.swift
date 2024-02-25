import ConnectWalletFeature
import Keychain
import NodeCryptoCore
import OnboardingFeature
import Root
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
    case onKeychainUser(Result<User, Error>)
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
      }

      NestedAction(\.internal) { state, internalAction in
        switch internalAction {
        case .onKeychainUser(.success(let user)):
            currentUser.set(user)
          state.destination = .rootView(.init())
          return .none

        case let .onKeychainUser(.failure(error)):
          if (error as? KeychainManager.Error) != .itemNotFound {
            logger.log(level: .error, "\(error.localizedDescription)")
          }
          state.destination = .onboarding(.init())
          return .none

        case .destination(.presented(.onboarding(.delegate(.onGetStartedButtonPressed)))):
          state.destination = .connectWallet(.init())
          return .none

        case .destination:
          return .none

        case .appDelegate:
          return .none
        case .userChanged(let user):
          state.destination = user == nil ? .onboarding(.init()) : .rootView(.init())
          return .none
        }
      }
    }
    .ifLet(\.$destination, action: \.internal.destination) {
      Destination()
    }
    .subscribe(
      to: currentUser._stream,
      on: \.view.onAppear,
      with: \.internal.userChanged
    )
  }

  public struct Destination: Reducer {
    @CasePathable
    @ObservableState
    @dynamicMemberLookup
    public enum State: Equatable {
      case onboarding(OnboardingViewReducer.State)
      case launchImage
      case connectWallet(ConnectWalletReducer.State)
      case rootView(RootViewReducer.State)
    }

    @CasePathable
    public enum Action {
      case onboarding(OnboardingViewReducer.Action)
      case connectWallet(ConnectWalletReducer.Action)
      case rootView(RootViewReducer.Action)
    }

    public var body: some ReducerOf<Self> {

      Scope(state: \.onboarding, action: \.onboarding) {
        OnboardingViewReducer()
      }

      Scope(state: \.connectWallet, action: \.connectWallet) {
        ConnectWalletReducer()
      }

      Scope(state: \.rootView, action: \.rootView) {
        RootViewReducer()
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
          NavigationStack {
            RootView(store: rootViewStore)
          }
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
