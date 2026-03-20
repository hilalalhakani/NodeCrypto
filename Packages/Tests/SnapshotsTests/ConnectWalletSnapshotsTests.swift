import ComposableArchitecture
import ConnectWalletFeature
import DependenciesTestSupport
import Foundation
import SnapshotTesting
import SwiftUI
import Testing

@Suite(.dependencies {
    $0.analyticsClient.sendAnalytics = { _ in }
    $0.apiClient.connectWallet.connectWallet = { _, _ in .mock1 }
    $0.device = .current
    $0.encode = .liveValue
    $0.keychainManager.get = { @Sendable _ in Data() }
})
@MainActor
struct ConnectWalletSnapshotsTests {
    @Test
    func test_connectWallet() throws {
        let connectWalletView = ConnectingWalletView(
            store: .init(
                initialState: .init(wallet: .rainbow),
                reducer: {
                    ConnectingWalletViewReducer()
                }
            )
        )

        try assert(connectWalletView)
    }

    @Test
    func test_connectWallet_alert() throws {
        let store = Store(
            initialState: ConnectWalletFeature.State(),
            reducer: {
                ConnectWalletFeature()
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
                    ConnectWalletFeature()
                }
            )
        )

        try assert(connectWalletView)
    }
}
