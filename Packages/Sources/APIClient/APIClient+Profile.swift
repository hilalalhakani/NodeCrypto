//
//  File.swift
//
//
//  Created by Hilal Hakkani on 09/04/2024.
//

import Dependencies
import Foundation
import SharedModels

extension APIClient {
    public struct Profile: Sendable {
        public var getSavedNFT: @Sendable () async throws -> [NFT]
        public var getUserInfo: @Sendable () async throws -> [AboutMeItem]
        public var getCreatedNFT: @Sendable () async throws -> [NFT]
        public var getLikedNFT: @Sendable () async throws -> [NFT]
        public var getNotifications: @Sendable () async throws -> [SharedModels.Notification]
    }
}

extension APIClient.Profile {
    public static var unimplemented: Self {
        .init(
            getSavedNFT: XCTestDynamicOverlay.unimplemented(
                #"@Dependency(\.apiClient).profile.getSavedNFT"#
            ),
            getUserInfo: XCTestDynamicOverlay.unimplemented(
                #"@Dependency(\.apiClient).profile.getUserInfo"#
            ),
            getCreatedNFT: XCTestDynamicOverlay.unimplemented(
                #"@Dependency(\.apiClient).profile.getCreatedNFT"#
            ),
            getLikedNFT: XCTestDynamicOverlay.unimplemented(
                #"@Dependency(\.apiClient).profile.getLikedNFT"#
            ),
            getNotifications: XCTestDynamicOverlay.unimplemented(
                #"@Dependency(\.apiClient).profile.getNotifications"#
            )
        )
    }

    public static var testValue: Self {
        .unimplemented
    }

    public static func mock() -> Self {
        @Dependency(\.continuousClock) var clock
        let generate = UUIDGenerator.incrementing

        return .init(
            getSavedNFT: {
                try await clock.sleep(for: .seconds(1))
                return [
                    .init(
                        isNew: true,
                        isVideo: false,
                        imageURL: "https://i.ibb.co/f2nHqtY/1.jpg",
                        videoURL: ""
                    ),
                    .init(
                        isNew: false,
                        isVideo: true,
                        imageURL: "https://i.ibb.co/ByyHzXW/2.jpg",
                        videoURL: ""
                    ),
                    .init(
                        isNew: false,
                        isVideo: false,
                        imageURL: "https://i.ibb.co/vkWHdyk/3.jpg",
                        videoURL: ""
                    ),
                    .init(
                        isNew: false,
                        isVideo: false,
                        imageURL: "https://i.ibb.co/ZY1z0Q0/4.jpg",
                        videoURL: ""
                    ),
                    .init(
                        isNew: false,
                        isVideo: false,
                        imageURL: "https://i.ibb.co/3zWjm2F/5.jpg",
                        videoURL: ""
                    ),
                    .init(
                        isNew: false,
                        isVideo: false,
                        imageURL: "https://i.ibb.co/yBwKqWV/6.jpg",
                        videoURL: ""
                    ),
                ]
            },
            getUserInfo: {
                try await clock.sleep(for: .seconds(5))
                return [
                    AboutMeItem(title: "Items", count: "24", iconName: "doc", id: generate()),
                    AboutMeItem(
                        title: "Collection",
                        count: "24",
                        iconName: "magazine",
                        id: generate()
                    ),
                    AboutMeItem(
                        title: "Followers",
                        count: "24",
                        iconName: "person",
                        id: generate()
                    ),
                    AboutMeItem(
                        title: "Following",
                        count: "24",
                        iconName: "person",
                        id: generate()
                    ),
                ]
            },
            getCreatedNFT: {
                try await clock.sleep(for: .seconds(5))
                return [
                    .init(
                        isNew: true,
                        isVideo: false,
                        imageURL: "https://i.ibb.co/f2nHqtY/1.jpg",
                        videoURL: "",
                        isLiked: true
                    ),
                    .init(
                        isNew: true,
                        isVideo: true,
                        imageURL: "https://i.ibb.co/f2nHqtY/1.jpg",
                        videoURL: "",
                        isLiked: false
                    ),
                ]
            },
            getLikedNFT: {
                try await clock.sleep(for: .seconds(5))
                return [
                    .init(
                        isNew: true,
                        isVideo: false,
                        imageURL: "https://i.ibb.co/f2nHqtY/1.jpg",
                        videoURL: "",
                        isLiked: true
                    ),
                    .init(
                        isNew: false,
                        isVideo: true,
                        imageURL: "https://i.ibb.co/f2nHqtY/1.jpg",
                        videoURL: "",
                        isLiked: true
                    ),
                ]
            },
            getNotifications: {
                try await clock.sleep(for: .seconds(5))
                return [
                    .init(
                        senderName: "KidEight",
                        senderImageURLString: "https://picsum.photos/200/300",
                        date: "9 Jul 2021, 11:34 PM"
                    ),
                    .init(
                        senderName: "Rotation ahsdjkashdkjashdjksahdjksahdjkashdkj",
                        senderImageURLString: "https://picsum.photos/200/300",
                        date: "19 Jul 2020, 11:34 PM"
                    ),
                ]
            }
        )
    }
}
