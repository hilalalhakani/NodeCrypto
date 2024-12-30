import ComposableArchitecture
import Foundation
import OnboardingFeature
import SnapshotTesting
import Testing

@MainActor
struct OnboardingSnapshotsTests {
    @Test
    func testpage1() throws {
        @Shared(.currentStep) var currentStep = .step1
        let store: StoreOf<OnboardingViewReducer> = .init(initialState: OnboardingViewReducer.State.init()) {
            OnboardingViewReducer()
        }

        let onboardingView = OnboardingView(store: store)

        try assert(onboardingView)
    }

    @Test
    func testpage2() throws {
        @Shared(.currentStep) var currentStep = .step2
        let store: StoreOf<OnboardingViewReducer> = .init(initialState: OnboardingViewReducer.State.init()) {
            OnboardingViewReducer()
        }

        let onboardingView = OnboardingView(store: store)

        try assert(onboardingView)
    }

    @Test
    func testpage3() throws {
        @Shared(.currentStep) var currentStep = .step3
        let store: StoreOf<OnboardingViewReducer> = .init(initialState: OnboardingViewReducer.State.init()) {
            OnboardingViewReducer()
        }

        let onboardingView = OnboardingView(store: store)

        try assert(onboardingView)

    }

    @Test
    func testpage4() throws {
        @Shared(.currentStep) var currentStep = .step4
        let store: StoreOf<OnboardingViewReducer> = .init(initialState: OnboardingViewReducer.State.init()) {
            OnboardingViewReducer()
        }

        let onboardingView = OnboardingView(store: store)

        try assert(onboardingView)

    }
}
