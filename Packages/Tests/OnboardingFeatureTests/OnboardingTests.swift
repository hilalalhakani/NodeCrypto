//
//  OnboardingTests.swift
//
//
//  Created by HH on 26/11/2023.
//

import ComposableArchitecture
import OnboardingFeature
import XCTest

final class OnboardingTests: XCTestCase {

    @MainActor func testForwardButtonAdvancesStep() async {
        let store = TestStore(
            initialState: OnboardingStepperReducer.State(currentStep: Shared(.step1))
        ) {
            OnboardingStepperReducer(totalSteps: 3)
        }

        await store.send(.view(.onForwardButtonPress)) {
            $0.currentStep = .step2
            $0.backwardButtonDisabled = false
        }

    }

    @MainActor
    func testNavigationForwardThenBackwardUpdatesSteps() async {
        let store = TestStore(
            initialState: OnboardingStepperReducer.State(currentStep: Shared(.step1))
        ) {
            OnboardingStepperReducer(totalSteps: 3)
        }

        await store.send(.view(.onForwardButtonPress)) {
            $0.currentStep = .step2
            $0.backwardButtonDisabled = false
        }

        await store.send(.view(.onBackwardButtonPress)) {
            $0.currentStep = .step1
            $0.backwardButtonDisabled = true
        }

    }

    @MainActor
    func testForwardButtonReachesLastStepAndDisables() async {
        let store = TestStore(
            initialState: OnboardingStepperReducer.State(currentStep: Shared(.step1))
        ) {
            OnboardingStepperReducer(totalSteps: 3)
        }

        await store.send(.view(.onForwardButtonPress)) {
            $0.currentStep = .step2
            $0.backwardButtonDisabled = false
        }

        await store.send(.view(.onForwardButtonPress)) {
            $0.currentStep = .step3
            $0.backwardButtonDisabled = false
            $0.forwardButtonDisabled = true
        }

    }

    @MainActor
    func testSkipButtonPressed() async {
        let store = TestStore(initialState: OnboardingViewReducer.State()) {
            OnboardingViewReducer()
        }

        store.dependencies.analyticsClient.expect(
            .event(name: "onSkipButtonPressed", properties: [:])
        )

        await store.send(\.view.onSkipButtonPressed) {
            let lastStep = OnboardingStep.allCases.last!
            $0.currentStep = lastStep
            $0.isGetStartedButtonHidden = false
            $0.onboardingStepper.currentStep = lastStep
            $0.onboardingStepper.forwardButtonDisabled = true
        }

    }

    @MainActor
    func testonGetStartedButtonPressed() async {
        let store = TestStore(initialState: OnboardingViewReducer.State()) {
            OnboardingViewReducer()
        }

        store.dependencies.analyticsClient.expect(
            .event(name: "onGetStartedButtonPressed", properties: [:])
        )

        await store.send(\.view.onGetStartedButtonPressed)
        await store.receive(\.delegate.onGetStartedButtonPressed)
    }

    @MainActor
    func test_onboardingStepperChanged() async {
        let store = TestStore(initialState: OnboardingViewReducer.State()) {
            OnboardingViewReducer()
        }

        await store.send(\.view.onboardingStepper.view.onForwardButtonPress) {
            $0.onboardingStepper.currentStep = .step2
            $0.onboardingStepper.forwardButtonDisabled = false
            $0.onboardingStepper.backwardButtonDisabled = false
            $0.currentStep = .step2
        }
    }
}
