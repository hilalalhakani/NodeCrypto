//
//  PlayerUIView.swift
//  Main
//
//  Created by Hilal Hakkani on 03/12/2024.
//

import AVFoundation
import Dependencies

#if canImport(UIKit)
import UIKit

class PlayerUIView: UIView {
    override static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }

    private var playerLayer: AVPlayerLayer {
        return self.layer as! AVPlayerLayer
    }

    @Dependency(\.videoPlayer) var videoPlayer

    override init(frame: CGRect) {
        super.init(frame: frame)
        initializePlayer()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initializePlayer() {
        playerLayer.player = videoPlayer.player()
        playerLayer.videoGravity = .resize
        playerLayer.player?.play()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = self.bounds
    }
}

#elseif canImport(AppKit)
import AppKit

class PlayerNSView: NSView {
    private let playerLayer = AVPlayerLayer()

    @Dependency(\.videoPlayer) var videoPlayer

    override init(frame: CGRect) {
        super.init(frame: frame)
        wantsLayer = true
        layer = playerLayer
        initializePlayer()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initializePlayer() {
        playerLayer.player = videoPlayer.player()
        playerLayer.videoGravity = .resize
        playerLayer.player?.play()
    }

    override func layout() {
        super.layout()
        playerLayer.frame = self.bounds
    }
}
#endif
