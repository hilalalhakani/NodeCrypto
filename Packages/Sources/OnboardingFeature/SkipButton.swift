import Foundation
import SwiftUI
import StyleGuide

struct SkipButton: View {
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      Text("Skip", bundle: .module)
        .font(.init(.dmSansBold, size: 14))
    }
    .foregroundStyle(Color.neutral2)
    .buttonStyle(.borderedProminent)
    .tint(.skipButtonTint)
  }
}

#Preview {
    SkipButton() {}
}
