import AppFeature
import ComposableArchitecture
import Foundation
import NodeCryptoCore
import XCTest

final class AppFeatureTests: XCTestCase {

    @MainActor
    func test_rootView_userDoesntExistSetsOnboardingAsRoot() async {
        let store = TestStore(initialState: AppViewReducer.State()) {
            AppViewReducer()
        } withDependencies: {
            $0.keychainManager.get = { @Sendable _ in throw NSError(domain: "", code: 0) }
        }

        await store.send(.view(.onAppear)) {
            $0.destination = .onboarding(.init())
        }
        .cancel()

    }

    @MainActor
    func test_rootView_userExistsSetsHomeAsRoot() async {

        await withDependencies {
            $0.keychainManager.set = { @Sendable _, _ in  }
            $0.keychainManager.get = { @Sendable _ in Data() }
            $0.decode = .liveValue
        } operation: {

            let store = TestStore(initialState: AppViewReducer.State()) {
                AppViewReducer()
            } withDependencies: {
                $0.userManager.user = .mock1
            }

            await store.send(.view(.onAppear)) {
                $0.destination = .rootView(.init(user: User.mock1))
            }
            .cancel()
        }

    }

    @MainActor
    func test_getStartButtonPressed_navigatesToHome() async {

        let store = TestStore(initialState: AppViewReducer.State()) {
            AppViewReducer()
        } withDependencies: {
            $0.keychainManager.get = { @Sendable _ in throw NSError(domain: "", code: 0) }
        }

        await store.send(.view(.onAppear)) {
            $0.destination = .onboarding(.init())
        }
        .cancel()

        await store.send(\.internal.destination.onboarding.delegate.onGetStartedButtonPressed) {
            $0.$destination = .init(wrappedValue: .connectWallet(.init()))
        }

    }
}
