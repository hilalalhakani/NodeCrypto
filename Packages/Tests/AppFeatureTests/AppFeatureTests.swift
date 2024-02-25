import AppFeature
import ComposableArchitecture
import Foundation
import NodeCryptoCore
import XCTest

@MainActor
final class AppFeatureTests: XCTestCase {

  func test_rootView_userDoesntExistSetsOnboardingAsRoot() async {
      let store = TestStore(initialState: AppViewReducer.State()) {
      AppViewReducer()
    } withDependencies: {
      $0.keychainManager.get = { @Sendable _ in throw NSError(domain: "", code: 0) }
    }

      await store.send(.view(.onAppear)).cancel()

      await store.receive(\.internal.onKeychainUser.failure) {
          $0.destination = .onboarding(.init())
      }

      await store.receive(\.internal.userChanged, nil)
  }

    func test_rootView_userExistsSetsHomeAsRoot() async {

        let store = TestStore(initialState: AppViewReducer.State()) {
            AppViewReducer()
        } withDependencies: {
            $0.keychainManager.get = { @Sendable _ in try! JSONEncoder().encode(User.mock1) }
            $0.decode = .liveValue
        }

        await store.send(.view(.onAppear)).cancel()

        await store.receive(\.internal.onKeychainUser.success){
            $0.destination = .rootView(.init())
        }

        await store.receive(\.internal.userChanged, User.mock1)
    }
}
