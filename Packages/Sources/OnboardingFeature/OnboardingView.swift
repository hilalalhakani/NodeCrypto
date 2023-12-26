import NodeCryptoCore
import SwiftUI

@Reducer
public struct OnboardingViewReducer {
    public init() {}

    @ObservableState
    public struct State: Equatable {
        public var onboardingStepper: OnboardingStepperReducer.State
        public var currentStep: OnboardingStep
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
    }

    @CasePathable
    public enum InternalAction {}

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

        Reduce { state, action in
            switch action {
            case let .view(viewAction):
                switch viewAction {
                case .onboardingStepper(.delegate(.updatedStep)):
                    state.currentStep = state.onboardingStepper.currentStep
                    state.isGetStartedButtonHidden = state.currentStep.rawValue != OnboardingStep.allCases.count - 1
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

            default:
                return .none
            }

            func updateStepper(state: inout State) -> Effect<Action> {
                OnboardingStepperReducer(totalSteps: OnboardingStep.allCases.count)
                    .reduce(into: &state.onboardingStepper, action: .internal(.updateStep(state.currentStep)))
                    .map { Action.view(.onboardingStepper($0)) }
            }
        }

        Scope(state: \.onboardingStepper, action: \.view.onboardingStepper) {
            OnboardingStepperReducer(totalSteps: OnboardingStep.allCases.count)
        }
    }
}

public struct OnboardingView: View {
    @Environment(\.colorScheme) var colorScheme
    @Bindable var store: StoreOf<OnboardingViewReducer>

    public init(
        store: StoreOf<OnboardingViewReducer> = .init(initialState: .init()) { OnboardingViewReducer() }
    ) {
        self.store = store
    }

    public var body: some View {
        ZStack(alignment: .center) {
            BackgroundLinearGradient(
                colors: store.currentStep.value().gradientColors
            )

            VStack {
                HStack {
                    SkipButton(action: {
                        store.send(.view(.onSkipButtonPressed))
                    })

                    Spacer()

                    OnboardingBarStepper(
                        numberOfSteps: OnboardingStep.allCases.count,
                        currentStep: $store.onboardingStepper.currentStep.sending(\.view.onSelectedIndexChange)
                    )
                }
                .frame(maxWidth: .infinity)

                BackgroundImage(
                    imageResource: store.currentStep.value().imageName
                )

                OnboardingLabels(
                    title: store.currentStep.value().title,
                    subtitle: store.currentStep.value().subtitle
                )

                Spacer()
                    .frame(height: 75)

                Group {
                    if store.isGetStartedButtonHidden {
                        OnboardingStepper(
                            store: self.store.scope(
                                state: \.onboardingStepper,
                                action: \.view.onboardingStepper
                            )
                        )
                    } else {
                        Button(
                            action: {
                                store.send(.view(.onGetStartedButtonPressed))
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
            .animation(.easeIn, value: store.currentStep)
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

struct BackgroundLinearGradient: View {
    var colors: [Color]
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        LinearGradient(
            stops: colorScheme == .light
                ? [
                    Gradient.Stop(color: colors[0], location: 0.50),
                    Gradient.Stop(color: colors[1], location: 1.00)
                ]
                : [
                    Gradient.Stop(
                        color: Color(red: 13 / 255, green: 17 / 255, blue: 23 / 255), location: 0.50
                    ),
                    Gradient.Stop(
                        color: Color(red: 34 / 255, green: 44 / 255, blue: 55 / 255), location: 1.00
                    )
                ],
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
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(spacing: 12) {
            Text(LocalizedStringKey(title), bundle: .module)
                .font(Font(FontName.dmSansBold, size: 40))
                .foregroundStyle(colorScheme == .light ? Color.neutral2 : Color.neutral8)

            Text(LocalizedStringKey(subtitle), bundle: .module)
                .font(Font(FontName.poppinsRegular, size: 14))
                .foregroundStyle(colorScheme == .light ? Color.neutral2 : Color.neutral6)
        }
        .multilineTextAlignment(.center)
        .fixedSize(horizontal: false, vertical: true)
    }
}

struct SkipButton: View {
    let action: () -> Void
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        Button(action: action) {
            Text("Skip", bundle: .module)
                .font(.init(.dmSansBold, size: 14))
        }
        .foregroundStyle(colorScheme == .dark ? Color.neutral8 : Color.neutral2)
        .buttonStyle(.borderedProminent)
        .tint(
            colorScheme == .dark
                ? Color.hex(0xFCFCDD).opacity(0.1) : Color.hex(0xFCFCDD).opacity(0.5)
        )
    }
}

#if DEBUG
    struct OnboardingViewPreviewDark: PreviewProvider {
        static var previews: some View {
            OnboardingView()
                .preferredColorScheme(.light)

            OnboardingView()
                .preferredColorScheme(.dark)
        }
    }
#endif
