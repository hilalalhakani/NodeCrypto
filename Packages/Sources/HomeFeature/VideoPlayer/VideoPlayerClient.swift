//
//  VideoPlayer.swift
//  Main
//
//  Created by Hilal Hakkani on 04/12/2024.
//

import NodeCryptoCore
import Foundation
import AVFoundation

public struct VideoPlayerClient: Sendable {
    public var setup: @Sendable (String) -> Void
    public var play: @Sendable () -> Void
    public var pause: @Sendable () -> Void
    public var totalDuration: @Sendable () async throws -> Double
    public var seek: @Sendable (CMTime) -> Void
    public var player: @Sendable () -> AVPlayer
    public var isPlaying: @Sendable () -> Bool
    public var currentTime: @Sendable () -> CMTime
    public var destroy: @Sendable () -> Void
}

public enum VideoPlayerKey: DependencyKey {
    public static var liveValue: VideoPlayerClient { .live }
}
extension DependencyValues {
    public var videoPlayer: VideoPlayerClient {
        get { self[VideoPlayerKey.self] }
        set { self[VideoPlayerKey.self] = newValue }
    }
}
