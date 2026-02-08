//
//  APIClient+Profile.swift
//  Main
//
//  Created by Hilal Hakkani on 19/10/2025.
//

import Dependencies
import APIClient
import Foundation

extension APIClient.Profile {
    public static func mock() -> Self {
        let generate = UUIDGenerator.incrementing
        return .init(
            getSavedNFT: {
                try await APIClient.mimic([
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
                ])
            },
            getUserInfo: {
                try await APIClient.mimic([
                    AboutMeItem(
                        title: "Items",
                        count: "24",
                        iconName: "doc",
                        id: generate()
                    ),
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
                    )
                ])
            },
            getCreatedNFT: {
                try await APIClient.mimic([
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
                ])
            },
            getLikedNFT: {
                try await APIClient.mimic([
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
                ])
            },
            getNotifications: {
                try await APIClient.mimic([
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
                ])
            }
        )
    }
}
