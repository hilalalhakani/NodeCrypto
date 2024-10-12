//
//  File.swift
//  
//
//  Created by Hilal Hakkani on 10/04/2024.
//

import Foundation
import SwiftUI
import NodeCryptoCore

public enum MenuItem: String, CaseIterable, Sendable {
    case onSale = "On sale"
    case created = "Created"
    case aboutMe = "About me"
    case liked = "Liked"
}

struct MenuButton: View {
    @State var isExpanded = false
    @Binding var selectedTitle: MenuItem?
    var titles: [MenuItem]

    var body: some View {
        VStack(spacing: 16) {
            ForEach(isExpanded ? titles : selectedTitle.map { [$0] } ?? [], id: \.self) { menuItem in
                Cell(title: menuItem.rawValue, isSelected: selectedTitle == menuItem)
                    .contentShape(.rect)
                    .onTapGesture {
                        if isExpanded, let selected = selectedTitle, selected == menuItem {
                            isExpanded = false
                        } else {
                            selectedTitle = menuItem
                            isExpanded.toggle()
                        }
                    }
            }
        }
        .fixedSize()
        .transition(.opacity)
        .padding(16)
        .background(
            Color.glassDark
        )
        .clipShape(
            RoundedRectangle(cornerRadius: !isExpanded ? 48 : 20, style: .circular)
        )
        .padding(16)
        .frame(maxHeight: .infinity, alignment: .bottom)
    }

    struct Cell: View {
        let title: String
        let isSelected: Bool

        var body: some View {
            HStack(spacing: 40) {
                Text(title)
                    .frame(alignment: .leading)

                Spacer()

                if  isSelected {
                    Image(systemName: "checkmark")
                }
            }
            .font(.custom(FontName.poppinsRegular.rawValue, size: 14))
            .foregroundStyle(Color.neutral8)
        }
    }
}

//#Preview {
//    MenuButton()
//}


