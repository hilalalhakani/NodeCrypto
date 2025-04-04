//
//  SellerItemView.swift
//  Main
//
//  Created by Hilal Hakkani on 03/12/2024.
//

import SwiftUI
import ResourceProvider
import SharedModels

struct SellerItemView: View {

    let creator: Creator

    var body: some View {
        HStack(spacing: 10) {
            Group {
                if let url = URL(string: creator.image) {
                    AsyncImageView(url: url)
                        .clipShape(Circle())
                } else {
                    Circle()
                        .foregroundStyle(.gray)
                }
            }
                .frame(width: 56, height: 56)

            VStack(alignment: .leading) {
                Text(creator.name)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .lineLimit(1)

                Text(creator.price)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
