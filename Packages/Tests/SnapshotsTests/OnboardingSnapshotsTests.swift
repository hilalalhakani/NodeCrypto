import ComposableArchitecture
import Foundation
import OnboardingFeature
import SnapshotTesting
import XCTest

#if os(iOS)
  @available(macOS, unavailable)
  final class OnboardingSnapshotsTests: XCTestCase {
    @MainActor
    func testpage1_light() {
        let store: StoreOf<OnboardingViewReducer> = .init(initialState: .init(currentStep: .step2)) {
          OnboardingViewReducer()
        }

      let onboardingView = OnboardingView(store: store)
        .environment(\.colorScheme, .light)

      assertSnapshot(
        of: onboardingView,
        as: .image(perceptualPrecision: precision, layout: .device(config: .iPhoneSe)))
    }

    @MainActor
    func testpage2_light() {
      let store: StoreOf<OnboardingViewReducer> = .init(initialState: .init(currentStep: .step2)) {
        OnboardingViewReducer()
      }

      let onboardingView = OnboardingView(store: store).environment(\.colorScheme, .light)
      assertSnapshot(
        of: onboardingView,
        as: .image(perceptualPrecision: precision, layout: .device(config: .iPhoneSe)))
    }

      @MainActor
    func testpage3_light() {
      let store: StoreOf<OnboardingViewReducer> = .init(initialState: .init(currentStep: .step3)) {
        OnboardingViewReducer()
      }

      let onboardingView = OnboardingView(store: store).environment(\.colorScheme, .light)
      assertSnapshot(
        of: onboardingView,
        as: .image(perceptualPrecision: precision, layout: .device(config: .iPhoneSe)))
    }

      @MainActor
    func testpage4_light() {
      let store: StoreOf<OnboardingViewReducer> = .init(initialState: .init(currentStep: .step4)) {
        OnboardingViewReducer()
      }

      let onboardingView = OnboardingView(store: store).environment(\.colorScheme, .light)
      assertSnapshot(
        of: onboardingView,
        as: .image(perceptualPrecision: precision, layout: .device(config: .iPhoneSe)))
    }

      @MainActor
    func testpage1_dark() {
      let store: StoreOf<OnboardingViewReducer> = .init(initialState: .init(currentStep: .step1)) {
        OnboardingViewReducer()
      }

      let onboardingView = OnboardingView(store: store)
        .environment(\.colorScheme, .dark)

      assertSnapshot(
        of: onboardingView,
        as: .image(perceptualPrecision: precision, layout: .device(config: .iPhoneSe)))
    }

    @MainActor
    func testpage2_dark() {
      let store = StoreOf<OnboardingViewReducer>.init(initialState: .init(currentStep: .step2)) {
        OnboardingViewReducer()
      }

      let onboardingView = OnboardingView(store: store)
        .environment(\.colorScheme, .dark)

      assertSnapshot(
        of: onboardingView,
        as: .image(perceptualPrecision: precision, layout: .device(config: .iPhoneSe)))
    }
      @MainActor
    func testpage3_dark() {
      let store = StoreOf<OnboardingViewReducer>.init(initialState: .init(currentStep: .step3)) {
        OnboardingViewReducer()
      }
      let onboardingView = OnboardingView(store: store)
        .environment(\.colorScheme, .dark)

      assertSnapshot(
        of: onboardingView,
        as: .image(perceptualPrecision: precision, layout: .device(config: .iPhoneSe)))
    }
      @MainActor
    func testpage4_dark() {
      let store = StoreOf<OnboardingViewReducer>.init(initialState: .init(currentStep: .step4)) {
        OnboardingViewReducer()
      }
      let onboardingView = OnboardingView(store: store)
        .environment(\.colorScheme, .dark)
      assertSnapshot(
        of: onboardingView,
        as: .image(perceptualPrecision: precision, layout: .device(config: .iPhoneSe)))
    }
  }
#endif
