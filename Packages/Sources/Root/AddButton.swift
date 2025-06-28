import Foundation
import SwiftUI
import NodeCryptoCore

public struct AddButton: View {
    let action: () -> Void

    public init(action: @escaping () -> Void) {
        self.action = action
    }

    public var body: some View {
        Button(
            action: {
                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                impactFeedback.impactOccurred()
                action()
            },
            label: {
                Image(ImageResource.add)
                    .padding(12)
                    .background(
                        Circle()
                            .foregroundStyle(Color.primary1)
                            .shadow(color: Color.primary1.opacity(0.3), radius: 4, x: 0, y: 2)
                    )
            }
        )
        .frame(width: 48, height: 48)
        .buttonStyle(ScaleButtonStyle())
    }
}

public struct ScaleButtonStyle: ButtonStyle {
    public init() {}
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    AddButton() {}
}
