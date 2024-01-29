import Foundation
import SwiftUI

extension ButtonStyle where Self == HighlightButtonStyle {
    public static var highlighted: HighlightButtonStyle {
        .init()
    }
}

public struct HighlightButtonStyle: ButtonStyle {
    @ScaledMetric var buttonHeight: CGFloat = 64
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal)
            .frame(height: buttonHeight)
            .background(configuration.isPressed ? .secondary : .primary)
            .cornerRadius(16)
    }
}

#Preview {
    Button {
    } label: {
        Text(verbatim: "Hello, world!")
            .foregroundStyle(.red)

    }
    .foregroundStyle(.black.opacity(0.000001), .green)
    .buttonStyle(.highlighted)
}
