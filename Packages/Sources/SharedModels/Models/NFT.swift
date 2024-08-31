//
//  File.swift
//  
//
//  Created by Hilal Hakkani on 09/04/2024.
//

import Foundation

public struct NFT: Decodable, Equatable, Hashable {
    public var isNew: Bool
    public var isVideo: Bool
    public var imageURL: String
    public var videoURL: String
    public var isLiked: Bool

    public init(isNew: Bool, isVideo: Bool, imageURL: String, videoURL: String, isLiked: Bool = true) {
        self.isNew = isNew
        self.isVideo = isVideo
        self.imageURL = imageURL
        self.videoURL = videoURL
        self.isLiked = isLiked
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(imageURL)
        hasher.combine(isNew)
        hasher.combine(isVideo)
        hasher.combine(videoURL)
        hasher.combine(isLiked)
    }
}

extension NFT: Identifiable {
    public var id: Int {
        self.hashValue
    }
}
