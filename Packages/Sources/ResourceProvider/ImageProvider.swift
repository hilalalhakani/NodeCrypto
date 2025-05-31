//
//  File.swift
//
//
//  Created by Hilal Hakkani on 31/07/2024.
//

import Foundation
import Kingfisher
import SwiftUI

public struct AsyncImageView: View {
    public let url: URL

    public init(url: URL) {
        self.url = url
    }

    public init(_ string: String) {
        self.init(url: URL(string: string)!)
    }

    public var body: some View {
        if let _ = NSClassFromString("XCTest") {
            Color.red
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        else {
            KFImage(url)
                .resizable()
                .fade(duration: 4)
                .placeholder {
                    Rectangle()
                        .foregroundColor(background)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
//                        .transition(.opacity)
                }
                .retry(maxCount: .max, interval: .seconds(1))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
         }
    }

    var background: Color {
        #if os(iOS)
            Color(UIColor.lightGray)
        #elseif os(macOS)
            Color(NSColor.lightGray)
        #endif
    }
}
