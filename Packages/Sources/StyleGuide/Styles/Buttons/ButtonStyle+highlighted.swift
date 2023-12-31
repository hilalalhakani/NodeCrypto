import Foundation
import SwiftUI

extension ButtonStyle where Self == HighlightButtonStyle {
    public static var highlighted: HighlightButtonStyle {
        .init()
    }
}

public struct HighlightButtonStyle: ButtonStyle {
    @ScaledMetric var buttonHeight: CGFloat = 64
    public init() {}
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal)
            .frame(height: buttonHeight)
            .background(configuration.isPressed ? .secondary : .primary)
            .foregroundStyle(configuration.isPressed ? .secondary : .primary)
            .cornerRadius(20)
    }
}

struct HighlightButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        Button {
        } label: {
            Text(verbatim: "Hello, world!")
        }
        .buttonStyle(HighlightButtonStyle())
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundStyle(.white)
        .tint(.orange)
    }
}
