//
//  PlayerViewSnapshotsTests.swift
//
//
//  Created by Hilal Hakkani on 03/08/2024.
//

import ComposableArchitecture
import DependenciesTestSupport
import Foundation
import HomeFeature
import SharedModels
import SnapshotTesting
import SwiftUI
import Testing

#if os(iOS)
@Suite(.dependencies {
    $0.videoPlayer.load = { _ in }
    $0.videoPlayer.play = { }
    $0.videoPlayer.pause = { }
    $0.videoPlayer.setVolume = { _ in }
    $0.videoPlayer.isPlaying = { true }
    $0.videoPlayer.destroy = { }
})
@MainActor
struct PlayerViewSnapshotsTests {
    let nft = NFTItem(
        image: "Dummy",
        name: "Test Name",
        creator: "Test Creator",
        creatorImage: "Dummy",
        price: "$10.00",
        cryptoPrice: "10 ETH",
        videoURL: "Dummy"
    )

    @Test
    func testPlayerView_controlsVisible() throws {
        let store = StoreOf<PlayerViewReducer>(
            initialState: .init(
                isPlaying: true,
                areControlsHidden: false,
                nft: nft
            ),
            reducer: { PlayerViewReducer() }
        )

        let view = PlayerView(store: store)
        try assert(view)
    }

    @Test
    func testPlayerView_controlsHidden() throws {
        let store = StoreOf<PlayerViewReducer>(
            initialState: .init(
                isPlaying: true,
                areControlsHidden: true,
                nft: nft
            ),
            reducer: { PlayerViewReducer() }
        )

        let view = PlayerView(store: store)
        try assert(view)
    }

    @Test
    func testPlayerView_paused() throws {
        let store = StoreOf<PlayerViewReducer>(
            initialState: .init(
                isPlaying: false,
                areControlsHidden: false,
                nft: nft
            ),
            reducer: { PlayerViewReducer() }
        )

        let view = PlayerView(store: store)
        try assert(view)
    }
}
#endif
