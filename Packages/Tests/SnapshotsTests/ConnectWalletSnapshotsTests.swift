import ComposableArchitecture
import ConnectWalletFeature
import Foundation
import SnapshotTesting
import XCTest

#if os(iOS)
@MainActor
@available(macOS, unavailable)
final class ConnectWalletSnapshotsTests: XCTestCase {
    func test_connectWallet_light() async {
        let connectWalletView = ConnectWalletView(
            store: .init(
                initialState: .init(),
                reducer: { ConnectWalletReducer().dependency(\.analyticsClient, .consoleLogger) })
        )
            .environment(\.colorScheme, .light)
        XCTExpectFailure("Fails in github actions environment. Should pass locally")
        assertSnapshot(
            of: connectWalletView,
            as: .image(perceptualPrecision: 0.98, layout: .device(config: .iPhoneSe)))
    }

    func test_connectWallet_dark() async {
        let connectWalletView = ConnectWalletView(
            store: .init(
                initialState: .init(),
                reducer: { ConnectWalletReducer().dependency(\.analyticsClient, .consoleLogger) })
        )
            .environment(\.colorScheme, .dark)
        XCTExpectFailure("Fails in github actions environment. Should pass locally")
        assertSnapshot(
            of: connectWalletView,
            as: .image(perceptualPrecision: 0.98, layout: .device(config: .iPhoneSe)))
    }

      func test_connectWallet_alert_light() async {
        let store = StoreOf<ConnectWalletReducer>(
          initialState: ConnectWalletReducer.State(),
          reducer: { ConnectWalletReducer().dependency(\.analyticsClient, .consoleLogger) })
    
        let connectWalletView  = ConnectWalletView(store: store)
          .environment(\.colorScheme, .light)

          store.send(.view(.onButtonSelect(.coinbase)))
          XCTExpectFailure("Fails in github actions environment. Should pass locally")
        assertSnapshot(
          of: connectWalletView,
          as: .image(perceptualPrecision: 0.98, layout: .device(config: .iPhoneSe))
        )
      }

      func test_connectWallet_alert_dark() async {
        let store = StoreOf<ConnectWalletReducer>(
          initialState: ConnectWalletReducer.State(),
          reducer: { ConnectWalletReducer().dependency(\.analyticsClient, .consoleLogger) })
    
        let connectWalletView = ConnectWalletView(store: store)
          .environment(\.colorScheme, .dark)

          store.send(.view(.onButtonSelect(.coinbase)))
          XCTExpectFailure("Fails in github actions environment. Should pass locally")
        assertSnapshot(
          of: connectWalletView,
          as: .image(perceptualPrecision: 0.98, layout: .device(config: .iPhoneSe)))
      }

    func test_connectingWallet_light() async {
        let connectWalletView = ConnectingWalletView(selectedWallet: .metamask, cancelPressed: {})
            .environment(\.colorScheme, .light)

        XCTExpectFailure("Fails in github actions environment. Should pass locally")
        assertSnapshot(
            of: connectWalletView,
            as: .image(perceptualPrecision: 0.98, layout: .device(config: .iPhoneSe)))
    }

    func test_connectingWallet_dark() async {
        let connectWalletView = ConnectingWalletView(selectedWallet: .metamask, cancelPressed: {})
            .environment(\.colorScheme, .dark)
        XCTExpectFailure("Fails in github actions environment. Should pass locally")
        assertSnapshot(
            of: connectWalletView,
            as: .image(perceptualPrecision: 0.98, layout: .device(config: .iPhoneSe)))
    }
}
#endif
