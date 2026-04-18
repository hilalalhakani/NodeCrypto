import SwiftUI
import StyleGuide

public struct BottomSheetBackground<Content: View>: View {
    let cornerRadius: CGFloat
    let content: Content

    public init(cornerRadius: CGFloat = 32, @ViewBuilder content: () -> Content) {
        self.cornerRadius = cornerRadius
        self.content = content()
    }

    public var body: some View {
        Color.connectWalletGradient1.opacity(0.2)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea(edges: [.bottom])
#if os(iOS)
            .cornerRadius(cornerRadius, corners: [.topLeft, .topRight])
#else
            .topCornerRadius(cornerRadius)
#endif
            .ignoresSafeArea(edges: [.bottom])
            .overlay {
                ScrollView {
                    content
                }
            }
    }
}
