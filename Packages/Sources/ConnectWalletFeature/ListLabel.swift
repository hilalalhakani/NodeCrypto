//
//  File.swift
//  
//
//  Created by HH on 30/12/2023.
//

import Foundation
import SwiftUI
import StyleGuide

struct ListLabel: View {

  let title: LocalizedStringKey
  let icon: ImageResource
  let didSelectButton: () -> Void
    @Environment(\.colorScheme) var  colorScheme
  init(
    title: LocalizedStringKey, icon: ImageResource,
    didSelectButton: @autoclosure @escaping () -> Void
  ) {
    self.title = title
    self.icon = icon
    self.didSelectButton = didSelectButton
  }

  var body: some View {

    Button(
      action: didSelectButton,
      label: {
        HStack {
          Label(
            title: {
              Text(title, bundle: .module)
                .font(Font(FontName.poppinsBold, size: 18))
                .foregroundStyle(colorScheme == .light ? Color.neutral2 : Color.neutral8)
            },
            icon: { Image(icon) }
          )
          Spacer()
          Image(systemName: "chevron.right")
                .foregroundStyle(colorScheme == .light ? Color.neutral2 : Color.neutral8)
        }
        .frame(maxWidth: .infinity)
      }
    )
    .frame(height: 65)
    .foregroundStyle(.white.opacity(0.0001), colorScheme == .light ? Color.white.opacity(1) : Color.hex(0xFCFCDD).opacity(0.1))
    .buttonStyle(.highlighted)
  }

}
