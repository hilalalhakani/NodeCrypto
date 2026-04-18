import Foundation
import StyleGuide
import SwiftUI
import ComposableArchitecture
import TCAHelpers
import SharedModels

@Reducer
public struct ConnectWalletFeature: Sendable {
  // MARK: - Initialization
  public init() {}

  // MARK: - State
  @ObservableState
  public struct State: Equatable, Sendable {
    public var showPopup = false
    public var selectedWallet: WalletType? = .none
    @Presents public var connectWallet: ConnectingWalletViewReducer.State?
    public init() {}
  }

  // MARK: - Action
  @CasePathable
    public enum Action: TCAFeatureAction, Sendable {
    case view(ViewAction)
    case `internal`(InternalAction)
    case delegate(DelegateAction)
  }

  @CasePathable
    public enum InternalAction: Sendable {
    case connectWalletView(PresentationAction<ConnectingWalletViewReducer.Action>)
  }

  @CasePathable
    public enum DelegateAction: Sendable {}

  @CasePathable
    public enum ViewAction: Sendable {
    case onButtonSelect(WalletType)
    case cancelButtonPressed
    case openButtonPressed
    case popConnectingWalletView
  }

  // MARK: - Reducer
  public var body: some ReducerOf<Self> {

    CombineReducers {

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
          if let selectedWallet = state.selectedWallet {
            state.connectWallet = .init(wallet: selectedWallet)
          }
          return .none
        case .popConnectingWalletView:
          state.connectWallet = nil
          return .none
        }
      }

      NestedAction(\.internal) { state, action in

        switch action {

        case .connectWalletView(.presented(.delegate(.backButtonPressed))):
          state.connectWallet = nil
          return .none

        case .connectWalletView(.presented(.delegate(.alertDismissed))):
          state.connectWallet = nil
          return .none

        default:
          return .none
        }

      }
    }
    .ifLet(\.$connectWallet, action: \.internal.connectWalletView) {
      ConnectingWalletViewReducer()
    }
  }
}

// MARK: - ConnectWalletView
public struct ConnectWalletView: View {
  // MARK: - Properties
  @Bindable var store: StoreOf<ConnectWalletFeature>

  // MARK: - Initialization
  public init(store: StoreOf<ConnectWalletFeature>) {
    self.store = store
  }

  // MARK: - Body
  public var body: some View {
    NavigationStack {
      ZStack {

       BackgroundLinearGradient()

        VStack(alignment: .center) {

          Image("Background", bundle: .module)
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
      .navigationDestination(
        item: $store.scope(state: \.connectWallet, action: \.internal.connectWalletView)
      ) { store in
        ConnectingWalletView(store: store)
          .navigationBarBackButtonHidden(true)
      }
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
  }
}

// MARK: - Preview
#Preview {
  ConnectWalletView(
    store: .init(
      initialState: .init(),
      reducer: { ConnectWalletFeature() }
    )
  )
}
