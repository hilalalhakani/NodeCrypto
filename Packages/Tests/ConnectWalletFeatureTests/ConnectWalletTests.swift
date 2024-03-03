import ComposableArchitecture
import ConnectWalletFeature
import Foundation
import SharedModels
import XCTest

@MainActor
final class ConnectWalletTests: XCTestCase {

    func testOnButtonSelect() async {
        let store = TestStore(
            initialState: ConnectWalletReducer.State(),
            reducer: { ConnectWalletReducer().dependency(\.analyticsClient, .consoleLogger) }
        )

        await store.send(\.view.onButtonSelect.coinbase) {
            $0.selectedWallet = .coinbase
            $0.showPopup = true
        }
    }

    func testCancelButtonPressed() async {
        let store = TestStore(
            initialState: ConnectWalletReducer.State(),
            reducer: { ConnectWalletReducer().dependency(\.analyticsClient, .consoleLogger) }
        )

        await store.send(\.view.onButtonSelect.coinbase) {
            $0.selectedWallet = .coinbase
            $0.showPopup = true
        }

        await store.send(\.view.cancelButtonPressed) {
            $0.showPopup = false
        }
    }

    func testOpenButtonPressed() async {
        let store = TestStore(
            initialState: ConnectWalletReducer.State(),
            reducer: { ConnectWalletReducer().dependency(\.analyticsClient, .consoleLogger) }
        )

        await store.send(\.view.onButtonSelect.metamask) {
            $0.showPopup = true
            $0.selectedWallet = .metamask
        }

        await store.send(\.view.openButtonPressed) {
            $0.showPopup = false
            $0.connectWallet = .init(wallet: .metamask)
        }
    }

    func testNavigation() async {
        let store = TestStore(
            initialState: ConnectWalletReducer.State(),
            reducer: {
                ConnectWalletReducer()
                    .dependency(\.analyticsClient, .consoleLogger)
            }
        )

        await store.send(\.view.onButtonSelect.metamask) {
            $0.showPopup = true
            $0.selectedWallet = .metamask
        }

        await store.send(\.view.openButtonPressed) {
            $0.showPopup = false
            $0.connectWallet = .init(wallet: .metamask)
        }

        await store.send(\.view.popConnectingWalletView) {
            $0.connectWallet = nil
        }
    }

}
