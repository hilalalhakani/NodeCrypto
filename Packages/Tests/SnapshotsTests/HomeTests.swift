//
//  HomeTests.swift
//  Main
//
//  Created by Hilal Hakkani on 21/06/2025.
//

import ComposableArchitecture
import Foundation
import HomeFeature
import SharedModels
import SnapshotTesting
import SwiftUI
import Testing
import UIKit

@MainActor
struct HomeSnapshotsTests {
    @Test func test_initialLoadingState() throws {
        let store = Store(initialState: HomeReducer.State()) {
            HomeReducer()
        } //withDependencies: {
//            $0.apiClient.home.getNFTS = { try await Task.never() }
//            $0.apiClient.home.getCreators = { try await Task.never() }
       // }

        let view = HomeView(store: store)
        try assert(view)
    }

    @Test func test_receivedResponse() async throws {
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

        let store = Store(
            initialState: HomeReducer.State(nfts: nfts, creators: creators, isLoading: false)
        ) {
            HomeReducer()
        } withDependencies: {
            $0.apiClient.home.getNFTS = { nfts }
            $0.apiClient.home.getCreators = { creators }

        }

        store.send(.view(.onAppear))

        let view = HomeView(store: store)

        try assert(view)
    }
}
