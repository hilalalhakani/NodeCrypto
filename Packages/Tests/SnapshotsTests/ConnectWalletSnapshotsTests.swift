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
          reducer: {
            ConnectWalletReducer()
          },
          withDependencies: {
            $0.analyticsClient = .consoleLogger
            $0.device = .current
            $0.encode = .liveValue
            $0.apiClient.connectWallet.connectWallet = { _, _ in .mock1 }
          }
        )
      )
      .environment(\.colorScheme, .light)

      assertSnapshot(
        of: connectWalletView,
        as: .image(perceptualPrecision: 0.98, layout: .device(config: .iPhoneSe)))
    }

    func test_connectWallet_dark() async {
      let connectWalletView = ConnectWalletView(
        store: .init(
          initialState: .init(),
          reducer: {
            ConnectWalletReducer()
          },
          withDependencies: {
            $0.analyticsClient = .consoleLogger
            $0.device = .current
            $0.encode = .liveValue
            $0.apiClient.connectWallet.connectWallet = { _, _ in .mock1 }
          }
        )
      )
      .environment(\.colorScheme, .dark)

      assertSnapshot(
        of: connectWalletView,
        as: .image(perceptualPrecision: 0.98, layout: .device(config: .iPhoneSe)))
    }

    func test_connectWallet_alert_light() async {
      let store = Store(
        initialState: ConnectWalletReducer.State(),
        reducer: {
          ConnectWalletReducer()
        },
        withDependencies: {
          $0.analyticsClient = .consoleLogger
          $0.device = .current
          $0.encode = .liveValue
          $0.apiClient.connectWallet.connectWallet = { _, _ in .mock1 }
        }
      )

      let connectWalletView = ConnectWalletView(store: store)
        .environment(\.colorScheme, .light)

      store.send(.view(.onButtonSelect(.coinbase)))

      assertSnapshot(
        of: connectWalletView,
        as: .image(perceptualPrecision: 0.98, layout: .device(config: .iPhoneSe))
      )
    }

    func test_connectWallet_alert_dark() async {
      let store = Store(
        initialState: ConnectWalletReducer.State(),
        reducer: {
          ConnectWalletReducer()
        },
        withDependencies: {
          $0.analyticsClient = .consoleLogger
          $0.device = .current
          $0.encode = .liveValue
          $0.apiClient.connectWallet.connectWallet = { _, _ in .mock1 }
        }
      )

      let connectWalletView = ConnectWalletView(store: store)
        .environment(\.colorScheme, .dark)

      store.send(.view(.onButtonSelect(.coinbase)))

      assertSnapshot(
        of: connectWalletView,
        as: .image(perceptualPrecision: 0.98, layout: .device(config: .iPhoneSe)))
    }

    func test_connectingWallet_light() async {

      let connectWalletView = ConnectWalletView(
        store: .init(
          initialState: .init(),
          reducer: {
            ConnectWalletReducer()
          },
          withDependencies: {
            $0.analyticsClient = .consoleLogger
            $0.device = .current
            $0.encode = .liveValue
            $0.apiClient.connectWallet.connectWallet = { _, _ in .mock1 }
          }
        )
      )
      .environment(\.colorScheme, .light)

      assertSnapshot(
        of: connectWalletView,
        as: .image(perceptualPrecision: 0.98, layout: .device(config: .iPhoneSe)))
    }

    func test_connectingWallet_dark() async {

      let connectWalletView = ConnectWalletView(
        store: .init(
          initialState: .init(),
          reducer: {
            ConnectWalletReducer()
          },
          withDependencies: {
            $0.analyticsClient = .consoleLogger
            $0.device = .current
            $0.encode = .liveValue
            $0.apiClient.connectWallet.connectWallet = { _, _ in .mock1 }
          }
        )
      )
      .environment(\.colorScheme, .dark)

      assertSnapshot(
        of: connectWalletView,
        as: .image(perceptualPrecision: 0.98, layout: .device(config: .iPhoneSe)))
    }
  }
#endif
