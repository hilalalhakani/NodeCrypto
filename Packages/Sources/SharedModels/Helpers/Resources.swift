//
//  File.swift
//
//
//  Created by HH on 09/12/2023.
//

import Foundation
import SwiftUI
#if canImport(UIKit)
    import UIKit
#endif

public struct ImageDataResource: Sendable {
    public var data: Data
    public init(data: Data) {
        self.data = data
    }

    public var image: Image? {
        #if os(macOS)
            NSImage(data: data).map(Image.init)?.resizable()
        #elseif os(iOS)
            UIImage(data: data).map(Image.init(uiImage:))?.resizable()
        #endif
    }
}

public struct PDFResource: Sendable {
    public var data: Data
    public init(data: Data) {
        self.data = data
    }
}
