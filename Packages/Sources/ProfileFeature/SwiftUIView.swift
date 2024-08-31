//
//  SwiftUIView.swift
//
//
//  Created by Hilal Hakkani on 15/06/2024.
//

import StyleGuide
import SwiftUI
import UIKit

struct ProfileTextField: View {
    let title: String
    @Binding var text: String
    var textFieldHeight: CGFloat = 48
    var overlayImageName: String? = nil
    var accessoryViewTapped: (() -> Void)?

    var body: some View {

        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .foregroundStyle(Color.neutral5)
                .font(.custom(FontName.poppinsBold.rawValue, size: 12))
                .frame(maxWidth: .infinity, alignment: .leading)
            TextField("", text: $text, axis: .vertical)
                .lineLimit(2)
                .padding(.horizontal, 16)
                .frame(height: textFieldHeight)
                .background(Color.neutral8)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .font(.custom(FontName.poppinsRegular.rawValue, size: 14))
                .textFieldStyle(.plain)
                .overlay(alignment: .trailing) {
                    if let overlayImageName {
                        Button(action: { accessoryViewTapped?() }) {
                            Image(overlayImageName, bundle: .module)
                                .frame(width: 16, height: 16)
                        }
                        .padding(.trailing, 16)
                        .frame(height: textFieldHeight)
                    }
                }
                .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    ProfileTextField(title: "Display Name", text: .constant(""))
}
