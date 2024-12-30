//
//  APIClient+Home.swift
//  Main
//
//  Created by Hilal Hakkani on 12/12/2024.
//

import Foundation
import Dependencies
import Foundation
import SharedModels

extension APIClient {
    public struct Home: Sendable {
        public var getCreators: @Sendable () async throws -> [Creator]
        public var getNFTS: @Sendable () async throws -> [NFTItem]
    }
}

extension APIClient.Home {
    public static var unimplemented: Self {
        .init(
            getCreators: XCTestDynamicOverlay.unimplemented(
                #"@Dependency(\.apiClient).home.getCreators"#
            ) , getNFTS:  XCTestDynamicOverlay.unimplemented(
                #"@Dependency(\.apiClient).home.getNFTS"#
            )
        )
    }

    public static var testValue: Self {
        .unimplemented
    }

    public static func mock() -> Self {
        @Dependency(\.continuousClock) var clock
        let generate = UUIDGenerator.incrementing

        return .init {
            try await clock.sleep(for: .seconds(1))
            return [
                .init(
                    image: "https://dummyimage.com/600x400/000/fff",
                    name: "Creator 1",
                    price: "225$"
                ),
                .init(
                    image: "https://dummyimage.com/600x400/000/fff",
                    name: "Creator 2",
                    price: "225$"
                ),
                .init(
                    image: "https://dummyimage.com/600x400/000/fff",
                    name: "Creator 3",
                    price: "222$"
                ),
                .init(
                    image: "https://dummyimage.com/600x400/000/fff",
                    name: "Creator 4",
                    price: "215$"
                ),
                .init(
                    image: "https://dummyimage.com/600x400/000/fff",
                    name: "Creator 5",
                    price: "111$"
                ),
            ]
        } getNFTS: {
            try await clock.sleep(for: .seconds(1))
            return [
                .init(
                    image: "https://i.ibb.co/7R31jGw/feature-work.jpg",
                    name: "Element 1",
                    creator: "Creator 1",
                    creatorImage: "https://i.ibb.co/7R31jGw/feature-work.jpg",
                    price: "1$",
                    cryptoPrice: "5 Eth",
                    videoURL: "https://flipfit-cdn.akamaized.net/flip_hls/6656423247ffe600199e8363-15125d/video_h1.m3u8"
                ),
                .init(
                    image: "https://i.ibb.co/7R31jGw/feature-work.jpg",
                    name: "Element 2",
                    creator: "Creator 2",
                    creatorImage: "https://i.ibb.co/7R31jGw/feature-work.jpg",
                    price: "2$",
                    cryptoPrice: "1 Eth",
                    videoURL: "http://content.jwplatform.com/manifests/vM7nH0Kl.m3u8"

                ),
            ]
        }

    }
}
