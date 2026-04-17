//
//  HomeTests.swift
//  Main
//
//  Created by Hilal Hakkani on 21/06/2025.
//

import ComposableArchitecture
import DependenciesTestSupport
import Foundation
import HomeFeature
import SharedModels
import SnapshotTesting
import SwiftUI
import Testing
import UIKit

@Suite(.dependencies {
    $0.defaultInMemoryStorage = .init()
    $0.apiClient.home.getNFTS = { [] }
    $0.apiClient.home.getCreators = { [] }
})
@MainActor
struct HomeSnapshotsTests {

    @Test func test_initialLoadingState() throws {
        let store = Store(initialState: HomeFeature.State()) {
            HomeFeature()
        }
        let view = HomeView(store: store)
        try assert(view)
    }

    @Test func test_loadedState() async throws {
        let nfts: [NFTItem] = [.mock1, .mock2]
        let creators: [Creator] = [.mock1, .mock2]

        let store = Store(
            initialState: HomeFeature.State(creators: creators, isLoading: false, nfts: nfts)
        ) {
            HomeFeature()
        } withDependencies: {
            $0.apiClient.home.getNFTS = { nfts }
            $0.apiClient.home.getCreators = { creators }
        }

        store.send(.view(.task))

        let view = HomeView(store: store)
        try assert(view)
    }

    @Test func test_loadedState_french() async throws {
        let nfts: [NFTItem] = [.mock1]
        let creators: [Creator] = [.mock1]

        let store = Store(
            initialState: HomeFeature.State(creators: creators, isLoading: false, nfts: nfts)
        ) {
            HomeFeature()
        } withDependencies: {
            $0.apiClient.home.getNFTS = { nfts }
            $0.apiClient.home.getCreators = { creators }
        }

        let view = HomeView(store: store)
            .environment(\.locale, Locale(identifier: "fr"))
        try assert(view, named: "test_loadedState_fr")
    }
}
