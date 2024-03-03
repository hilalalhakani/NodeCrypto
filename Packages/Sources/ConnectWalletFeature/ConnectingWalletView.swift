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

@Reducer
public struct ConnectingWalletViewReducer {
    @Dependency(\.apiClient.connectWallet.connectWallet) var connectWallet
    @Dependency(\.dismiss) var dismiss
    @Dependency(\.encode) var encode
    @Dependency(\.keychainManager) var keychainManager
    @Dependency(\.logger) var logger
    @Dependency(\.user) var currentUser
    @Dependency(\.device) var device

    public init() {}

  @ObservableState
  public struct State: Hashable {
    let wallet: WalletType
     @Presents  public var alert: AlertState<Action.InternalAction.Alert>?

      public init(wallet: WalletType) {
          self.wallet = wallet
      }
  }
  @CasePathable
  public enum Action: TCAFeatureAction {
    case view(ViewAction)
    case `internal`(InternalAction)
    case delegate(DelegateAction)
  }

  @CasePathable
   public enum InternalAction {
    case onConnectWallet(Result<User, Error>)
    case alert(PresentationAction<Alert>)
      public enum Alert {
        case dismissAlert
      }
  }

  @CasePathable
  public enum DelegateAction {
    case backButtonPressed
    case alertDismissed
  }

  @CasePathable
  public enum ViewAction {
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
                  return .run { _ in
                      do {
                          let encodedUser = try encode(user)
                          try await keychainManager.set(encodedUser, .user)
                          currentUser.set(user)
                      } catch {
                          logger.log(level: .error, "\(error.localizedDescription)")
                      }
                  }

              case .onConnectWallet(.failure):
                  state.alert = .noAccountFound
                  return .none

              case .alert(.presented(.dismissAlert)):
                  state.alert = nil 
                  return .run { send in
                      await send(.delegate(.alertDismissed))
                  }

              case .alert:
                  return .none
              }
          }
      }
      .ifLet(\.$alert, action: \.internal.alert)
  }
}

public struct ConnectingWalletView: View {

 @Perception.Bindable var store: StoreOf<ConnectingWalletViewReducer>

  public init(store: StoreOf<ConnectingWalletViewReducer>) {
    self.store = store
  }

  public var body: some View {
    WithPerceptionTracking {
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
