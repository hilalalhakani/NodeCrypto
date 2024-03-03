import ComposableArchitecture
import ConnectWalletFeature
import Foundation
import SharedModels
import XCTest

@MainActor
final class ConnectWalletViewTests: XCTestCase {

  func test_walletFound() async {
    let store = TestStore(initialState: ConnectingWalletViewReducer.State(wallet: .coinbase)) {
      ConnectingWalletViewReducer()
    } withDependencies: {
      $0.keychainManager.set = { _, _ in }
      $0.encode = .liveValue
      #if os(iOS)
        $0.device = .current
      #endif
      $0.apiClient.connectWallet.connectWallet = { _, _ in .mock1 }
    }

    await store.send(\.view.onAppear)

    await store.receive(\.internal.onConnectWallet.success, .mock1)
  }

  func test_walletNotFound() async {
    let store = TestStore(initialState: ConnectingWalletViewReducer.State(wallet: .coinbase)) {
      ConnectingWalletViewReducer()
    } withDependencies: {
      $0.keychainManager.set = { _, _ in }
      $0.encode = .liveValue
      #if os(iOS)
        $0.device = .current
      #endif
      $0.apiClient.connectWallet.connectWallet = { _, _ in throw NSError(domain: "", code: 0) }
    }

    await store.send(\.view.onAppear)

    await store.receive(\.internal.onConnectWallet.failure) {
      $0.alert = .noAccountFound
    }
  }
}
