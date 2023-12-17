import Foundation
import SwiftUI

public struct StepperButtonStyle: ButtonStyle {
    var isDisabled: Bool
    @Environment(\.colorScheme) var colorScheme

    public init(isDisabled: Bool) {
        self.isDisabled = isDisabled
    }

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(
                isDisabled ? Color.neutral5 : (colorScheme == .dark ? Color.neutral8 : Color.neutral2))
    }
}
