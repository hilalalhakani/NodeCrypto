import ComposableArchitecture
import ConnectWalletFeature
import Foundation
import XCTest

@MainActor
final class ConnectWalletTests: XCTestCase {

    func testOnButtonSelect() async {
        let store = TestStore(
            initialState: ConnectWalletReducer.State(),
            reducer: { ConnectWalletReducer().dependency(\.analyticsClient, .consoleLogger) }
        )

        let walletType: WalletType = .coinbase
        await store.send(.view(.onButtonSelect(walletType))) {
            $0.selectedWallet = .coinbase
            $0.showPopup = true
        }
    }

    func testCancelButtonPressed() async {
        let store = TestStore(
            initialState: ConnectWalletReducer.State(),
            reducer: { ConnectWalletReducer().dependency(\.analyticsClient, .consoleLogger) }
        )

        let walletType: WalletType = .coinbase
        await store.send(.view(.onButtonSelect(walletType))) {
            $0.selectedWallet = .coinbase
            $0.showPopup = true
        }
        
        await store.send(.view(.cancelButtonPressed)) {
            $0.showPopup = false
        }
    }

    func testOpenButtonPressed() async {
        let store = TestStore(
            initialState: ConnectWalletReducer.State(),
            reducer: { ConnectWalletReducer() }
        )

        await store.send(.view(.openButtonPressed)) {
            $0.showPopup = false
            $0.navigateToConnectingWallet = true
        }
    }


    func testNavigation() async {
        let store = TestStore(
            initialState: ConnectWalletReducer.State(),
            reducer: { ConnectWalletReducer() }
        )

        await store.send(.view(.openButtonPressed)) {
            $0.showPopup = false
            $0.navigateToConnectingWallet = true
        }

        await  store.send(.view(.popConnectingWalletView)) {
            $0.navigateToConnectingWallet = false
        }
    }

}
