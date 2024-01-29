import Foundation
import SwiftUI

public struct StepperButtonStyle: ButtonStyle {
    var isDisabled: Bool

    public init(isDisabled: Bool) {
        self.isDisabled = isDisabled
    }

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(
                Color.neutral2.opacity(isDisabled ? 0.5 : 1)
            )
    }
}
