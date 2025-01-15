//
//  LiveVideoPlayerClient.swift
//  Main
//
//  Created by Hilal Hakkani on 04/12/2024.
//
@preconcurrency import AVFoundation
import ComposableArchitecture

extension VideoPlayerClient {
    static let live =  {
        let player = LockIsolated(AVPlayer())

        return Self(
            setup: { url in
                player.withValue { player in
                    guard let url = URL(string: url) else { return }
                    let newPlayerItem = AVPlayerItem(url: url)
                    player.replaceCurrentItem(with: newPlayerItem)
                }
            },
            play: {
                player.withValue { player in
                    player.play()
                }
            }, pause:  {
                player.withValue { player in
                    player.pause()
                }
            },
            totalDuration: {
                try await player.currentItem?.asset.load(.duration).seconds ?? 0
            },
            seek: { seekTime in
                player.withValue { player in
                    player.seek(to: seekTime)
                }
            }, player: {
                player.value
            } , isPlaying: {
                player.rate == 1
            }, currentTime: {
                player.value.currentTime()
            } , destroy: {
                player.withValue { player in
                    player.pause()
                    player.replaceCurrentItem(with: nil)
                }
            }
        )
    }()

    static public let noop =  {
        return Self(
            setup: { url in

            },
            play: {

            }, pause:  {

            },
            totalDuration: {
                0
            },
            seek: { seekTime in

            }, player: {
                AVPlayer()
            } , isPlaying: {
                false
            }, currentTime: {
                CMTime(seconds: 0, preferredTimescale: 1)
            } , destroy: {

            }
        )
    }()

}
