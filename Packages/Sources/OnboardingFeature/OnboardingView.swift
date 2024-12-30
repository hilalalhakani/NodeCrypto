import NodeCryptoCore
import SwiftUI

@Reducer
public struct OnboardingViewReducer: Sendable {
    public init() {}
    @Shared(.currentStep) public var currentStep

    @ObservableState
    public struct State: Equatable, Sendable {
        public var onboardingStepper: OnboardingStepperReducer.State = .init()
        public var isGetStartedButtonHidden = true
        public init() {}
    }

    @CasePathable
    public enum Action: TCAFeatureAction {
        case view(ViewAction)
        case `internal`(InternalAction)
        case delegate(DelegateAction)
    }

    @CasePathable
    public enum InternalAction: BindableAction {
        case binding(BindingAction<State>)
        case updateStep(OnboardingStep)
    }

    @CasePathable
    public enum DelegateAction {
        case onGetStartedButtonPressed
    }

    @CasePathable
    public enum ViewAction {
        case onAppear
        case onSelectedIndexChange(OnboardingStep)
        case onSkipButtonPressed
        case onGetStartedButtonPressed
        case onboardingStepper(OnboardingStepperReducer.Action)
    }

    public var body: some Reducer<State, Action> {

        CombineReducers {
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
                    case .onAppear:
                        return .run { send in
                            for await step in $currentStep.publisher.dropFirst().values {
                                await send(.internal(.updateStep(step)))
                            }
                        }
                    case .onboardingStepper:
                        return .none
                    case .onSkipButtonPressed:
                        guard let lastStep = OnboardingStep.allCases.last else { return .none }
                        $currentStep.withLock({ $0 = lastStep })
                        state.isGetStartedButtonHidden = false
                        state.onboardingStepper.forwardButtonDisabled = true
                        return .none

                    case let .onSelectedIndexChange(step):
                        $currentStep.withLock({ $0 = step })
                        return .none

                    case .onGetStartedButtonPressed:
                        return .run { send in
                            await send(.delegate(.onGetStartedButtonPressed))
                        }
                }
            }

            NestedAction(\.internal) { state, action in
                state.isGetStartedButtonHidden =
                    currentStep.rawValue != OnboardingStep.allCases.count - 1
                return .none
            }

            Scope(state: \.onboardingStepper, action: \.view.onboardingStepper) {
                OnboardingStepperReducer()
            }
        }
    }
}

public struct OnboardingView: View {
    @Bindable var store: StoreOf<OnboardingViewReducer>
    @Shared(.currentStep) var currentStep
    public init(
        store: StoreOf<OnboardingViewReducer> = .init(initialState: .init()) {
            OnboardingViewReducer()
        }
    ) {
        self.store = store
    }

    public var body: some View {
        ZStack(alignment: .center) {
            BackgroundLinearGradient(
                colors: currentStep.value().gradientColors
            )
            .ignoresSafeArea()

            VStack {
                HStack {
                    SkipButton(action: {
                        store.send(.view(.onSkipButtonPressed))
                    })

                    Spacer()

                    OnboardingBarStepper(
                        numberOfSteps: OnboardingStep.allCases.count,
                        currentStep: .init(get: { currentStep }, set: { store.send(.view(.onSelectedIndexChange($0)))})
                    )
                }
                .frame(maxWidth: .infinity)

                BackgroundImage(
                    imageResource: currentStep.value().imageName
                )

                OnboardingLabels(
                    title: currentStep.value().title,
                    subtitle: currentStep.value().subtitle
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
                    }
                    else {
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
            .animation(.easeIn, value: currentStep)
            .transition(
                AnyTransition.asymmetric(
                    insertion: .offset(x: 0, y: 50),
                    removal: .offset(x: 0, y: -50)
                )
                .combined(with: .opacity)
            )
        }
        .transition(.opacity.animation(.easeInOut))
        .task {
            store.send(.view(.onAppear))
        }
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
