//
//  Untitled.swift
//  Main
//
//  Created by Hilal Hakkani on 30/12/2024.
//

import ComposableArchitecture
import HomeFeature
import SharedModels
import Testing
import XCTest

@MainActor
struct HomeReduHowcerTests {

    @Test func test_onAppear_loadsDataSuccessfully() async {
        let store = TestStore(initialState: HomeReducer.State()) {
            HomeReducer()
        } withDependencies: {
            $0.apiClient.home.getCreators = { return Creator.samples() }
            $0.apiClient.home.getNFTS = { return NFTItem.samples() }
        }

        await store.send(\.view.onAppear)

        await store.receive(\.internal.onCreatorsResponse, Creator.samples())

        await store.receive(\.internal.onNFTSResponse, NFTItem.samples())

        await store.receive(\.internal.removePlaceHolder) {
            $0.isLoading = false
        }
    }

    @Test func test_tappedNFT_setsPlayerViewReducerState() async {
        let nftItem = NFTItem.samples().first!
        let store = TestStore(initialState: HomeReducer.State()) {
            HomeReducer()
        } withDependencies: {
            $0.videoPlayer = .noop
        }

        await store.send(\.view.tappedNFT, nftItem) {
            $0.playerViewReducerState = PlayerViewReducer.State(nft: nftItem)
        }
    }

    @Test func test_playerViewAction_stopPlayer() async {
        let store = TestStore(initialState: HomeReducer.State(playerViewReducerState: .init(nft: NFTItem.samples().first!))) {
            HomeReducer()
        } withDependencies: {
            $0.videoPlayer = .noop
        }

        await store.send(\.internal.playerViewAction, .presented(.stopPlayer)) {
            $0.playerViewReducerState = nil
        }
    }

}
