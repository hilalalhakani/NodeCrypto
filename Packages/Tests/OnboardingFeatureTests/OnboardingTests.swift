//
//  OnboardingTests.swift
//
//
//  Created by HH on 26/11/2023.
//

import ComposableArchitecture
import OnboardingFeature
import Testing

@MainActor
struct OnboardingTests {

    @Test func testForwardButtonAdvancesStep() async {
        @Shared(.currentStep) var currentStep

        let store = TestStore(
            initialState: OnboardingStepperReducer.State()
        ) {
            OnboardingStepperReducer()
        }

        #expect(currentStep == .step1)

        #expect(store.state.backwardButtonDisabled == true)
        #expect(store.state.forwardButtonDisabled == false)

        await store.send(.view(.onForwardButtonPress)) {
            $0.backwardButtonDisabled = false
        }

        #expect(currentStep == .step2)
    }

    @Test func testNavigationForwardThenBackwardUpdatesSteps() async {
        @Shared(.currentStep) var currentStep
        let store = TestStore(
            initialState: OnboardingStepperReducer.State()
        ) {
            OnboardingStepperReducer()
        }

        await store.send(.view(.onForwardButtonPress)) {
            $0.backwardButtonDisabled = false
        }

        #expect(currentStep == .step2)

        await store.send(.view(.onBackwardButtonPress)) {
            $0.backwardButtonDisabled = true
        }

        #expect(currentStep == .step1)
    }

    @Test func testForwardButtonReachesLastStepAndDisables() async {
        @Shared(.currentStep) var currentStep
        let store = TestStore(
            initialState: OnboardingStepperReducer.State()
        ) {
            OnboardingStepperReducer()
        }

        await store.send(.view(.onForwardButtonPress)) {
            $0.backwardButtonDisabled = false
        }

        #expect(currentStep == .step2)

        await store.send(.view(.onForwardButtonPress))

        #expect(currentStep == .step3)

        await store.send(.view(.onForwardButtonPress)) {
            $0.forwardButtonDisabled = true
        }

        #expect(currentStep == .step4)
    }

    @Test func testSkipButtonPressed() async {
        @Shared(.currentStep) var currentStep
        let store = TestStore(initialState: OnboardingViewReducer.State()) {
            OnboardingViewReducer()
        }

        store.dependencies.analyticsClient.expect(
            .event(name: "onSkipButtonPressed", properties: [:])
        )

        await store.send(\.view.onSkipButtonPressed) {
            $0.isGetStartedButtonHidden = false
            $0.onboardingStepper.forwardButtonDisabled = true
        }
        #expect(currentStep == .step4)
    }

    @Test func testonGetStartedButtonPressed() async {
        let store = TestStore(initialState: OnboardingViewReducer.State()) {
            OnboardingViewReducer()
        }

        store.dependencies.analyticsClient.expect(
            .event(name: "onGetStartedButtonPressed", properties: [:])
        )

        await store.send(\.view.onGetStartedButtonPressed)
        await store.receive(\.delegate.onGetStartedButtonPressed)
    }

    @Test func test_onboardingStepperChanged() async {
        let store = TestStore(initialState: OnboardingViewReducer.State()) {
            OnboardingViewReducer()
        }

        await store.send(\.view.onboardingStepper.view.onForwardButtonPress) {
            $0.onboardingStepper.forwardButtonDisabled = false
            $0.onboardingStepper.backwardButtonDisabled = false
        }
    }
}
