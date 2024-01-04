//
//  File.swift
//  
//
//  Created by HH on 30/12/2023.
//

import Foundation
import SwiftUI
import StyleGuide

public struct ListView: View {

  let didSelectButton: (WalletType) -> Void
    @Environment(\.colorScheme) var  colorScheme
  init(didSelectButton: @escaping (WalletType) -> Void) {
    self.didSelectButton = didSelectButton
  }

  public var body: some View {
    RoundedRectangle(cornerRadius: 32)
      .foregroundStyle(colorScheme == .light ? .white.opacity(0.6) : Color.neutral3)
      .overlay(
        VStack {
          Text("Choose your wallet", bundle: .module)
             .foregroundStyle(  colorScheme == .light ? Color.neutral2 : .neutral8)
            .font(Font(FontName.poppinsRegular, size: 16))

          LabelsView()

          ScrollView {

            VStack(spacing: 8) {
              ListLabel(
                title: "Rainbow",
                walletType: .rainbow,
                didSelectButton: didSelectButton(.rainbow)
              )

              ListLabel(
                title: "Coinbase",
                walletType: .coinbase,
                didSelectButton: didSelectButton(.coinbase)
              )

              ListLabel(
                title: "Metamasak",
                walletType: .metamask,
                didSelectButton: didSelectButton(.metamask)
              )

            }
          }

        }
        .padding(24)
      )
  }
}
