import Foundation
import SwiftUI

public struct StepperBarButtonStyle: ButtonStyle {
    var selectedIndex: Int
    var currentIndex: Int

    public init(selectedIndex: Int, currentIndex: Int) {
        self.selectedIndex = selectedIndex
        self.currentIndex = currentIndex
    }

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(
                currentIndex == selectedIndex ?
                    Color.primary1 : Color.hex(0xFCFCFD).opacity(0.5)
            )
            .frame(width: selectedIndex == currentIndex ? 24 : 12, height: 4)
    }
}
