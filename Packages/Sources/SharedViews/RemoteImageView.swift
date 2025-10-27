//
//  File.swift
//
//
//  Created by Hilal Hakkani on 31/07/2024.
//

import Foundation
import SwiftUI

public struct RemoteImageView: View {
    public let url: URL

    public init(url: URL) {
        self.url = url
    }

    public init(_ string: String) {
        self.init(url:  URL(string: string)!)
    }

    public var body: some View {
        if let _ = NSClassFromString("XCTest") {
            Color.red
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        else {
            AsyncImage(url: url) { image in
                image
                    .resizable()
            } placeholder: {
                Rectangle()
                    .foregroundColor(background)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    var background: Color {
        Color.gray.opacity(0.2)
    }
}
