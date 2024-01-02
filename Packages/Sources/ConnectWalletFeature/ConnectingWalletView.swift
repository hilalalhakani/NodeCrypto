//
//  SwiftUIView.swift
//  
//
//  Created by HH on 31/12/2023.
//

import SwiftUI
import StyleGuide

public struct ConnectingWalletView: View {
    @Environment (\.colorScheme) var colorScheme

    let selectedWallet: WalletType
    let cancelPressed: () -> Void

    public init(selectedWallet: WalletType, cancelPressed: @escaping () -> Void) {
        self.selectedWallet = selectedWallet
        self.cancelPressed = cancelPressed
    }

    public var body: some View {
        ZStack {
            Image(.connectWalletBackground)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()

            VStack(spacing: 32) {
                Image("\(selectedWallet.rawValue)", bundle: .module)
                    .resizable()
                    .frame(width: 80, height: 80)

                HStack(spacing: 8) {
                    ProgressView()
                        .tint(colorScheme == .light ? Color.neutral2 : Color.neutral8)

                    Text("Opening \(selectedWallet.rawValue)")
                        .font(Font.init(FontName.poppinsRegular, size: 14))
                        .foregroundStyle(colorScheme == .light ? Color.neutral2 : Color.neutral8)
                }
            }
        }
        .toolbar {
            #if os(iOS)
            ToolbarItem(placement: .navigationBarLeading) {
                CancelButton(action: cancelPressed)
            }
            #endif
        }
    }
}

struct CancelButton: View {
    let action: () -> Void
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        Button(action: { action() }) {
            Text("Cancel", bundle: .module)
                .font(.init(.dmSansBold, size: 14))
        }
        .foregroundStyle(Color.neutral2)
        .buttonStyle(.borderedProminent)
        .tint(colorScheme == .light ? Color.neutral6 : Color.neutral8
        )
        .clipShape(Capsule())
    }
}

#Preview {
    ConnectingWalletView(selectedWallet: .metamask, cancelPressed: {})
}
