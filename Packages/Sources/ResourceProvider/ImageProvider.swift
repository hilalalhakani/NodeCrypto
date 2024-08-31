//
//  File.swift
//
//
//  Created by Hilal Hakkani on 31/07/2024.
//

import Foundation
import SwiftUI
import Kingfisher

public struct AsyncImageView: View
{
    public let url: URL

    public init(url: URL) {
        self.url = url
    }

    public var body: some View {
        if let _ = NSClassFromString("XCTest") {
            Color.red
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        else {
            KFImage(url)
                .resizable()
                .fade(duration: 0.25)
                .placeholder {
                    Rectangle()
                        .foregroundColor(.gray.opacity(0.3))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .retry(maxCount: .max, interval: .seconds(1))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(UIColor.lightGray))
        }
    }
}
