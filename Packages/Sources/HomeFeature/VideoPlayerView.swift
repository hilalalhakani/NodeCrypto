//
//  VideoPlayerView.swift
//  Main
//
//  Created by Hilal Hakkani on 03/12/2024.
//

import UIKit
import SwiftUI
import AVFoundation

struct VideoPlayerView: UIViewRepresentable {
    typealias UIViewType = PlayerUIView

    func makeUIView(context: Context) -> PlayerUIView {
        let player = PlayerUIView(frame: .zero)
        return player
    }

    func updateUIView(_ uiView: PlayerUIView, context: Context) {}
}
