//
//  File.swift
//
//
//  Created by Hilal Hakkani on 09/04/2024.
//

import Dependencies
import Foundation
@_exported import SharedModels

extension APIClient {
    public struct Profile: Sendable {
        public var getSavedNFT: @Sendable () async throws -> [NFT]
        public var getUserInfo: @Sendable () async throws -> [AboutMeItem]
        public var getCreatedNFT: @Sendable () async throws -> [NFT]
        public var getLikedNFT: @Sendable () async throws -> [NFT]
        public var getNotifications: @Sendable () async throws -> [SharedModels.Notification]

        public init(
            getSavedNFT: @escaping @Sendable () async throws -> [NFT] = { [] },
            getUserInfo: @escaping @Sendable () async throws -> [AboutMeItem] = { [] },
            getCreatedNFT: @escaping @Sendable () async throws -> [NFT] = { [] },
            getLikedNFT: @escaping @Sendable () async throws -> [NFT] = { [] },
            getNotifications: @escaping @Sendable () async throws -> [SharedModels.Notification] = { [] }
        ) {
            self.getSavedNFT = getSavedNFT
            self.getUserInfo = getUserInfo
            self.getCreatedNFT = getCreatedNFT
            self.getLikedNFT = getLikedNFT
            self.getNotifications = getNotifications
        }
    }
}
