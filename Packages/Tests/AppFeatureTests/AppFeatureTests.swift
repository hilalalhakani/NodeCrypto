import AppFeature
import ComposableArchitecture
import Foundation
import Keychain
import NodeCryptoCore
import Testing
import XCTest

@MainActor
struct AppFeatureTests {

    @Test
    func test_rootView_userDoesntExistSetsOnboardingAsRoot() async {
        let store = TestStore(initialState: AppViewReducer.State()) {
            AppViewReducer()
        } withDependencies: {
            $0.keychainManager.get = { @Sendable _ in
                throw KeychainManager.Error.itemNotFound
            }
            $0.mainQueue = .immediate
        }

        #expect(store.state.destination == .launchImage)

        await store.send(.view(.onAppear))
            .cancel()

        await store.receive(\.internal.userChanged) {
            $0.destination = .onboarding(.init())
        }
    }

    @Test
    func test_rootView_userExistsSetsHomeAsRoot() async {

        let store = TestStore(initialState: AppViewReducer.State()) {
            AppViewReducer()
        } withDependencies: {
            $0.keychainManager.get = { @Sendable _ in
                let data = try JSONEncoder().encode(User.mock1)
                return data
            }
            $0.mainQueue = .immediate
        }

        #expect(store.state.destination == .launchImage)

        await store.send(.view(.onAppear)).cancel()

        await store.receive(\.internal.userChanged) {
            $0.destination = .rootView(.init())
        }
    }

    @Test
    func test_getStartButtonPressed_navigatesToHome() async {

        let store = TestStore(initialState: AppViewReducer.State()) {
            AppViewReducer()
        } withDependencies: {
            $0.keychainManager.get = { @Sendable _ in
                throw KeychainManager.Error.itemNotFound
            }
            $0.mainQueue = .immediate
        }

        #expect(store.state.destination == .launchImage)

        await store.send(.view(.onAppear))
            .cancel()

        await store.receive(\.internal.userChanged) {
            $0.destination = .onboarding(.init())
        }

        await store.send(\.internal.destination.onboarding.delegate.onGetStartedButtonPressed) {
            $0.$destination = .init(wrappedValue: .connectWallet(.init()))
        }

    }
}
