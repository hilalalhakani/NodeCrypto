//
//  SearchFeature.swift
//  Main
//
//  Created by Hilal Hakkani on 22/03/2025.
//

import ComposableArchitecture
import Foundation
import SearchFeature
import SharedModels
import SnapshotTesting
import Testing
import SwiftUI

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
                searchResults: .init(uniqueElements: [
                    NFT(
                        isNew: true,
                        isVideo: false,
                        imageURL: "https://i.ibb.co/f2nHqtY/1.jpg",
                        videoURL: ""
                    ),
                    NFT(
                        isNew: false,
                        isVideo: true,
                        imageURL: "https://i.ibb.co/ByyHzXW/2.jpg",
                        videoURL: ""
                    ),
                ])
            )
        ) {
            SearchFeatureReducer()
        }

        let searchView = SearchView(store: store)

        try assert(searchView)
    }
}
