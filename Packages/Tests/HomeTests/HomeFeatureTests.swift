//
//  HomeFeatureTests.swift
//  HomeFeatureTests
//
//  Created by Hilal Hakkani on 10/03/2024.
//

import ComposableArchitecture
import Testing
import HomeFeature
import SharedModels
import Foundation

@MainActor
struct HomeFeatureTests {
    let nfts = [
        NFTItem(
            image: "Image 1",
            name: "Name 1",
            creator: "Creator 1",
            creatorImage: "Dummy",
            price: "Dummy",
            cryptoPrice: "Dummy",
            videoURL: "Dummy"
        ),
        NFTItem(
            image: "Dummy",
            name: "Name 2",
            creator: "Creator 2",
            creatorImage: "Dummy",
            price: "Dummy",
            cryptoPrice: "Dummy",
            videoURL: "Dummy"
        ),
    ]

    let creators = [
        Creator(image: "Image 1", name: "Name 1", price: "price 1"),
        Creator(image: "Image 2", name: "Name 2", price: "price 2"),
    ]

    @Test func onAppear_loadsDataSuccessfully() async {
        let store = TestStore(initialState: HomeFeature.State()) {
            HomeFeature()
        } withDependencies: {
            $0.apiClient.home.getCreators = { self.creators }
            $0.apiClient.home.getNFTS = { self.nfts }
        }

        await store.send(\.view.task)

        await store.receive(\.internal.creatorsResponse) {
            $0.creators = .init(uniqueElements: self.creators)
        }

        await store.receive(\.internal.nftsResponse) {
            $0.nfts = .init(uniqueElements: self.nfts)
            $0.isLoading = false
        }
    }

    @Test func tappedNFT_setsPlayerViewReducerState() async {
        let nftItem = nfts.first!
        let store = TestStore(initialState: HomeFeature.State()) {
            HomeFeature()
        }

        await store.send(\.view.nftTapped, nftItem) {
            $0.playerViewReducerState = PlayerViewReducer.State(nft: nftItem)
        }
    }

    @Test func playerViewAction_stopPlayer() async {
        let store = TestStore(initialState: HomeFeature.State(playerViewReducerState: .init(nft: nfts.first!))) {
            HomeFeature()
        }

        await store.send(\.internal.playerViewAction, .presented(.delegate(.playerClosed))) {
            $0.playerViewReducerState = nil
        }
    }

    @Test func onAppear_loadsDataFailure() async throws {
        let store = TestStore(initialState: HomeFeature.State()) {
            HomeFeature()
        } withDependencies: {
            $0.apiClient.home.getCreators = { throw URLError(.badURL) }
            $0.apiClient.home.getNFTS = { throw URLError(.badURL) }
        }

        await store.send(\.view.task)

        await store.receive(\.internal.creatorsResponse) {
            $0.errorMessage = "Failed to load items"
            $0.isLoading = false
        }
    }
}
