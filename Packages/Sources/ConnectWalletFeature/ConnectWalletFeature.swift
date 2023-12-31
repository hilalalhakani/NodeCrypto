import Foundation
import NodeCryptoCore
import SwiftUI

@Reducer
public struct ConnectWalletReducer {
  public init() {}

  @ObservableState
  public struct State: Equatable {
    public var showPopup = false
    public var navigateToConnectingWallet = false
    public var selectedWallet: WalletType? = .none
    public init() {

    }
  }

  @CasePathable
  public enum Action {
    case onButtonSelect(WalletType)
    case popUpModifier(Bool)
    case cancelButtonPressed
    case openButtonPressed
    case popConnectingWalletView
    case navigation(Bool)
  }

  public var body: some ReducerOf<Self> {

    AnalyticsReducer { _, action in
      switch action {
      case .onButtonSelect(let wallet):
        return .event(name: "walletSelected", properties: ["wallet": wallet.rawValue])
      default:
        return .none
      }
    }

    Reduce { state, action in
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
      default:
        return .none
      }
    }

  }
}

public struct ConnectWalletView: View {
  @Bindable var store: StoreOf<ConnectWalletReducer>

  @Environment(\.colorScheme) var colorScheme

  public init(store: StoreOf<ConnectWalletReducer>) {
    self.store = store
  }

  public var body: some View {
    ZStack {

      BackgroundLinearGradient()

      VStack(alignment: .center) {

        Image(.background)
          .resizable()
          .scaledToFit()

        Text("Connect Wallet", bundle: .module)
          .multilineTextAlignment(.center)
          .font(Font(FontName.poppinsBold, size: 24))
          .foregroundStyle(colorScheme == .light ? Color.neutral2 : Color.neutral8)

        Spacer()

        ListView(didSelectButton: { store.send(.onButtonSelect($0), animation: .easeIn) })
          .frame(height: 350)
          .padding(.horizontal, 20)

      }
      .frame(maxWidth: .infinity, alignment: .center)
      .padding(.vertical)
    }
    .popup(
      isPresented: store.showPopup,
      confirmAction: {
        store.send(.openButtonPressed, animation: .easeIn)
      },
      cancelAction: {
        store.send(.cancelButtonPressed, animation: .easeIn)
      }
    )
    .navigationDestination(isPresented: $store.navigateToConnectingWallet.sending(\.navigation)) {
      if let wallet = store.selectedWallet {
        ConnectingWalletView(selectedWallet: wallet) {
          store.send(.popConnectingWalletView)
        }
        .navigationBarBackButtonHidden(true)
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
        Color.neutral1.opacity(0.7)
          .ignoresSafeArea()
          .transition(.opacity.animation(.easeInOut))
          .zIndex(1)

        VStack {
          Text("This page will open another application.", bundle: .module)
            .multilineTextAlignment(.center)
            .foregroundStyle(colorScheme == .light ? Color.neutral2 : Color.neutral8)
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
          .foregroundStyle(Color.neutral8)
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
          (colorScheme == .light ? Color.neutral8 : Color.neutral2)
            .clipShape(RoundedRectangle(cornerRadius: 32))
        )
        .animation(.easeInOut, value: self.isPresented)
        .zIndex(2)
      }
    }
  }
}
