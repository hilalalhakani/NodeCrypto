import ComposableArchitecture
import StyleGuide
import TCAHelpers
import SwiftUI

@Reducer
public struct OnboardingStepperFeature {
    @Shared(.currentStep) var currentStep: OnboardingStep = .step1
    public init() {}

    @ObservableState
    public struct State: Equatable, Sendable {
        public var forwardButtonDisabled = false
        public var backwardButtonDisabled = true
        public init() {}
    }

    @CasePathable
    public enum Action: TCAFeatureAction, Sendable {
        case view(ViewAction)
        case `internal`(InternalAction)
        case delegate(DelegateAction)
    }

    @CasePathable
    public enum InternalAction: Sendable {
        case updateButtons
    }

    @CasePathable
    public enum DelegateAction: Sendable {}

    @CasePathable
    public enum ViewAction: Sendable {
        case onForwardButtonPress
        case onBackwardButtonPress
        case onAppear
    }

    public var body: some Reducer<State, Action> {

        Reduce { state, action in

            switch action {
            case let .view(viewAction):
                switch viewAction {
                case .onForwardButtonPress:
                        if currentStep.rawValue < OnboardingStep.allCases.count - 1 {
                        $currentStep.withLock({ $0.next() })
                        state.backwardButtonDisabled = false
                        state.forwardButtonDisabled = currentStep.rawValue == OnboardingStep.allCases.count - 1
                    }
                    return .none

                case .onBackwardButtonPress:
                    if currentStep.rawValue > 0 {
                        $currentStep.withLock({ $0.previous() })
                        state.forwardButtonDisabled = false
                        state.backwardButtonDisabled = currentStep.rawValue == 0
                    }
                    return .none

                    case .onAppear:
                        return .publisher {
                            $currentStep
                                .publisher
                                .dropFirst()
                                .map{ _ in Action.internal(.updateButtons) }
                        }
                }
            case .delegate:
                return .none

                case .internal(let action):
                    switch action {
                        case .updateButtons:
                            state.forwardButtonDisabled = currentStep.rawValue == OnboardingStep.allCases.count - 1
                            state.backwardButtonDisabled = currentStep.rawValue == 0
                            return .none
                    }
            }
        }
    }
}

struct OnboardingStepper: View {
    @Bindable var store: StoreOf<OnboardingStepperFeature>
    let disabledColor = Color.neutral5

    init(store: StoreOf<OnboardingStepperFeature>) {
        self.store = store
    }

    var body: some View {
            HStack {
                Button(action: {
                    store.send(.view(.onBackwardButtonPress))
                }) {
                    Image(systemName: "arrow.backward")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(
                    StepperButtonStyle(isDisabled: store.backwardButtonDisabled)
                )

                Divider()
                    .frame(width: 2, height: 24)

                Button(action: {
                    store.send(.view(.onForwardButtonPress))
                }) {
                    Image(systemName: "arrow.forward")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(
                    StepperButtonStyle(isDisabled: store.forwardButtonDisabled)
                )
            }
            .frame(width: 154, height: 64)
            .background(Color.neutral8)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .circular))
            .task {
                store.send(.view(.onAppear))
            }
    }
}

#if DEBUG
    struct OnboardingStepperPreviewDark: PreviewProvider {
        static var previews: some View {
            OnboardingStepper(
                store: .init(
                    initialState: .init(),
                    reducer: { OnboardingStepperFeature() }
                )
            )
            .preferredColorScheme(.dark)
        }
    }

    struct OnboardingStepperPreviewLight: PreviewProvider {
        static var previews: some View {
            OnboardingStepper(
                store: .init(
                    initialState: .init(),
                    reducer: { OnboardingStepperFeature() }
                )
            )
            .preferredColorScheme(.light)
        }
    }
#endif
