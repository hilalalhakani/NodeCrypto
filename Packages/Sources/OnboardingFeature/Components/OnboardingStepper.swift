import NodeCryptoCore
import SwiftUI

@Reducer
public struct OnboardingStepperReducer {
    let totalSteps: Int

    public init(totalSteps: Int) {
        self.totalSteps = totalSteps
    }

    @ObservableState
    public struct State: Equatable {
        @Shared public var currentStep: OnboardingStep
        public var forwardButtonDisabled = false
        public var backwardButtonDisabled = true

        public init(currentStep: Shared<OnboardingStep>) {
            self._currentStep = currentStep
            forwardButtonDisabled = currentStep.wrappedValue.rawValue == OnboardingStep.allCases.count - 1
            backwardButtonDisabled = currentStep.wrappedValue.rawValue == 0
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
    public enum DelegateAction {}

    @CasePathable
    public enum ViewAction {
        case onForwardButtonPress
        case onBackwardButtonPress
    }

    public var body: some Reducer<State, Action> {

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
                    return .none

                case .onBackwardButtonPress:
                    if state.currentStep.rawValue > 0 {
                        state.currentStep.previous()
                        state.forwardButtonDisabled = false
                        state.backwardButtonDisabled = state.currentStep.rawValue == 0
                    }
                    return .none
                }
            case .delegate:
                return .none

                case .internal:
                    return .none
            }
        }
        .onChange(of: \.currentStep) { oldValue, newValue in
            Reduce { state, _ in
                state.currentStep = newValue
                state.forwardButtonDisabled = newValue.rawValue == totalSteps - 1
                state.backwardButtonDisabled = newValue.rawValue == 0
                return .none
            }
        }
    }
}

struct OnboardingStepper: View {
    @Perception.Bindable var store: StoreOf<OnboardingStepperReducer>
    let disabledColor = Color.neutral5

    init(store: StoreOf<OnboardingStepperReducer>) {
        self.store = store
    }

    var body: some View {
        WithPerceptionTracking {
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
        }
    }
}

#if DEBUG
    struct OnboardingStepperPreviewDark: PreviewProvider {
        static var previews: some View {
            OnboardingStepper(
                store: .init(
                    initialState: .init(currentStep: Shared(.step1)),
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
                    initialState: .init(currentStep: Shared(.step1)),
                    reducer: { OnboardingStepperReducer(totalSteps: 4) }
                )
            )
            .preferredColorScheme(.light)
        }
    }
#endif
