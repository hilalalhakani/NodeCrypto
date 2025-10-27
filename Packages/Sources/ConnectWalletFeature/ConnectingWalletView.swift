//
//  SwiftUIView.swift
//
//
//  Created by HH on 31/12/2023.
//
import APIClient
import ComposableArchitecture
import Dependencies
import SharedModels
import StyleGuide
import SwiftUI
import TCAHelpers
import Keychain
import AuthenticationClient
import DependenciesAdditions

@Reducer
public struct ConnectingWalletViewReducer: Sendable {
    @Dependency(\.apiClient.connectWallet.connectWallet) var connectWallet
    @Dependency(\.dismiss) var dismiss
    @Dependency(\.keychainManager) var keychainManager
    @Dependency(\.logger) var logger
    @Dependency(\.authenticationClient) var authenticationClient
    @Shared(.user) var user

    public init() {}

  @ObservableState
    public struct State: Hashable, Sendable {
    let wallet: WalletType
    @Presents public var alert: AlertState<Action.InternalAction.Alert>?

      public init(wallet: WalletType) {
          self.wallet = wallet
      }
  }
  @CasePathable
    public enum Action: TCAFeatureAction, Sendable {
    case view(ViewAction)
    case `internal`(InternalAction)
    case delegate(DelegateAction)
  }

  @CasePathable
    public enum InternalAction: Sendable {
    case onConnectWallet(Result<User, Error>)
    case onAuthResult(Result<User, Error>)
    case alert(PresentationAction<Alert>)
        public enum Alert: Sendable {
        case dismissAlert
      }
  }

  @CasePathable
    public enum DelegateAction: Sendable {
    case backButtonPressed
    case alertDismissed
  }

  @CasePathable
    public enum ViewAction: Sendable {
    case onAppear
    case backButtonPressed
  }

  public var body: some ReducerOf<Self> {

      CombineReducers {

          NestedAction(\.view) { state, action in
              switch action {
              case .onAppear:
                  return .run { [state] send in
                      let identifier: String
#if os(iOS)
                      @Dependency(\.device) var device
                      guard let identifierForVendor = await device.identifierForVendor?.uuidString else {
                          fatalError()
                      }
                      identifier = identifierForVendor
#else
                      identifier = ""
#endif
                      await send(
                        .internal(
                            .onConnectWallet(
                                Result {
                                    try await connectWallet(
                                        state.wallet, identifier)
                                }
                            )
                        ))
                  }

              case .backButtonPressed:
                  return .send(.delegate(.backButtonPressed))
              }
          }


          NestedAction(\.internal) { state, action in
              switch action {
              case .onConnectWallet(.success(let user)):
                      return .run { send in
                          await send(.internal(.onAuthResult(Result {
                              try await authenticationClient.signIn(user.email, "123456")
                          })))
                      }

              case .onConnectWallet(.failure):
                  state.alert = .noAccountFound
                  return .none

                  case .onAuthResult(.success(let remoteUser)):
                       $user.withLock({ $0 = remoteUser })
                      return .none

                  case .onAuthResult(.failure(_)):
                      state.alert = .noAccountFound
                      return .none

              case .alert(.presented(.dismissAlert)):
                  state.alert = nil 
                  return .send(.delegate(.alertDismissed))

              case .alert:
                  return .none
              }
          }
      }
      .ifLet(\.$alert, action: \.internal.alert)
  }
}

public struct ConnectingWalletView: View {

 @Bindable var store: StoreOf<ConnectingWalletViewReducer>

  public init(store: StoreOf<ConnectingWalletViewReducer>) {
    self.store = store
  }

  public var body: some View {
      ZStack {
        Image(.connectWalletBackground)
          .resizable()
          .scaledToFill()
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .ignoresSafeArea()

        VStack(spacing: 32) {
          Image("\(store.state.wallet.rawValue)", bundle: .module)
            .resizable()
            .frame(width: 80, height: 80)

          HStack(spacing: 8) {
            ProgressView()
              .tint(Color.neutral2)

            Text("Opening \(store.state.wallet.rawValue)")
              .font(Font.init(FontName.poppinsRegular, size: 14))
              .foregroundStyle(Color.neutral2)
          }
        }
      }
      .toolbar {
        #if os(iOS)
          ToolbarItem(placement: .navigationBarLeading) {
            CancelButton(action: {
              store.send(.view(.backButtonPressed))
            })
          }
        #endif
      }
      .alert($store.scope(state: \.alert, action: \.internal.alert))
      .task {
          store.send(.view(.onAppear))
      }
  }
}

struct CancelButton: View {
  let action: () -> Void

  var body: some View {
    Button(action: { action() }) {
      Text("Cancel", bundle: .module)
        .font(.init(.dmSansBold, size: 14))
    }
    .foregroundStyle(Color.neutral2)
    .buttonStyle(.borderedProminent)
    .tint(Color.neutral6)
    .clipShape(Capsule())
  }
}

#Preview {
  ConnectingWalletView(
    store: .init(
      initialState: .init(wallet: .metamask), reducer: { ConnectingWalletViewReducer() })
  )
}

extension AlertState where Action == ConnectingWalletViewReducer.Action.InternalAction.Alert {
    public  static let noAccountFound = Self {
    TextState("No account was found for this wallet")
  } actions: {
      ButtonState(role: .cancel, action: .dismissAlert) {
      TextState("Cancel")
    }
  }
}
