//
//  APIClient+Home.swift
//  Main
//
//  Created by Hilal Hakkani on 19/10/2025.
//

import APIClient
import Dependencies

extension APIClient.Home {
    public static func mock() -> Self {
        @Dependency(\.continuousClock) var clock
        return .init {
            try await clock.sleep(for: .seconds(5))
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
        } _: {
            try await clock.sleep(for: .seconds(5))
            return [
                .init(
                    image: "https://i.ibb.co/7R31jGw/feature-work.jpg",
                    name: "Element 1",
                    creator: "Creator 1",
                    creatorImage: "https://i.ibb.co/7R31jGw/feature-work.jpg",
                    price: "1$",
                    cryptoPrice: "5 Eth",
                    videoURL:
                        "https://flipfit-cdn.akamaized.net/flip_hls/6656423247ffe600199e8363-15125d/video_h1.m3u8"
                ),
                .init(
                    image: "https://i.ibb.co/7R31jGw/feature-work.jpg",
                    name: "Element 2",
                    creator: "Creator 2",
                    creatorImage: "https://i.ibb.co/7R31jGw/feature-work.jpg",
                    price: "2$",
                    cryptoPrice: "1 Eth",
                    videoURL:
                        "http://content.jwplatform.com/manifests/vM7nH0Kl.m3u8"

                ),
            ]
        }

    }

}
