//
//  APIClient+Home.swift
//  Main
//
//  Created by Hilal Hakkani on 12/12/2024.
//

import Foundation
@_exported import Dependencies
import Foundation
@_exported import SharedModels

extension APIClient {
    public struct Home: Sendable {
        public var getCreators: @Sendable () async throws -> [Creator]
        public var getNFTS: @Sendable () async throws -> [NFTItem] 

        public init(
            _ getCreators: @escaping @Sendable () async throws -> [Creator] = { [] },
            _ getNFTS: @escaping @Sendable () async throws -> [NFTItem] =  { [] }
        ) {
            self.getCreators = getCreators
            self.getNFTS = getNFTS
        }
    }
}
