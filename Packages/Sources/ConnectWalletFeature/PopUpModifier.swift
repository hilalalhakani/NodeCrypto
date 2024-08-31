import Foundation
import SwiftUI
import StyleGuide

extension View {
  func popup(
    isPresented: Bool,
    confirmAction: @escaping () -> Void,
    cancelAction: @escaping () -> Void
  ) -> some View {
    self.modifier(
      PopUpModifier(
        isPresented: isPresented,
        confirmAction: confirmAction,
        cancelAction: cancelAction
      )
    )
  }
}

struct PopUpModifier: ViewModifier {
  let isPresented: Bool
  let confirmAction: () -> Void
  let cancelAction: () -> Void
  @Environment(\.colorScheme) var colorScheme

  func body(content: Content) -> some View {
    ZStack {
      content
        .zIndex(0)

      if isPresented {
          Color.neutral1
              .opacity(colorScheme == .dark ? 0.75 : 0.5)
          .ignoresSafeArea()
          .transition(.opacity.animation(.easeInOut))
          .zIndex(1)

        VStack(spacing: 0) {
          Text("This page will open another application.", bundle: .module)
            .multilineTextAlignment(.center)
            .foregroundStyle(Color.neutral2)
            .font(Font(FontName.poppinsRegular, size: 12))
            .frame(width: 215)
            .padding(.bottom, 20)

            Button(
                action: confirmAction,
                label: {
                    Text("Open")
                        .font(Font(FontName.dmSansBold, size: 14))
                        .frame(width: 160)
                }
            )
            .clipShape(Capsule())
            .buttonStyle(.borderedProminent)
            .foregroundStyle(.white)
            .tint(Color.primary1)
            .padding(.bottom, 12)

            Button(
                action: cancelAction,
                label: {
                    Text("Cancel")
                        .font(Font(FontName.dmSansBold, size: 14))
                        .frame(width: 160)
                }
            )
            .clipShape(Capsule())
            .buttonStyle(.borderedProminent)
            .foregroundStyle(Color.neutral2)
            .tint(.clear)
            .overlay(
                RoundedRectangle(cornerRadius: 90, style: .circular)
                    .inset(by: 1)
                    .stroke(Color.connectWalletCancelBorder)
            )


        }
        .padding(32)
        .background(
          Color.connectWalletAlertBackground
            .clipShape(RoundedRectangle(cornerRadius: 32, style: .circular))
        )
        .animation(.easeInOut, value: self.isPresented)
        .zIndex(2)
      }
    }
  }
}

