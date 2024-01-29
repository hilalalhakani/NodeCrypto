import NodeCryptoCore
import SwiftUI

@Reducer
public struct OnboardingViewReducer {
  public init() {}

  public struct State: Equatable {
    public var onboardingStepper: OnboardingStepperReducer.State
    @BindingState public var currentStep: OnboardingStep
    public var isGetStartedButtonHidden = true
    public init(currentStep: OnboardingStep = .step1) {
      self.currentStep = currentStep
      onboardingStepper = .init(currentStep: currentStep)
      isGetStartedButtonHidden = currentStep.rawValue != OnboardingStep.allCases.count - 1
    }
  }

  @CasePathable
  public enum Action: TCAFeatureAction {
    case view(ViewAction)
    case `internal`(InternalAction)
    case delegate(DelegateAction)

    init(action: OnboardingView.ViewAction) {
      switch action {
      case .binding(let action):
        self = .internal(.binding(action))
      case .onSkipButtonPressed:
        self = .view(.onSkipButtonPressed)
      case .onGetStartedButtonPressed:
        self = .view(.onGetStartedButtonPressed)
      }
    }
  }

  @CasePathable
  public enum InternalAction: BindableAction {
    case binding(BindingAction<State>)
  }

  @CasePathable
  public enum DelegateAction {
    case onGetStartedButtonPressed
  }

  @CasePathable
  public enum ViewAction {
    case onSelectedIndexChange(OnboardingStep)
    case onSkipButtonPressed
    case onGetStartedButtonPressed
    case onboardingStepper(OnboardingStepperReducer.Action)
  }

  public var body: some Reducer<State, Action> {

    BindingReducer(action: \.internal)

    AnalyticsReducer { _, action in
      switch action {
      case let .view(viewAction):
        switch viewAction {
        case .onSkipButtonPressed:
          return .event(name: "onSkipButtonPressed", properties: [:])

        case .onGetStartedButtonPressed:
          return .event(name: "onGetStartedButtonPressed", properties: [:])

        default:
          return .none
        }
      default:
        return .none
      }
    }

    NestedAction(\.view) { state, viewAction in
      switch viewAction {
      case .onboardingStepper(.delegate(.updatedStep)):
        state.currentStep = state.onboardingStepper.currentStep
        state.isGetStartedButtonHidden =
          state.currentStep.rawValue != OnboardingStep.allCases.count - 1
        return .none
      case .onboardingStepper:
        return .none
      case .onSkipButtonPressed:
        guard let lastStep = OnboardingStep.allCases.last else { return .none }
        state.currentStep = lastStep
        state.isGetStartedButtonHidden = false
        return updateStepper(state: &state)

      case let .onSelectedIndexChange(step):
        state.currentStep = step
        state.isGetStartedButtonHidden = step.rawValue != OnboardingStep.allCases.count - 1
        return updateStepper(state: &state)

      case .onGetStartedButtonPressed:
        return .run { send in
          await send(.delegate(.onGetStartedButtonPressed))
        }
      }

      func updateStepper(state: inout State) -> Effect<Action> {
        OnboardingStepperReducer(totalSteps: OnboardingStep.allCases.count)
          .reduce(into: &state.onboardingStepper, action: .internal(.updateStep(state.currentStep)))
          .map { Action.view(.onboardingStepper($0)) }
      }

    }

    NestedAction(\.internal) { state, action in
      state.isGetStartedButtonHidden =
        state.currentStep.rawValue != OnboardingStep.allCases.count - 1
      return OnboardingStepperReducer(totalSteps: OnboardingStep.allCases.count)
        .reduce(into: &state.onboardingStepper, action: .internal(.updateStep(state.currentStep)))
        .map { Action.view(.onboardingStepper($0)) }
    }

    Scope(state: \.onboardingStepper, action: \.view.onboardingStepper) {
      OnboardingStepperReducer(totalSteps: OnboardingStep.allCases.count)
    }
  }
}

