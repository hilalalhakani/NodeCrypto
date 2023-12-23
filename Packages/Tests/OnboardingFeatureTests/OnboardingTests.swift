//
//  OnboardingTests.swift
//
//
//  Created by HH on 26/11/2023.
//

import ComposableArchitecture
import OnboardingFeature
import XCTest

@MainActor
final class OnboardingTests: XCTestCase {
    func testForwardButtonAdvancesStep() async {
        let store = TestStore(initialState: OnboardingStepperReducer.State(currentStep: .step1)) {
            OnboardingStepperReducer(totalSteps: 3)
        }

        await store.send(.view(.onForwardButtonPress)) {
            $0.currentStep = .step2
            $0.backwardButtonDisabled = false
        }

        await store.receive(\.delegate.updatedStep)
    }

    func testNavigationForwardThenBackwardUpdatesSteps() async {
        let store = TestStore(initialState: OnboardingStepperReducer.State(currentStep: .step1)) {
            OnboardingStepperReducer(totalSteps: 3)
        }

        await store.send(.view(.onForwardButtonPress)) {
            $0.currentStep = .step2
            $0.backwardButtonDisabled = false
        }

        await store.receive(\.delegate.updatedStep)

        await store.send(.view(.onBackwardButtonPress)) {
            $0.currentStep = .step1
            $0.backwardButtonDisabled = true
        }

        await store.receive(\.delegate.updatedStep)
    }

    func testForwardButtonReachesLastStepAndDisables() async {
        let store = TestStore(initialState: OnboardingStepperReducer.State(currentStep: .step1)) {
            OnboardingStepperReducer(totalSteps: 3)
        }

        await store.send(.view(.onForwardButtonPress)) {
            $0.currentStep = .step2
            $0.backwardButtonDisabled = false
        }

        await store.receive(\.delegate.updatedStep)

        await store.send(.view(.onForwardButtonPress)) {
            $0.currentStep = .step3
            $0.backwardButtonDisabled = false
            $0.forwardButtonDisabled = true
        }

        await store.receive(\.delegate.updatedStep)
    }

    func testSkipButtonVisibilityOnChangeToStepFour() async {
        let store = TestStore(initialState: OnboardingViewReducer.State()) {
            OnboardingViewReducer()
        }

        await store.send(.view(.onSelectedIndexChange(OnboardingStep.step4))) {
            $0.isGetStartedButtonHidden = false
            $0.currentStep = .step4
            $0.onboardingStepper.forwardButtonDisabled = true
            $0.onboardingStepper.backwardButtonDisabled = false
            $0.onboardingStepper.currentStep = .step4
        }
    }

    func testSkipButtonPressed() async {
        let store = TestStore(initialState: OnboardingViewReducer.State()) {
            OnboardingViewReducer()
        }

        await store.send(.view(.onSkipButtonPressed)) {
            let lastStep = OnboardingStep.allCases.last!
            $0.currentStep = lastStep
            $0.isGetStartedButtonHidden = false
            $0.onboardingStepper.currentStep = lastStep
            $0.onboardingStepper.backwardButtonDisabled = false
            $0.onboardingStepper.forwardButtonDisabled = true
        }
    }

    func testonGetStartedButtonPressed() async {
        let store = TestStore(initialState: OnboardingViewReducer.State()) {
            OnboardingViewReducer()
        }

        await store.send(.view(.onGetStartedButtonPressed))
        await store.receive(\.delegate.onGetStartedButtonPressed)
    }

    func test_onboardingStepperChanged() async {
        let store = TestStore(initialState: OnboardingViewReducer.State()) {
            OnboardingViewReducer()
        }

        await store.send(.view(.onboardingStepper(.view(.onForwardButtonPress)))) {
            $0.onboardingStepper.currentStep = .step2
            $0.onboardingStepper.forwardButtonDisabled = false
            $0.onboardingStepper.backwardButtonDisabled = false
        }

        await store.receive(\.view.onboardingStepper.delegate.updatedStep) {
            $0.currentStep = .step2
        }
    }
}
