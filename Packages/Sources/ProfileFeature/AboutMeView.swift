//
//  AboutMeView.swift
//
//
//  Created by Hilal Hakkani on 26/05/2024.
//

import ComposableArchitecture
import ResourceProvider
import SharedModels
import StyleGuide
import SwiftUI

struct AboutMeItemView: View {
    let color: Color
    let iconName: String
    let title: String
    let count: String

    var body: some View {
        HStack(spacing: 0) {

            Circle()
                .foregroundStyle(color)
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: iconName)
                        .resizable()
                        .foregroundStyle(Color.neutral8)
                        .frame(width: 16, height: 16)
                )
                .padding(.horizontal, 12)

            VStack(alignment: .leading) {
                Text(title)
                    .foregroundStyle(Color.neutral3)
                    .font(.custom(FontName.poppinsRegular.rawValue, size: 12))
                Text(count)
                    .foregroundStyle(Color.neutral2)
                    .font(.custom(FontName.poppinsBold.rawValue, size: 18))
            }

            Spacer()
        }
        .frame(height: 92)
        .background(
            Color.neutral7
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .circular))
        )
    }
}
