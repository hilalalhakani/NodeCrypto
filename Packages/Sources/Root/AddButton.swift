import Foundation
import SwiftUI
import NodeCryptoCore

struct AddButton: View {
  let action: () -> Void
  var body: some View {
    Button(
      action: action,
      label: {
        Image(ImageResource.add)
          .padding(12)
          .background(
            Circle()
              .foregroundStyle(Color.primary1)
          )
      }
    )
    .frame(width: 48, height: 48)
  }
}

#Preview {
    AddButton() {}
}
