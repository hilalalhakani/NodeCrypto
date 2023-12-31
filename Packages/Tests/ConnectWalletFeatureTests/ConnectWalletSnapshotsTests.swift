import ComposableArchitecture
import ConnectWalletFeature
import Foundation
import SnapshotTesting
import XCTest

@MainActor
final class ConnectWalletSnapshotsTests: XCTestCase {
  func test_connectWallet_light() async {
    let connectWalletView = ConnectWalletView(
      store: .init(
        initialState: .init(),
        reducer: { ConnectWalletReducer().dependency(\.analyticsClient, .consoleLogger) })
    )
    .environment(\.colorScheme, .light)
    .environment(\.locale, .init(identifier: "en"))

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
    .environment(\.locale, .init(identifier: "fr"))

    assertSnapshot(
      of: connectWalletView,
      as: .image(perceptualPrecision: 0.98, layout: .device(config: .iPhoneSe)))
  }

  func test_connectWallet_alert_light() async {
    let store = StoreOf<ConnectWalletReducer>(
      initialState: ConnectWalletReducer.State(), reducer: { ConnectWalletReducer() })
    let connectWalletView = ConnectWalletView(store: store)
      .environment(\.colorScheme, .light)
      .environment(\.locale, .init(identifier: "en"))

    store.send(.onButtonSelect(.coinbase))

    assertSnapshot(
      of: connectWalletView,
      as: .image(perceptualPrecision: 0.98, layout: .device(config: .iPhoneSe)))
  }

  func test_connectWallet_alert_dark() async {
    let store = StoreOf<ConnectWalletReducer>(
      initialState: ConnectWalletReducer.State(), reducer: { ConnectWalletReducer() })
    let connectWalletView = ConnectWalletView(store: store)
      .environment(\.colorScheme, .dark)
      .environment(\.locale, .init(identifier: "fr"))

    store.send(.onButtonSelect(.coinbase))

    assertSnapshot(
      of: connectWalletView,
      as: .image(perceptualPrecision: 0.98, layout: .device(config: .iPhoneSe)))
  }

  func test_connectingWallet_light() async {
    let connectWalletView = ConnectingWalletView(selectedWallet: .metamask, cancelPressed: {})
      .environment(\.colorScheme, .light)
      .environment(\.locale, .init(identifier: "en"))

    assertSnapshot(
      of: connectWalletView,
      as: .image(perceptualPrecision: 0.98, layout: .device(config: .iPhoneSe)))
  }

  func test_connectingWallet_dark() async {
    let connectWalletView = ConnectingWalletView(selectedWallet: .metamask, cancelPressed: {})
      .environment(\.colorScheme, .dark)
      .environment(\.locale, .init(identifier: "fr"))

    assertSnapshot(
      of: connectWalletView,
      as: .image(perceptualPrecision: 0.98, layout: .device(config: .iPhoneSe)))
  }

}
