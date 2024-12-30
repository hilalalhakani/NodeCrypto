//
//  VideoPlayer.swift
//  Main
//
//  Created by Hilal Hakkani on 04/12/2024.
//

import NodeCryptoCore
import Foundation
import AVFoundation

struct VideoPlayerClient {
    var setup: @Sendable (String) -> Void
    var play: @Sendable () -> Void
    var pause: @Sendable () -> Void
    var totalDuration: @Sendable () async throws -> Double
    var seek: @Sendable (CMTime) -> Void
    var player: @Sendable () -> AVPlayer
    var isPlaying: @Sendable () -> Bool
    var currentTime: @Sendable () -> CMTime
    var destroy: @Sendable () -> Void
}

private enum VideoPlayerKey: DependencyKey {
    public static var liveValue: VideoPlayerClient { .live }
}
extension DependencyValues {
    var videoPlayer: VideoPlayerClient {
        get { self[VideoPlayerKey.self] }
        set { self[VideoPlayerKey.self] = newValue }
    }
}
