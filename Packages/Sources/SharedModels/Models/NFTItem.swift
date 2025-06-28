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
}
