//
//  File.swift
//
//
//  Created by HH on 09/12/2023.
//

import Foundation

public enum ResourceLocation: Hashable, Sendable, Codable {
    case url(URL)
    case local(String)
}

public struct ResourceKey<Output>: Hashable, Sendable, Codable {
    public let location: ResourceLocation

    public init(location: ResourceLocation) {
        self.location = location
    }
}
