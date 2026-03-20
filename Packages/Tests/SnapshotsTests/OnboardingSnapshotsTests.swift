import ComposableArchitecture
import DependenciesTestSupport
import Foundation
import OnboardingFeature
import SnapshotTesting
import Testing

@Suite(.dependencies {
    $0.defaultInMemoryStorage = .init()
})
@MainActor
struct OnboardingSnapshotsTests {
    @Test
    func testpage1() throws {
        @Shared(.currentStep) var currentStep = .step1
        let store: StoreOf<OnboardingFeature> = .init(initialState: OnboardingFeature.State.init()) {
            OnboardingFeature()
        }

        let onboardingView = OnboardingView(store: store)

        try assert(onboardingView)
    }

    @Test
    func testpage2() throws {
        @Shared(.currentStep) var currentStep = .step2
        let store: StoreOf<OnboardingFeature> = .init(initialState: OnboardingFeature.State.init()) {
            OnboardingFeature()
        }

        let onboardingView = OnboardingView(store: store)

        try assert(onboardingView)
    }

    @Test
    func testpage3() throws {
        @Shared(.currentStep) var currentStep = .step3
        let store: StoreOf<OnboardingFeature> = .init(initialState: OnboardingFeature.State.init()) {
            OnboardingFeature()
        }

        let onboardingView = OnboardingView(store: store)

        try assert(onboardingView)

    }

    @Test
    func testpage4() throws {
        @Shared(.currentStep) var currentStep = .step4
        let store: StoreOf<OnboardingFeature> = .init(initialState: OnboardingFeature.State.init()) {
            OnboardingFeature()
        }

        let onboardingView = OnboardingView(store: store)

        try assert(onboardingView)

    }
}
