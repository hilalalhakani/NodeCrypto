//
//  SearchFeatureTests.swift
//  Main
//
//  Created by Hilal Hakkani on 22/03/2025.
//

import ComposableArchitecture
import DependenciesTestSupport
import Foundation
import SearchFeature
import SharedModels
import SnapshotTesting
import SwiftUI
import Testing

#if os(iOS)
@Suite(.dependencies {
    $0.defaultInMemoryStorage = .init()
})
@MainActor
struct SearchSnapshotsTests {

    @Test
    func testInitialStateWithSearchHistory() throws {
        let store: StoreOf<SearchFeatureReducer> = .init(
            initialState: SearchFeatureReducer.State(
                searchHistory: ["Ethereum", "NFT", "DeFi"]
            )
        ) {
            SearchFeatureReducer()
        }

        let searchView = SearchView(store: store)
        try assert(searchView)
    }

    @Test
    func testSearchingStateWithNoResults() throws {
        let store: StoreOf<SearchFeatureReducer> = .init(
            initialState: SearchFeatureReducer.State(
                searchBar: .init(searchText: "Bitcoin"),
                searchHistory: ["Ethereum", "NFT", "DeFi", "Web3"],
                isSearching: true,
                searchResults: []
            )
        ) {
            SearchFeatureReducer()
        }

        let searchView = SearchView(store: store)
        try assert(searchView)
    }

    @Test
    func testSearchingStateWithResults() throws {
        let store: StoreOf<SearchFeatureReducer> = .init(
            initialState: SearchFeatureReducer.State(
                searchBar: .init(searchText: "Bitcoin"),
                searchHistory: ["Ethereum", "NFT", "DeFi", "Web3"],
                isSearching: true,
                searchResults: .init(uniqueElements: [.mockImage, .mockVideo])
            )
        ) {
            SearchFeatureReducer()
        }

        let searchView = SearchView(store: store)
        try assert(searchView)
    }

    @Test
    func testInitialStateWithSearchHistory_french() throws {
        let store: StoreOf<SearchFeatureReducer> = .init(
            initialState: SearchFeatureReducer.State(
                searchHistory: ["Ethereum", "NFT", "DeFi"]
            )
        ) {
            SearchFeatureReducer()
        }

        let searchView = SearchView(store: store)
            .environment(\.locale, Locale(identifier: "fr"))

        try assert(searchView, named: "testInitialStateWithSearchHistory_fr")
    }
}
#endif
