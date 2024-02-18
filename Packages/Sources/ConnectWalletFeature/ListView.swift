//
//  File.swift
//  
//
//  Created by HH on 30/12/2023.
//

import Foundation
import SwiftUI
import StyleGuide
import SharedModels

public struct ListView: View {
  let didSelectButton: (WalletType) -> Void
    
  init(didSelectButton: @escaping (WalletType) -> Void) {
    self.didSelectButton = didSelectButton
  }

  public var body: some View {
    RoundedRectangle(cornerRadius: 32)
      .foregroundStyle(Color.neutral8)
      .overlay(
        VStack {
          Text("Choose your wallet", bundle: .module)
             .foregroundStyle(Color.neutral2)
            .font(Font(FontName.poppinsRegular, size: 16))

          LabelsView()

          ScrollView {

            VStack(spacing: 8) {
              WalletListRow(
                title: "Rainbow",
                walletType: .rainbow,
                didSelectButton: didSelectButton(.rainbow)
              )

              WalletListRow(
                title: "Coinbase",
                walletType: .coinbase,
                didSelectButton: didSelectButton(.coinbase)
              )

              WalletListRow(
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
