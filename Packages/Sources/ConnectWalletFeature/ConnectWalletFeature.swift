import Foundation
import NodeCryptoCore
import SwiftUI

@Reducer
public struct ConnectWalletReducer {
  public init() {}

  public struct State: Equatable {
    public var showPopup = false
    public var selectedWallet: WalletType? = .none
    @BindingState public var navigateToConnectingWallet = false
    public init() {}
  }

  @CasePathable
  public enum Action: TCAFeatureAction {
    case view(ViewAction)
    case `internal`(InternalAction)
    case delegate(DelegateAction)

    init(action: ConnectWalletView.ViewAction) {
      switch action {
      case .binding(let action):
        self = .internal(.binding(action))
      }
    }
  }

  @CasePathable
  public enum InternalAction: BindableAction {
    case binding(BindingAction<State>)
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

    BindingReducer(action: \.internal)

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

extension BindingViewStore<ConnectWalletReducer.State> {
  var view: ConnectWalletView.ViewState {
    ConnectWalletView.ViewState(
      navigateToConnectingWallet: self.$navigateToConnectingWallet,
      showPopup: self.showPopup,
      selectedWallet: self.selectedWallet
    )
  }
}

public struct ConnectWalletView: View {
  var store: StoreOf<ConnectWalletReducer>

  public init(store: StoreOf<ConnectWalletReducer>) {
    self.store = store
  }

  struct ViewState: Equatable {
    @BindingViewState var navigateToConnectingWallet: Bool
    var showPopup: Bool
    var selectedWallet: WalletType?
  }

  enum ViewAction: Equatable, BindableAction {
    case binding(BindingAction<ConnectWalletReducer.State>)
  }

  public var body: some View {

    WithViewStore(store, observe: \.view, send: ConnectWalletReducer.Action.init) { viewStore in

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
        isPresented: viewStore.showPopup,
        confirmAction: {
          store.send(.view(.openButtonPressed), animation: .easeIn)
        },
        cancelAction: {
          store.send(.view(.cancelButtonPressed), animation: .easeIn)
        }
      )
      .navigationDestination(isPresented: viewStore.$navigateToConnectingWallet) {
        if let wallet = viewStore.selectedWallet {
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

extension View {
  func popup(
    isPresented: Bool,
    confirmAction: @escaping () -> Void,
    cancelAction: @escaping () -> Void
  ) -> some View {
    self.modifier(
      PopUpModifier(
        isPresented: isPresented,
        confirmAction: confirmAction,
        cancelAction: cancelAction
      )
    )
  }
}

struct PopUpModifier: ViewModifier {
  let isPresented: Bool
  let confirmAction: () -> Void
  let cancelAction: () -> Void
  @Environment(\.colorScheme) var colorScheme

  func body(content: Content) -> some View {
    ZStack {
      content
        .zIndex(0)

      if isPresented {
          Color.neutral1
              .opacity(colorScheme == .dark ? 0.75 : 0.5)
          .ignoresSafeArea()
          .transition(.opacity.animation(.easeInOut))
          .zIndex(1)

        VStack {
          Text("This page will open another application.", bundle: .module)
            .multilineTextAlignment(.center)
            .foregroundStyle(Color.neutral2)
            .font(Font(FontName.poppinsRegular, size: 12))
            .padding(.bottom, 20)

          Button(
            action: confirmAction,
            label: {
              Text("Open")
                .font(Font(FontName.dmSansBold, size: 14))
                .frame(maxWidth: .infinity)
            }
          )
          .clipShape(Capsule())
          .buttonStyle(.borderedProminent)
          .foregroundStyle(.white)
          .tint(Color.primary1)
          .frame(minHeight: 40)

          Button(
            action: cancelAction,
            label: {
              Text("Cancel")
                .font(Font(FontName.dmSansBold, size: 14))
                .frame(maxWidth: .infinity)
            }
          )
          .clipShape(Capsule())
          .buttonStyle(.borderedProminent)
          .foregroundStyle(Color.neutral2)
          .tint(Color.neutral8)
          .overlay(
            RoundedRectangle(cornerRadius: 90)
              .inset(by: 1)
              .stroke(Color.neutral6)
          )
          .frame(minHeight: 40)
        }
        .padding(20)
        .frame(width: 270)
        .background(
          Color.neutral8
            .clipShape(RoundedRectangle(cornerRadius: 32))
        )
        .animation(.easeInOut, value: self.isPresented)
        .zIndex(2)
      }
    }
  }
}
