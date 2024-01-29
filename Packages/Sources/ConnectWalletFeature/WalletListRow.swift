//
//  File.swift
//  
//
//  Created by HH on 30/12/2023.
//

import Foundation
import SwiftUI
import StyleGuide

struct WalletListRow: View {
  let title: LocalizedStringKey
  let walletType: WalletType
  let didSelectButton: () -> Void

  init(
    title: LocalizedStringKey,
    walletType: WalletType,
    didSelectButton: @autoclosure @escaping () -> Void
  ) {
    self.title = title
    self.walletType = walletType
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
                .foregroundStyle(Color.neutral2)
            },
            icon: { Image(walletType.rawValue, bundle: .module) }
          )
          Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(Color.neutral2)
        }
      }
    )
    .buttonStyle(.highlighted)
    .foregroundStyle(Color.invisibleColor, Color.highlightedButtonSelected)
  }

}
