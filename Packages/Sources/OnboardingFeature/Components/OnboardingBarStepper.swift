import NodeCryptoCore
import SwiftUI

struct OnboardingBarStepper: View {
    let numberOfSteps: Int

    @Binding var currentStep: OnboardingStep

    var body: some View {
        HStack {
            ForEach(0 ... numberOfSteps - 1, id: \.self) { index in
                Button(
                    action: {
                        currentStep = .init(rawValue: index)!
                    },
                    label: {
                        RoundedRectangle(cornerRadius: 4, style: .circular)
                    }
                )
                .animation(.easeIn, value: currentStep)
                .buttonStyle(
                    StepperBarButtonStyle(
                        selectedIndex: $currentStep.wrappedValue.rawValue, currentIndex: index
                    ))
            }
        }
    }
}

#if DEBUG

#Preview {

    struct Preview: View {
        @State var currentStep = OnboardingStep.step1
        var body: some View {
            OnboardingBarStepper(numberOfSteps: 4, currentStep: $currentStep)
        }
    }

    return Preview()
        .preferredColorScheme(.dark)
}

#endif
