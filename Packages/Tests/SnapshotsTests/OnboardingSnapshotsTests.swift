//
//  OnboardingSnapshotsTests.swift
//
//
//  Created by Hilal Hakkani on 10/06/2024.
//

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
    func testStep1_welcome() throws {
        @Shared(.currentStep) var currentStep = .step1
        let store: StoreOf<OnboardingFeature> = .init(initialState: .init()) {
            OnboardingFeature()
        }

        try assert(OnboardingView(store: store))
    }

    @Test
    func testStep2_discover() throws {
        @Shared(.currentStep) var currentStep = .step2
        let store: StoreOf<OnboardingFeature> = .init(initialState: .init()) {
            OnboardingFeature()
        }

        try assert(OnboardingView(store: store))
    }

    @Test
    func testStep3_create() throws {
        @Shared(.currentStep) var currentStep = .step3
        let store: StoreOf<OnboardingFeature> = .init(initialState: .init()) {
            OnboardingFeature()
        }

        try assert(OnboardingView(store: store))
    }

    @Test
    func testStep4_complete() throws {
        @Shared(.currentStep) var currentStep = .step4
        let store: StoreOf<OnboardingFeature> = .init(initialState: .init()) {
            OnboardingFeature()
        }

        try assert(OnboardingView(store: store))
    }
}
