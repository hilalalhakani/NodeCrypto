import NodeCryptoCore
import SwiftUI

@Reducer
public struct OnboardingStepperReducer {
    let totalSteps: Int

    public init(totalSteps: Int) {
        self.totalSteps = totalSteps
    }

    public struct State: Equatable {
        @BindingState public var currentStep: OnboardingStep
        public var forwardButtonDisabled = false
        public var backwardButtonDisabled = true

        public init(currentStep: OnboardingStep) {
            self.currentStep = currentStep
            forwardButtonDisabled = currentStep.rawValue == OnboardingStep.allCases.count - 1
            backwardButtonDisabled = currentStep.rawValue == 0
        }
    }

    @CasePathable
    public enum Action: TCAFeatureAction {
        case view(ViewAction)
        case `internal`(InternalAction)
        case delegate(DelegateAction)
    }

    @CasePathable
    public enum InternalAction: BindableAction {
        case updateStep(OnboardingStep)
        case binding(BindingAction<State>)
    }

    @CasePathable
    public enum DelegateAction {
        case updatedStep
    }

    @CasePathable
    public enum ViewAction {
        case onForwardButtonPress
        case onBackwardButtonPress
    }

    public var body: some Reducer<State, Action> {

        BindingReducer(action: \.internal)

        Reduce { state, action in

            switch action {
            case let .view(viewAction):
                switch viewAction {
                case .onForwardButtonPress:
                    if state.currentStep.rawValue < totalSteps - 1 {
                        state.currentStep.next()
                        state.backwardButtonDisabled = false
                        state.forwardButtonDisabled = state.currentStep.rawValue == totalSteps - 1
                    }
                    return .send(.delegate(.updatedStep))

                case .onBackwardButtonPress:
                    if state.currentStep.rawValue > 0 {
                        state.currentStep.previous()
                        state.forwardButtonDisabled = false
                        state.backwardButtonDisabled = state.currentStep.rawValue == 0
                    }
                    return .send(.delegate(.updatedStep))
                }
            case .delegate:
                return .none

            case let .internal(internalAction):
                switch internalAction {
                case let .updateStep(step):
                    state.currentStep = step
                    state.forwardButtonDisabled = step.rawValue == totalSteps - 1
                    state.backwardButtonDisabled = step.rawValue == 0
                    return .none
                case .binding:
                    return .none
                }
            }
        }
    }
}

struct OnboardingStepper: View {
    let store: StoreOf<OnboardingStepperReducer>
    let disabledColor = Color.neutral5

    init(store: StoreOf<OnboardingStepperReducer>) {
        self.store = store
    }

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            HStack {
                Button(action: {
                    viewStore.send(.view(.onBackwardButtonPress))
                }) {
                    Image(systemName: "arrow.backward")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(
                    StepperButtonStyle(isDisabled: viewStore.backwardButtonDisabled)
                )

                Divider()
                    .frame(width: 2, height: 24)

                Button(action: {
                    viewStore.send(.view(.onForwardButtonPress))
                }) {
                    Image(systemName: "arrow.forward")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(
                    StepperButtonStyle(isDisabled: viewStore.forwardButtonDisabled)
                )
            }
            .frame(width: 154, height: 64)
            .background(Color.neutral8)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}

#if DEBUG
    struct OnboardingStepperPreviewDark: PreviewProvider {
        static var previews: some View {
            OnboardingStepper(
                store: .init(
                    initialState: .init(currentStep: .step1),
                    reducer: { OnboardingStepperReducer(totalSteps: 4) }
                )
            )
            .preferredColorScheme(.dark)
        }
    }

    struct OnboardingStepperPreviewLight: PreviewProvider {
        static var previews: some View {
            OnboardingStepper(
                store: .init(
                    initialState: .init(currentStep: .step1),
                    reducer: { OnboardingStepperReducer(totalSteps: 4) }
                )
            )
            .preferredColorScheme(.light)
        }
    }
#endif
