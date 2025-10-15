//
//  File.swift
//
//
//  Created by Hilal Hakkani on 31/07/2024.
//

import Foundation
import SharedModels
import StyleGuide
import SwiftUI
import SharedViews

struct NFTItemView: View {
    let nft: NFT
    var body: some View {
        HStack(spacing: 20) {
            AsyncImageView(url: .init(string: nft.imageURL)!)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .frame(width: 144, height: 112)

            VStack(alignment: .leading, spacing: 12) {
                Text("The creative work title")
                    .font(Font.custom(FontName.poppinsBold.rawValue, size: 18))
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .foregroundStyle(Color.neutral2)

                Text("1.2 ETH")
                    .font(Font.custom(FontName.poppinsBold.rawValue, size: 12))
                    .foregroundStyle(Color.neutral4)

                HStack(spacing: 4) {
                    Image(ImageResource.heart)

                    Text("27")
                        .font(Font.custom(FontName.poppinsBold.rawValue, size: 12))
                        .foregroundStyle(Color.neutral3)
                }
            }
            .frame(alignment: .leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 112)
    }
}
