//
//  VideoPlayer.swift
//  Main
//
//  Created by Hilal Hakkani on 04/12/2024.
//

import NodeCryptoCore
import Foundation
import AVFoundation

@DependencyClient
public struct VideoPlayerClient: Sendable {
    public var play: @Sendable () -> Void = {   }
    public var pause: @Sendable () -> Void = {   }
    public var seek: @Sendable (CMTime) -> Void = { _ in   }
    public var load: @Sendable (String) -> Void = { _ in   }
    public var player: @Sendable () -> AVPlayer = { AVPlayer() }
    public var timeControlStatus: @Sendable () async -> AsyncStream<AVPlayer.TimeControlStatus> = { .init(unfolding: { nil }) }
    public var currentTime: @Sendable () async -> AsyncStream<CMTime> = { .init(unfolding: { nil }) }
    public var duration: @Sendable () async -> AsyncStream<CMTime> = { .init(unfolding: { nil }) }
    public  var isPlaying: @Sendable () -> Bool = { false }
    public var destroy: @Sendable () -> Void = {  }
    public var setVolume: @Sendable (Float) -> Void = { _ in }
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
