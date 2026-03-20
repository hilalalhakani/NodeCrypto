//
//  OnboardingTests.swift
//
//
//  Created by HH on 26/11/2023.
//

import ComposableArchitecture
import CustomDump
import DependenciesTestSupport
import OnboardingFeature
import Testing

@Suite(.dependencies {
    $0.defaultInMemoryStorage = .init()
})
@MainActor
struct OnboardingTests {

    @Test func testForwardButtonAdvancesStep() async {
        @Shared(.currentStep) var currentStep

        let store = TestStore(
            initialState: OnboardingStepperFeature.State()
        ) {
            OnboardingStepperFeature()
        }

        expectNoDifference(currentStep, .step1)

        expectNoDifference(store.state.backwardButtonDisabled, true)
        expectNoDifference(store.state.forwardButtonDisabled, false)

        await store.send(.view(.onForwardButtonPress)) {
            $0.backwardButtonDisabled = false
        }

        expectNoDifference(currentStep, .step2)
    }

    @Test func testNavigationForwardThenBackwardUpdatesSteps() async {
        @Shared(.currentStep) var currentStep
        let store = TestStore(
            initialState: OnboardingStepperFeature.State()
        ) {
            OnboardingStepperFeature()
        }

        await store.send(.view(.onForwardButtonPress)) {
            $0.backwardButtonDisabled = false
        }

        expectNoDifference(currentStep, .step2)

        await store.send(.view(.onBackwardButtonPress)) {
            $0.backwardButtonDisabled = true
        }

        expectNoDifference(currentStep, .step1)
    }

    @Test func testForwardButtonReachesLastStepAndDisables() async {
        @Shared(.currentStep) var currentStep
        let store = TestStore(
            initialState: OnboardingStepperFeature.State()
        ) {
            OnboardingStepperFeature()
        }

        await store.send(.view(.onForwardButtonPress)) {
            $0.backwardButtonDisabled = false
        }

        expectNoDifference(currentStep, .step2)

        await store.send(.view(.onForwardButtonPress))

        expectNoDifference(currentStep, .step3)

        await store.send(.view(.onForwardButtonPress)) {
            $0.forwardButtonDisabled = true
        }

        expectNoDifference(currentStep, .step4)
    }

    @Test func testSkipButtonPressed() async {
        @Shared(.currentStep) var currentStep
        let store = TestStore(initialState: OnboardingFeature.State()) {
            OnboardingFeature()
        }

        store.dependencies.analyticsClient.expect(
            .event(name: "onSkipButtonPressed", properties: [:])
        )

        await store.send(\.view.onSkipButtonPressed) {
            $0.isGetStartedButtonHidden = false
            $0.onboardingStepper.forwardButtonDisabled = true
        }
        expectNoDifference(currentStep, .step4)
    }

    @Test func testonGetStartedButtonPressed() async {
        let store = TestStore(initialState: OnboardingFeature.State()) {
            OnboardingFeature()
        }

        store.dependencies.analyticsClient.expect(
            .event(name: "onGetStartedButtonPressed", properties: [:])
        )

        await store.send(\.view.onGetStartedButtonPressed)
        await store.receive(\.delegate.onGetStartedButtonPressed)
    }

    @Test func test_onboardingStepperChanged() async {
        let store = TestStore(initialState: OnboardingFeature.State()) {
            OnboardingFeature()
        }

        await store.send(\.view.onboardingStepper.view.onForwardButtonPress) {
            $0.onboardingStepper.forwardButtonDisabled = false
            $0.onboardingStepper.backwardButtonDisabled = false
        }
    }
}
