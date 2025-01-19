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
            load: { try await manager.load(url: $0) },
            player: { manager.player },
            timeControlStatus: { manager.timeControlStatusStream },
            currentTime: { manager.currentTimeStream },
            duration: { manager.durationStream },
            isPlaying : { manager.isPlaying() },
            destroy: { manager.cleanup() },
            setupObservers: { manager.setupObservers() }
        )
    }()
}

private actor VideoPlayerManager {
    nonisolated(unsafe) var player: AVPlayer = .init()
    nonisolated(unsafe) private var periodicTimeObserver: Any?
    nonisolated(unsafe) private var statusObservation: NSKeyValueObservation?
    nonisolated(unsafe) private var durationObservation: NSKeyValueObservation?

    nonisolated(unsafe) private var timeControlStatusContinuation: AsyncStream<AVPlayer.TimeControlStatus>.Continuation?
    nonisolated(unsafe) private var currentTimeContinuation: AsyncStream<CMTime>.Continuation?
    nonisolated(unsafe) private var durationContinuation: AsyncStream<CMTime>.Continuation?

    nonisolated var timeControlStatusStream: AsyncStream<AVPlayer.TimeControlStatus> {
        AsyncStream { [player] continuation in
            self.timeControlStatusContinuation = continuation
            continuation.yield(player.timeControlStatus)

            continuation.onTermination = { [weak self] _ in
                guard let self else { return }
                self.timeControlStatusContinuation = nil
            }
        }
    }

    nonisolated func isPlaying() -> Bool {
        player.rate != 0
    }

    nonisolated var currentTimeStream: AsyncStream<CMTime> {
        AsyncStream { continuation in
            self.currentTimeContinuation = continuation

            continuation.onTermination = { [weak self] _ in
                guard let self else { return }
                self.currentTimeContinuation = nil
            }
        }
    }

    nonisolated var durationStream: AsyncStream<CMTime> {
        AsyncStream { continuation in
            self.durationContinuation = continuation

            continuation.onTermination = { [weak self] _ in
                guard let self else { return }
                self.durationContinuation = nil
            }
        }
    }

    nonisolated func setupObservers() {
        statusObservation = player.observe(\.timeControlStatus) { [weak self] player, _ in
            guard let self else { return }
            self.timeControlStatusContinuation?.yield(player.timeControlStatus)
        }

        durationObservation = player.observe(\.status) { [weak self] player, _ in
            guard let self, let currentItem = player.currentItem, player.status == .readyToPlay else { return }
            Task {
                let duration = try await currentItem.asset.load(.duration)
                self.durationContinuation?.yield(duration)
            }
        }

        let interval = CMTime(seconds: 0.2, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        periodicTimeObserver = player.addPeriodicTimeObserver(forInterval: interval, queue: .global()) { [weak self] time in
            guard let self else { return }
            self.currentTimeContinuation?.yield(time)
        }
    }

    nonisolated func cleanup() {
        if let periodicTimeObserver {
            player.removeTimeObserver(periodicTimeObserver)
        }
        statusObservation?.invalidate()
        durationObservation?.invalidate()

        timeControlStatusContinuation?.finish()
        currentTimeContinuation?.finish()
        durationContinuation?.finish()

        self.timeControlStatusContinuation = nil
        self.currentTimeContinuation = nil
        self.timeControlStatusContinuation = nil
        self.player.pause()
        self.player.replaceCurrentItem(with: nil)
        self.player = .init()
    }

    @MainActor
    func totalDuration() async throws -> Double {
        try await player.currentItem?.asset.load(.duration).seconds ?? 0
    }

    @MainActor
    func play() {
        player.play()
    }

    @MainActor
    func pause() {
        player.pause()
    }
    
    @MainActor
    func seek(to time: CMTime) {
        player.seek(to: time, toleranceBefore: .zero, toleranceAfter: .zero)
    }

    @MainActor
    func load(url: String) async throws {
        guard let url = URL(string: url) else { return }
        let asset = AVAsset(url: url)
        let item = AVPlayerItem(asset: asset)
        player.replaceCurrentItem(with: item)
        player.play()
    }
}
