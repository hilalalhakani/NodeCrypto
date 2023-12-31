import ComposableArchitecture
import ConnectWalletFeature
import Foundation
import SnapshotTesting
import XCTest

@MainActor
final class ConnectWalletTests: XCTestCase {

    func testOnButtonSelect() async {
        let store = TestStore(
            initialState: ConnectWalletReducer.State(),
            reducer: { ConnectWalletReducer().dependency(\.analyticsClient, .consoleLogger) }
        )

        let walletType: WalletType = .coinbase
        await store.send(.onButtonSelect(walletType)) {
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
        await store.send(.onButtonSelect(walletType)) {
            $0.selectedWallet = .coinbase
            $0.showPopup = true
        }
        
        await store.send(.cancelButtonPressed) {
            $0.showPopup = false
        }
    }

    func testOpenButtonPressed() async {
        let store = TestStore(
            initialState: ConnectWalletReducer.State(),
            reducer: { ConnectWalletReducer() }
        )

        await store.send(.openButtonPressed) {
            $0.showPopup = false
            $0.navigateToConnectingWallet = true
        }
    }


    func testNavigation() async {
        let store = TestStore(
            initialState: ConnectWalletReducer.State(),
            reducer: { ConnectWalletReducer() }
        )

        await store.send(.openButtonPressed) {
            $0.showPopup = false
            $0.navigateToConnectingWallet = true
        }

        await  store.send(.popConnectingWalletView) {
            $0.navigateToConnectingWallet = false
        }
    }

}
