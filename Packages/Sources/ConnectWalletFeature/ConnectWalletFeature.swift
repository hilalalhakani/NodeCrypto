import Foundation
import NodeCryptoCore
import SwiftUI

@Reducer
public struct ConnectWalletReducer {
  public init() {}

 @ObservableState
  public struct State: Equatable {
    public var showPopup = false
    public var selectedWallet: WalletType? = .none
    public var navigateToConnectingWallet = false
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
    case navigateToConnectingWallet(Bool)
  }

  @CasePathable
  public enum DelegateAction {}

  @CasePathable
  public enum ViewAction {
    case onButtonSelect(WalletType)
    case cancelButtonPressed
    case openButtonPressed
    case popConnectingWalletView
  }

  public var body: some ReducerOf<Self> {

    AnalyticsReducer { state, action in

      switch action {

      case .view(let viewAction):
        switch viewAction {

        case .onButtonSelect(let wallet):
          return .event(name: "walletSelected", properties: ["wallet": wallet.rawValue])

        default:
          return .none
        }

      default:
        return .none
      }
    }

    NestedAction(\.view) { state, action in
      switch action {
      case .onButtonSelect(let wallet):
        state.selectedWallet = wallet
        state.showPopup = true
        return .none
      case .cancelButtonPressed:
        state.showPopup = false
        return .none
      case .openButtonPressed:
        state.showPopup = false
        state.navigateToConnectingWallet = true
        return .none
      case .popConnectingWalletView:
        state.navigateToConnectingWallet = false
        return .none
      }
    }
  }
}

public struct ConnectWalletView: View {
 @Perception.Bindable var store: StoreOf<ConnectWalletReducer>

  public init(store: StoreOf<ConnectWalletReducer>) {
    self.store = store
  }

  public var body: some View {

    WithPerceptionTracking {

      ZStack {

        BackgroundLinearGradient()

        VStack(alignment: .center) {

          Image(.background)
            .resizable()
            .scaledToFit()

          Text("Connect Wallet", bundle: .module)
            .multilineTextAlignment(.center)
            .font(Font(FontName.poppinsBold, size: 24))
            .foregroundStyle(Color.neutral2)

          Spacer()

          ListView(didSelectButton: { store.send(.view(.onButtonSelect($0)), animation: .easeIn) })
            .frame(height: 350)
            .padding(.horizontal, 20)

        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.vertical)
      }
      .popup(
        isPresented: store.showPopup,
        confirmAction: {
          store.send(.view(.openButtonPressed), animation: .easeIn)
        },
        cancelAction: {
          store.send(.view(.cancelButtonPressed), animation: .easeIn)
        }
      )
      .navigationDestination(isPresented: $store.navigateToConnectingWallet.sending(\.internal.navigateToConnectingWallet)) {
        if let wallet = store.selectedWallet {
          ConnectingWalletView(selectedWallet: wallet) {
            store.send(.view(.popConnectingWalletView))
          }
          .navigationBarBackButtonHidden(true)
        }
      }
    }
  }
}

#Preview {
  ConnectWalletView(
    store: .init(
      initialState: .init(),
      reducer: { ConnectWalletReducer() }
    )
  )
}