extension BindingViewStore<OnboardingViewReducer.State> {
  var view: OnboardingView.ViewState {
    OnboardingView.ViewState(
      currentStep: self.$currentStep,
      isGetStartedButtonHidden: self.isGetStartedButtonHidden
    )
  }
}

public struct OnboardingView: View {
  var store: StoreOf<OnboardingViewReducer>

  public init(
    store: StoreOf<OnboardingViewReducer> = .init(initialState: .init()) { OnboardingViewReducer() }
  ) {
    self.store = store
  }

  struct ViewState: Equatable {
    @BindingViewState var currentStep: OnboardingStep
    var isGetStartedButtonHidden: Bool
  }

  enum ViewAction: Equatable, BindableAction {
    case binding(BindingAction<OnboardingViewReducer.State>)
    case onSkipButtonPressed
    case onGetStartedButtonPressed
  }

  public var body: some View {
    WithViewStore(store, observe: \.view, send: OnboardingViewReducer.Action.init) { viewStore in
      ZStack(alignment: .center) {
        BackgroundLinearGradient(
          colors: viewStore.currentStep.value().gradientColors
        )

        VStack {
          HStack {
            SkipButton(action: {
              viewStore.send(.onSkipButtonPressed)
            })

            Spacer()

            OnboardingBarStepper(
              numberOfSteps: OnboardingStep.allCases.count,
              currentStep: viewStore.$currentStep
            )
          }
          .frame(maxWidth: .infinity)

          BackgroundImage(
            imageResource: viewStore.currentStep.value().imageName
          )

          OnboardingLabels(
            title: viewStore.currentStep.value().title,
            subtitle: viewStore.currentStep.value().subtitle
          )

          Spacer()
            .frame(height: 75)

          Group {
            if viewStore.isGetStartedButtonHidden {
              OnboardingStepper(
                store: self.store.scope(
                  state: \.onboardingStepper,
                  action: \.view.onboardingStepper
                )
              )
            } else {
              Button(
                action: {
                  viewStore.send(.onGetStartedButtonPressed)
                },
                label: {
                  Text("Get started now", bundle: .module)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 16)
                }
              )
              .buttonStyle(.borderedProminent)
              .font(Font(FontName.dmSansBold, size: 16))
              .tint(Color.primary1)
              .clipShape(Capsule())
            }
          }
          .padding(.bottom, 40)
        }
        .padding([.horizontal, .top])
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .animation(.easeIn, value: viewStore.currentStep)
        .transition(
          AnyTransition.asymmetric(
            insertion: .offset(x: 0, y: 50),
            removal: .offset(x: 0, y: -50)
          )
          .combined(with: .opacity)
        )
      }
      .transition(.opacity.animation(.easeInOut))
    }
  }
}

struct BackgroundLinearGradient: View {
  var colors: [Color]

  var body: some View {
    LinearGradient(
      stops: [Gradient.Stop(color: colors[0], location: 0.50), Gradient.Stop(color: colors[1], location: 1.00)],
      startPoint: UnitPoint(x: 1, y: 0),
      endPoint: UnitPoint(x: 0, y: 1)
    )
    .ignoresSafeArea()
  }
}

struct BackgroundImage: View {
  let imageResource: ImageResource

  var body: some View {
    Image(imageResource)
      .resizable()
      .aspectRatio(contentMode: .fit)
      .frame(maxWidth: .infinity, alignment: .center)
  }
}

struct OnboardingLabels: View {
  let title: String
  let subtitle: String

  var body: some View {
    VStack(spacing: 12) {
      Text(LocalizedStringKey(title), bundle: .module)
        .font(Font(FontName.dmSansBold, size: 40))
        .foregroundStyle(Color.neutral2)

      Text(LocalizedStringKey(subtitle), bundle: .module)
        .font(Font(FontName.poppinsRegular, size: 14))
        .foregroundStyle(Color.neutral2)
    }
    .multilineTextAlignment(.center)
    .fixedSize(horizontal: false, vertical: true)
  }
}

#Preview {
    OnboardingView()
}
