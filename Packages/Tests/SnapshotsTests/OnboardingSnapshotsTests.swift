import ComposableArchitecture
import Foundation
import OnboardingFeature
import SnapshotTesting
import XCTest

@MainActor
final class OnboardingSnapshotsTests: XCTestCase {
  func testpage1_light() async {
    let onboardingView = OnboardingView()
      .environment(\.colorScheme, .light)

    assertSnapshot(
      of: onboardingView, as: .image(perceptualPrecision: 0.98, layout: .device(config: .iPhoneSe)))
  }

  func testpage2_light() async {
    let store = StoreOf<OnboardingViewReducer>.init(initialState: .init(currentStep: .step2)) {
      OnboardingViewReducer()
    }
    let onboardingView = OnboardingView(store: store).environment(\.colorScheme, .light)
    assertSnapshot(
      of: onboardingView, as: .image(perceptualPrecision: 0.98, layout: .device(config: .iPhoneSe)))
  }

  func testpage3_light() async {
    let store = StoreOf<OnboardingViewReducer>.init(initialState: .init(currentStep: .step3)) {
      OnboardingViewReducer()
    }
    let onboardingView = OnboardingView(store: store).environment(\.colorScheme, .light)
    assertSnapshot(
      of: onboardingView, as: .image(perceptualPrecision: 0.98, layout: .device(config: .iPhoneSe)))
  }

  func testpage4_light() async {
    let store = StoreOf<OnboardingViewReducer>.init(initialState: .init(currentStep: .step4)) {
      OnboardingViewReducer()
    }
    let onboardingView = OnboardingView(store: store).environment(\.colorScheme, .light)
    assertSnapshot(
      of: onboardingView, as: .image(perceptualPrecision: 0.98, layout: .device(config: .iPhoneSe)))
  }

  func testpage1_dark() async {
    let onboardingView = OnboardingView().environment(\.colorScheme, .dark).environment(
      \.locale, .init(identifier: "fr"))
    assertSnapshot(
      of: onboardingView, as: .image(perceptualPrecision: 0.98, layout: .device(config: .iPhoneSe)))
  }

  func testpage2_dark() async {
    let store = StoreOf<OnboardingViewReducer>.init(initialState: .init(currentStep: .step2)) {
      OnboardingViewReducer()
    }
    let onboardingView = OnboardingView(store: store)
      .environment(\.colorScheme, .dark)
      .environment(\.locale, .init(identifier: "fr"))

    assertSnapshot(
      of: onboardingView, as: .image(perceptualPrecision: 0.98, layout: .device(config: .iPhoneSe)))
  }

  func testpage3_dark() async {
    let store = StoreOf<OnboardingViewReducer>.init(initialState: .init(currentStep: .step3)) {
      OnboardingViewReducer()
    }
    let onboardingView = OnboardingView(store: store)
          .environment(\.colorScheme, .dark)
          .environment(\.locale, .init(identifier: "fr"))

    assertSnapshot(
      of: onboardingView, as: .image(perceptualPrecision: 0.98, layout: .device(config: .iPhoneSe)))
  }

  func testpage4_dark() async {
    let store = StoreOf<OnboardingViewReducer>.init(initialState: .init(currentStep: .step4)) {
      OnboardingViewReducer()
    }
    let onboardingView = OnboardingView(store: store).environment(\.colorScheme, .dark).environment(
      \.locale, .init(identifier: "fr"))
    assertSnapshot(
      of: onboardingView, as: .image(perceptualPrecision: 0.98, layout: .device(config: .iPhoneSe)))
  }
}