//
//  ItemDetails.swift
//  Main
//
//  Created by Hilal Hakkani on 03/12/2024.
//

import SwiftUI
import StyleGuide
import SharedViews

struct ItemDetails: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Mind")
                .font(.init(FontName.poppinsBold, size: 25))
                .foregroundColor(.gray)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack {
                AsyncImageView(url: URL(string: "https://dummyimage.com/600x400/000/fff")!)
                    .frame(width: 20, height: 20)
                    .clipShape(Circle())

                Text("Jailyn Corona")
                    .font(.init(FontName.poppinsBold, size: 12))
                    .foregroundColor(Color.neutral3)
                    .lineLimit(1)

            }
            .frame(maxWidth: .infinity, alignment: .leading)

        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .frame(height: 144)
        .background {
            Color.white
        }
        .clipShape(.rect(cornerRadius: 16))
    }
}
