import AppFeature
import ComposableArchitecture
import Foundation
import NodeCryptoCore
import XCTest

@MainActor
final class AppFeatureTests: XCTestCase {

  func test_rootView_userDoesntExistSetsOnboardingAsRoot() async {
    let store = TestStore(initialState: .init()) {
      AppViewReducer()
    } withDependencies: {
      $0.keychainManager.get = { @Sendable _ in throw NSError(domain: "", code: 0) }
    }

    await store.send(.view(.onAppear))

    await store.receive(
      AppViewReducer.Action.internal(.onKeychainUser(.failure(NSError(domain: "", code: 0))))
    ) {
      $0.destination = .onboarding(.init())
    }
  }

  func test_rootView_userExistsSetsHomeAsRoot() async {
    guard let userData = try? JSONEncoder().encode(User.mock1) else {
      fatalError("Unable to encode User.mock1")
    }
//    let store = Test Store(initialState: .init()) {
//      AppViewReducer()
//    } withDependencies: {
//      $0.keychainManager.get = { _ in userData }
//      $0.decode = .liveValue
//    }

//    await store.send(.view(.onAppear))
//
//    await store.receive(AppViewReducer.Action.internal(.onKeychainUser(.success(User.mock1))))
    //            $0.destination = this should be set to homeScreen
  }

}
