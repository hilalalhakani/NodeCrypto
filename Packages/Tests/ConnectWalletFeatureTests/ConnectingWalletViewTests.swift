import ComposableArchitecture
import ConnectWalletFeature
import Foundation
import SharedModels
import XCTest

final class ConnectWalletViewTests: XCTestCase {

    @MainActor
    func test_walletFound() async {
        await withDependencies {
            $0.keychainManager.set = { @Sendable _, _ in }
            $0.keychainManager.get = { @Sendable _ in Data() }

            #if os(iOS)
                $0.device = .current
            #endif
            $0.apiClient.connectWallet.connectWallet = { _, _ in .mock1 }

        } operation: {
            let store = TestStore(
                initialState: ConnectingWalletViewReducer.State(wallet: .coinbase)
            ) {
                ConnectingWalletViewReducer()
            } withDependencies: {
                $0.userManager.user = .mock1

            }
            await store.send(\.view.onAppear)
            await store.receive(\.internal.onConnectWallet.success, .mock1)
        }
    }

    @MainActor
    func test_walletNotFound() async {
        let store = TestStore(initialState: ConnectingWalletViewReducer.State(wallet: .coinbase)) {
            ConnectingWalletViewReducer()
        } withDependencies: {
            $0.keychainManager.set = { @Sendable _, _ in }
            $0.encode = .liveValue
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
