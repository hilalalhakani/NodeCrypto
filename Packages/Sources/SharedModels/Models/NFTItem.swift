//
//  NFTItem.swift
//  Main
//
//  Created by Hilal Hakkani on 12/12/2024.
//
import Foundation

public struct NFTItem: Identifiable, Equatable, Sendable {
    public var id : String {
        image + name + price
    }
    public let image: String
    public let name: String
    public let creator: String
    public let creatorImage: String
    public let price: String
    public let cryptoPrice: String
    public let videoURL: String

    public init(
        image: String,
        name: String,
        creator: String,
        creatorImage: String,
        price: String,
        cryptoPrice: String,
        videoURL: String
    ) {
        self.image = image
        self.name = name
        self.creator = creator
        self.creatorImage = creatorImage
        self.price = price
        self.cryptoPrice = cryptoPrice
        self.videoURL = videoURL
    }

    public static func samples() -> [NFTItem] {
        [
            Self(
                image: "https://dummyimage.com/600x400/000/fff",
                name: "Dummy text 1",
                creator: "Dummy text 1",
                creatorImage: "https://dummyimage.com/600x400/000/fff",
                price: "Dummy text 1",
                cryptoPrice: "Dummy text 1",
                videoURL: "Dummy text 1"
            ),

            Self(
                image: "https://dummyimage.com/600x400/000/fff",
                name: "Dummy text 2",
                creator: "Dummy text 2",
                creatorImage: "https://dummyimage.com/600x400/000/fff",
                price: "Dummy text 2",
                cryptoPrice: "Dummy text 2",
                videoURL: "Dummy text 2"
            ),
        ]
    }
}

public struct Creator: Identifiable, Equatable, Sendable, Hashable {
    public var id : String {
        image + name + price
    }
    public let image: String
    public let name: String
    public let price: String
    public let isFollowing: Bool

    public init(image: String, name: String, price: String, isFollowing: Bool = true) {
        self.image = image
        self.name = name
        self.price = price
        self.isFollowing = isFollowing
    }

    public static func samples() -> [Creator] {
        [
            Self(image: "https://dummyimage.com/600x400/000/fff", name: "1", price: "Dummy text 2", isFollowing: true),
            Self(image: "https://dummyimage.com/600x400/000/fff", name: "2", price: "Dummy text 2", isFollowing: false)
        ]
    }
}
