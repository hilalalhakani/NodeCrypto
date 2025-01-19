import AVKit
import Combine
import Dependencies
import DependenciesMacros
import Foundation

@DependencyClient
struct VideoPlayerClient: Sendable {
    // Core functionality
    var play: @Sendable () async -> Void
    var pause: @Sendable () async -> Void
    var seek: @Sendable (CMTime) async -> Void
    var load: @Sendable (URL) async throws -> Void
    
    // Player access for SwiftUI VideoPlayer
    var player: @Sendable () -> AVPlayer
    
    // Streams for observing player state
    var timeControlStatus: @Sendable () -> AsyncStream<AVPlayer.TimeControlStatus>
    var currentTime: @Sendable () -> AsyncStream<CMTime>
    var duration: @Sendable () -> AsyncStream<CMTime?>
}

// MARK: - Live Implementation
extension VideoPlayerClient: DependencyKey {
    static let liveValue: Self = {
        // Create a single shared AVPlayer instance
        let player = AVPlayer()
        let manager = VideoPlayerManager(player: player)
        
        return Self(
            play: { await manager.play() },
            pause: { await manager.pause() },
            seek: { time in await manager.seek(to: time) },
            load: { url in try await manager.load(url: url) },
            player: { player },
            timeControlStatus: { manager.timeControlStatusStream },
            currentTime: { manager.currentTimeStream },
            duration: { manager.durationStream }
        )
    }()
}

// MARK: - Manager
private actor VideoPlayerManager {
    private let player: AVPlayer
    private var periodicTimeObserver: Any?
    private var statusObservation: NSKeyValueObservation?
    private var itemObservation: NSKeyValueObservation?
    
    private var timeControlStatusContinuation: AsyncStream<AVPlayer.TimeControlStatus>.Continuation?
    private var currentTimeContinuation: AsyncStream<CMTime>.Continuation?
    private var durationContinuation: AsyncStream<CMTime?>.Continuation?
    
    init(player: AVPlayer) {
        self.player = player
        setupObservers()
    }
    
    deinit {
        cleanup()
    }
    
    private func setTimeControlStatusContinuation(_ continuation: AsyncStream<AVPlayer.TimeControlStatus>.Continuation?) {
        timeControlStatusContinuation = continuation
    }
    
    private func setCurrentTimeContinuation(_ continuation: AsyncStream<CMTime>.Continuation?) {
        currentTimeContinuation = continuation
    }
    
    private func setDurationContinuation(_ continuation: AsyncStream<CMTime?>.Continuation?) {
        durationContinuation = continuation
    }
    
    var timeControlStatusStream: AsyncStream<AVPlayer.TimeControlStatus> {
        AsyncStream { continuation in
            Task {
                await self.setTimeControlStatusContinuation(continuation)
                continuation.yield(player.timeControlStatus)
                
                continuation.onTermination = { [weak self] _ in
                    guard let self else { return }
                    Task { await self.setTimeControlStatusContinuation(nil) }
                }
            }
        }
    }
    
    var currentTimeStream: AsyncStream<CMTime> {
        AsyncStream { continuation in
            Task {
                await self.setCurrentTimeContinuation(continuation)
                continuation.yield(player.currentTime())
                
                continuation.onTermination = { [weak self] _ in
                    guard let self else { return }
                    Task { await self.setCurrentTimeContinuation(nil) }
                }
            }
        }
    }
    
    var durationStream: AsyncStream<CMTime?> {
        AsyncStream { continuation in
            Task {
                await self.setDurationContinuation(continuation)
                continuation.yield(player.currentItem?.duration)
                
                continuation.onTermination = { [weak self] _ in
                    guard let self else { return }
                    Task { await self.setDurationContinuation(nil) }
                }
            }
        }
    }
    
    private func setupObservers() {
        Task { @MainActor in
            // Observe player status changes
            statusObservation = player.observe(\.timeControlStatus) { [weak self] player, _ in
                guard let self else { return }
                Task {
                    await self.timeControlStatusContinuation?.yield(player.timeControlStatus)
                }
            }
            
            // Observe current item changes
            itemObservation = player.observe(\.currentItem) { [weak self] player, _ in
                guard let self else { return }
                Task {
                    await self.durationContinuation?.yield(player.currentItem?.duration)
                }
            }
            
            // Setup periodic time observer
            let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
            periodicTimeObserver = player.addPeriodicTimeObserver(
                forInterval: interval,
                queue: .main
            ) { [weak self] time in
                guard let self else { return }
                Task {
                    await self.currentTimeContinuation?.yield(time)
                }
            }
        }
    }
    
    private func cleanup() {
        Task { @MainActor in
            if let periodicTimeObserver {
                player.removeTimeObserver(periodicTimeObserver)
            }
            statusObservation?.invalidate()
            itemObservation?.invalidate()
            
            await timeControlStatusContinuation?.finish()
            await currentTimeContinuation?.finish()
            await durationContinuation?.finish()
            
            await setTimeControlStatusContinuation(nil)
            await setCurrentTimeContinuation(nil)
            await setDurationContinuation(nil)
        }
    }
    
    func play() {
        Task { @MainActor in
            player.play()
        }
    }
    
    func pause() {
        Task { @MainActor in
            player.pause()
        }
    }
    
    func seek(to time: CMTime) {
        Task { @MainActor in
            player.seek(to: time, toleranceBefore: .zero, toleranceAfter: .zero)
        }
    }
    
    func load(url: URL) async throws {
        try await Task { @MainActor in
            let asset = AVAsset(url: url)
            
            // Load essential properties asynchronously
            let properties: [(any AVKeyValueStatus).Type] = [
                AVAsset.StatusLoadingKeys.playable.rawValue,
                AVAsset.StatusLoadingKeys.duration.rawValue
            ]
            
            try await asset.load(properties)
            
            guard asset.isPlayable else {
                throw VideoPlayerError.notPlayable
            }
            
            let item = AVPlayerItem(asset: asset)
            player.replaceCurrentItem(with: item)
        }
    }
}

// MARK: - Dependencies Registration
extension DependencyValues {
    var videoPlayer: VideoPlayerClient {
        get { self[VideoPlayerClient.self] }
        set { self[VideoPlayerClient.self] = newValue }
    }
}

// MARK: - Environment Registration
extension VideoPlayerClient: EnvironmentKey {
    static var defaultValue: VideoPlayerClient {
        @Dependency(\.videoPlayer) var videoPlayer
        return videoPlayer
    }
}

extension EnvironmentValues {
    var videoPlayer: VideoPlayerClient {
        get { self[VideoPlayerClient.self] }
        set { self[VideoPlayerClient.self] = newValue }
    }
}

// MARK: - Errors
enum VideoPlayerError: LocalizedError {
    case notPlayable
    
    var errorDescription: String? {
        switch self {
        case .notPlayable:
            return "The media cannot be played"
        }
    }
}

private extension AVAsset {
    enum StatusLoadingKeys: String {
        case playable
        case duration
    }
} 