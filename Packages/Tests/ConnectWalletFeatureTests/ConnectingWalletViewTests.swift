import ComposableArchitecture
import ConnectWalletFeature
import Foundation
import SharedModels
import Testing
import XCTest

@MainActor
struct ConnectWalletViewTests {

    @Test
    func test_walletFound() async {
        @Shared(.user) var user
            let store = TestStore(
                initialState: ConnectingWalletViewReducer.State(wallet: .coinbase)
            ) {
                ConnectingWalletViewReducer()
            } withDependencies: {
                $0.keychainManager.set = { @Sendable _, _ in }
                $0.keychainManager.get = { @Sendable _ in Data() }

                #if os(iOS)
                $0.device = .current
                #endif
                $0.apiClient.connectWallet.connectWallet = {  @Sendable _, _ in .mock1 }
                $0.authenticationClient.signIn = { @Sendable _, _ in .mock1 }
                $0.analyticsClient.sendAnalytics = { _ in }
            }

            await store.send(\.view.onAppear)
            await store.receive(\.internal.onConnectWallet.success, .mock1)
            await store.receive(\.internal.onAuthResult.success)
    }

    @Test
    func test_walletNotFound() async {
        let store = TestStore(initialState: ConnectingWalletViewReducer.State(wallet: .coinbase)) {
            ConnectingWalletViewReducer()
        } withDependencies: {
            $0.keychainManager.set = { @Sendable _, _ in }
            $0.encode = .liveValue
            $0.analyticsClient.sendAnalytics = { _ in }
            $0.keychainManager.get = { @Sendable _ in Data() }
            #if os(iOS)
                $0.device = .current
            #endif
            $0.apiClient.connectWallet.connectWallet = { _, _ in throw NSError(domain: "", code: 0)
            }
        }

        await store.send(\.view.onAppear)

        await store.receive(\.internal.onConnectWallet.failure) {
            $0.alert = .noAccountFound
        }
    }
}
