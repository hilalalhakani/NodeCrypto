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
                image: "Dummy text 1",
                name: "Dummy text 1",
                creator: "Dummy text 1",
                creatorImage: "Dummy text 1",
                price: "Dummy text 1",
                cryptoPrice: "Dummy text 1",
                videoURL: "Dummy text 1"
            ),

            Self(
                image: "Dummy text 2",
                name: "Dummy text 2",
                creator: "Dummy text 2",
                creatorImage: "Dummy text 2",
                price: "Dummy text 2",
                cryptoPrice: "Dummy text 2",
                videoURL: "Dummy text 2"
            ),
        ]
    }
}

public struct Creator: Identifiable, Equatable, Sendable {
    public var id : String {
        image + name + price
    }
    public let image: String
    public let name: String
    public let price: String

    public init(image: String, name: String, price: String) {
        self.image = image
        self.name = name
        self.price = price
    }

    public static func samples() -> [Creator] {
        [
            Self(image: "Dummy text 1", name: "1", price: "Dummy text 2"),
            Self(image: "Dummy text 2", name: "2", price: "Dummy text 2"),
        ]
    }
}
