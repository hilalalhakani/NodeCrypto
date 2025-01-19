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
    public var play: @Sendable () async -> Void
    public var pause: @Sendable () async -> Void
    public var seek: @Sendable (CMTime) async -> Void
    public var load: @Sendable (String) async throws -> Void
    public var player: @Sendable () async -> AVPlayer
    var timeControlStatus: @Sendable () async -> AsyncStream<AVPlayer.TimeControlStatus>
    var currentTime: @Sendable () async -> AsyncStream<CMTime>
    var duration: @Sendable () async -> AsyncStream<CMTime>
    var isPlaying: @Sendable () -> Bool
    var destroy: @Sendable () -> Void
    var setupObservers: @Sendable () -> Void
}

public enum VideoPlayerKey: DependencyKey {
    public static var liveValue: VideoPlayerClient { .liveValue }
}
extension DependencyValues {
    public var videoPlayer: VideoPlayerClient {
        get { self[VideoPlayerKey.self] }
        set { self[VideoPlayerKey.self] = newValue }
    }
}
