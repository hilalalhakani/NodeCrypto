@preconcurrency import AVKit
import Combine
import Dependencies
import DependenciesMacros
import Foundation
import SwiftUICore

extension VideoPlayerClient: DependencyKey {
    public static let liveValue: Self = {
        let manager = VideoPlayerManager()
        return Self(
            play: { manager.play()  },
            pause: { manager.pause() },
            seek: { manager.seek(to: $0) },
            load: { manager.load(url: $0) },
            player: { manager.player },
            timeControlStatus: { manager.timeControlStatusStream },
            currentTime: { manager.currentTimeStream },
            duration: { manager.durationStream },
            isPlaying : { manager.isPlaying() },
            destroy: { manager.cleanup() }
        )
    }()

    public static let noop: Self = {
        return Self(
            play: {   },
            pause: { },
            seek: { _ in   },
            load: { _ in   },
            player: { AVPlayer() },
            timeControlStatus: { .init(unfolding: { nil }) },
            currentTime: { .init(unfolding: { nil }) },
            duration: { .init(unfolding: { nil }) },
            isPlaying : { false },
            destroy: {   }
        )
    }()
}

private actor VideoPlayerManager {
    nonisolated(unsafe) private(set) var player: AVPlayer = .init()
    
    private final class TimeObserverToken: @unchecked Sendable {
        let token: Any
        init(token: Any) { self.token = token }
    }

    nonisolated var timeControlStatusStream: AsyncStream<AVPlayer.TimeControlStatus> {
        AsyncStream { [player] continuation in
            continuation.yield(player.timeControlStatus)
            let observation = player.observe(\.timeControlStatus) { player, _ in
                continuation.yield(player.timeControlStatus)
            }
            continuation.onTermination = { _ in
                observation.invalidate()
            }
        }
    }

    nonisolated var currentTimeStream: AsyncStream<CMTime> {
        AsyncStream { continuation in
            let interval = CMTime(seconds: 0.2, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
            let rawToken = player.addPeriodicTimeObserver(forInterval: interval, queue: .global()) { time in
                continuation.yield(time)
            }
            let token = TimeObserverToken(token: rawToken)
            continuation.onTermination = { [player] _ in
                player.removeTimeObserver(token.token)
            }
        }
    }

    nonisolated var durationStream: AsyncStream<CMTime> {
        AsyncStream { continuation in
            let observation = player.observe(\.status) { player, _ in
                if let currentItem = player.currentItem, player.status == .readyToPlay {
                    Task {
                        let duration = try await currentItem.asset.load(.duration)
                        continuation.yield(duration)
                    }
                }
            }
            continuation.onTermination = { _ in
                observation.invalidate()
            }
        }
    }

    nonisolated func isPlaying() -> Bool {
        player.rate != 0
    }

    nonisolated func cleanup() {
        player.pause()
        player.replaceCurrentItem(with: nil)
        player = .init()
    }

    @MainActor
    func totalDuration() async throws -> Double {
        try await player.currentItem?.asset.load(.duration).seconds ?? 0
    }

    nonisolated func play() {
        player.play()
    }

    nonisolated func pause() {
        player.pause()
    }
    
    nonisolated func seek(to time: CMTime) {
        player.seek(to: time, toleranceBefore: .zero, toleranceAfter: .zero)
    }

    nonisolated func load(url: String) {
        guard let url = URL(string: url) else { return }
        Task { @MainActor in
            let asset = AVAsset(url: url)
            let item = AVPlayerItem(asset: asset)
            player.replaceCurrentItem(with: item)
            player.play()
        }
    }
}
