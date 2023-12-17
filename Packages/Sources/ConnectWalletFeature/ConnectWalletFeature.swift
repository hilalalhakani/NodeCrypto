import Foundation
import NodeCryptoCore
import SwiftUI

@Reducer
public struct ConnectWalletReducer {
    public init() {}

    enum WalletType {
        case rainbow
        case coinbase
        case metamask
    }
    public struct State: Equatable {
        var showPopup = false
        var selectedWallet: WalletType? = .none
        public init() {

        }
    }

    public enum Action: Equatable {
        case rainbowButtonPressed
        case metamaskButtonPressed
        case coinbaseButtonPressed
    }

    public var body: some ReducerOf<Self> {

        Reduce { _, _ in
            return .none
        }

    }
}

public struct ConnectWalletView: View {
    let store: StoreOf<ConnectWalletReducer>

    public init(store: StoreOf<ConnectWalletReducer>) {
        self.store = store
    }

    public var body: some View {
        VStack {
            Text("Connect Wallet")
                .frame(maxWidth: .infinity, alignment: .leading)

            Image(.background)
                .scaledToFit()
        }
        .background()
        .transition(.opacity.animation(.easeInOut))
        .task {}
    }
}

#Preview {
    ConnectWalletView(store: .init(initialState: .init(), reducer: { ConnectWalletReducer() }))
}
