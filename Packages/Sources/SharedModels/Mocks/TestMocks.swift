//
//  TestMocks.swift
//
//
//  Created by Hilal Hakkani on 17/04/2026.
//

import Foundation

// MARK: - NFT Mocks

extension NFT {
    public static let mockImage = NFT(
        isNew: true,
        isVideo: false,
        imageURL: "app://placeholder",
        videoURL: "",
        isLiked: true
    )

    public static let mockVideo = NFT(
        isNew: false,
        isVideo: true,
        imageURL: "app://placeholder",
        videoURL: "",
        isLiked: false
    )
}

// MARK: - NFTItem Mocks

extension NFTItem {
    public static let mock1 = NFTItem(
        image: "Image 1",
        name: "Cosmic Voyager #1",
        creator: "Artist Alpha",
        creatorImage: "app://creator-1",
        price: "2.5",
        cryptoPrice: "2.5 ETH",
        videoURL: ""
    )

    public static let mock2 = NFTItem(
        image: "Image 2",
        name: "Digital Sunset #42",
        creator: "Creator Beta",
        creatorImage: "app://creator-2",
        price: "1.0",
        cryptoPrice: "1.0 ETH",
        videoURL: "https://example.com/video.mp4"
    )
}

// MARK: - Creator Mocks

extension Creator {
    public static let mock1 = Creator(
        image: "app://creator-1",
        name: "Artist Alpha",
        price: "2.5 ETH",
        isFollowing: true
    )

    public static let mock2 = Creator(
        image: "app://creator-2",
        name: "Creator Beta",
        price: "1.0 ETH",
        isFollowing: false
    )
}

// MARK: - AboutMeItem Mocks

extension AboutMeItem {
    public static let mockItems = AboutMeItem(
        title: "Items",
        count: "24",
        iconName: "doc",
        id: UUID()
    )

    public static let mockCollection = AboutMeItem(
        title: "Collection",
        count: "24",
        iconName: "magazine",
        id: UUID()
    )

    public static let mockFollowers = AboutMeItem(
        title: "Followers",
        count: "24",
        iconName: "person",
        id: UUID()
    )
}

// MARK: - Notification Mocks

extension Notification {
    public static let mock1 = Notification(
        senderName: "KidEight",
        senderImageURLString: "app://placeholder",
        date: "9 Jul 2021, 11:34 PM"
    )

    public static let mock2 = Notification(
        senderName: "Rotation",
        senderImageURLString: "app://placeholder",
        date: "19 Jul 2020, 11:34 PM"
    )
}
