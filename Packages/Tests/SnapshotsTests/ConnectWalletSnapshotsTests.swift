import ComposableArchitecture
import ConnectWalletFeature
import Foundation
import SnapshotTesting
import SwiftUI
import Testing

@MainActor
struct ConnectWalletSnapshotsTests {
    @Test
    func test_connectWallet() throws {
        let connectWalletView = ConnectingWalletView(
            store: .init(
                initialState: .init(wallet: .rainbow),
                reducer: {
                    ConnectingWalletViewReducer()
                },
                withDependencies: {
                    $0.keychainManager.get = { @Sendable _ in Data() }
                    $0.device = .current
                    $0.encode = .liveValue
                    $0.apiClient.connectWallet.connectWallet = { _, _ in .mock1 }
                }
            )
        )

        try assert(connectWalletView)
    }

    @Test
    func test_connectWallet_alert() throws {
        let store = Store(
            initialState: ConnectWalletReducer.State(),
            reducer: {
                ConnectWalletReducer()
            },
            withDependencies: {
                $0.device = .current
                $0.encode = .liveValue
                $0.apiClient.connectWallet.connectWallet = { _, _ in .mock1 }
                $0.analyticsClient.sendAnalytics = { _ in }
                $0.keychainManager.get = { @Sendable _ in Data() }
            }
        )

        let connectWalletView = ConnectWalletView(store: store)

        store.send(.view(.onButtonSelect(.coinbase)))

        try assert(connectWalletView)
    }

    @Test
    func test_connectingWallet() throws {

        let connectWalletView = ConnectWalletView(
            store: .init(
                initialState: .init(),
                reducer: {
                    ConnectWalletReducer()
                },
                withDependencies: {
                    $0.device = .current
                    $0.encode = .liveValue
                    $0.apiClient.connectWallet.connectWallet = { _, _ in .mock1 }
                }
            )
        )

        try assert(connectWalletView)
    }
}
