//
//  VideoPlayerView.swift
//  Main
//
//  Created by Hilal Hakkani on 03/12/2024.
//

import AVFoundation
import SwiftUI

#if canImport(UIKit)
import UIKit

struct VideoPlayerView: UIViewRepresentable {
    typealias UIViewType = PlayerUIView

    func makeUIView(context: Context) -> PlayerUIView {
        PlayerUIView(frame: .zero)
    }

    func updateUIView(_ uiView: PlayerUIView, context: Context) {}
}

#elseif canImport(AppKit)
import AppKit

struct VideoPlayerView: NSViewRepresentable {
    typealias NSViewType = PlayerNSView

    func makeNSView(context: Context) -> PlayerNSView {
        PlayerNSView(frame: .zero)
    }

    func updateNSView(_ nsView: PlayerNSView, context: Context) {}
}
#endif
