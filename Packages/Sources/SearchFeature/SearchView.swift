//
//  SearchView.swift
//  Main
//
//  Created by Hilal Hakkani on 23/02/2025.
//

import ComposableArchitecture
import NodeCryptoCore
import SwiftUI

@Reducer
public struct SearchReducer {
    public init() {}

    public enum SearchDestination: Equatable, Sendable {
        case bestArtist
        case recentUploaded
        case videos
        case modeling
    }

    @ObservableState
    public struct State: Equatable, Sendable {
        var searchBar: SearchBarReducer.State = .init()
        var searchResults: [String] = []
        var searchHistory: [String] = []
        var isSearching: Bool = false
        var selectedDestination: SearchDestination? = nil

        public init(
            searchBar: SearchBarReducer.State = .init(),
            searchResults: [String] = [],
            searchHistory: [String] = [],
            isSearching: Bool = false
        ) {
            self.searchBar = searchBar
            self.searchResults = searchResults
            self.searchHistory = searchHistory
            self.isSearching = isSearching
        }
    }

    public enum Action: Sendable {
        case searchBar(SearchBarReducer.Action)
        case searchResultTapped(String)
        case historyItemTapped(String)
        case destinationSelected(SearchDestination)
        case clearSearchHistory
    }

    public var body: some ReducerOf<Self> {
        Scope(state: \.searchBar, action: \.searchBar) {
            SearchBarReducer()
        }

        Reduce { state, action in
            switch action {
            case .searchBar(_ ):
                // Update search results based on search text
                state.isSearching = !state.searchBar.searchText.isEmpty
                // You would typically perform a search here and update searchResults
                return .none

            case .searchResultTapped(let result):
                // Add to search history if not already present
                if !state.searchHistory.contains(result) {
                    state.searchHistory.insert(result, at: 0)
                    // Optionally limit history size
                    if state.searchHistory.count > 10 {
                        state.searchHistory.removeLast()
                    }
                }
                return .none

            case .historyItemTapped(let item):
                state.searchBar.searchText = item
                state.isSearching = true
                return .none

            case .destinationSelected(let destination):
                state.selectedDestination = destination
                return .none

            case .clearSearchHistory:
                state.searchHistory = []
                return .none
            }
        }
    }
}

public struct SearchView: View {
    @Bindable var store: StoreOf<SearchReducer>

    public init(store: StoreOf<SearchReducer>) {
        self.store = store
    }

    public var body: some View {
        VStack(spacing: 32) {
            SearchBar(
                store: store.scope(
                    state: \.searchBar,
                    action: \.searchBar
                )
            )
            .padding(.horizontal, 25)

            if store.isSearching {
                searchResultsList
                    .transition(.opacity)
            } else {
                suggestionsForm
            }
        }
        .ignoresSafeArea(.keyboard)
    }

    private var searchResultsList: some View {
        List {
            ForEach(0..<5) { _ in
                Button {
                    store.send(.searchResultTapped(store.searchBar.searchText))
                } label: {
                    HStack {
                        Image(systemName: "tag.fill")
                            .foregroundColor(.blue)
                        Text("#" + store.searchBar.searchText)
                            .font(.headline)
                        Spacer()
                        Text("256 posts")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .listStyle(.plain)
    }

    private var suggestionsForm: some View {
        Form {
            suggestionsSection
            searchHistorySection
        }
//        .navigationDestination(
//            unwrapping: store.selectedDestination,
//            destination: { $destination in
//                switch destination {
//                case .bestArtist:
//                    Text("Best Artist View")
//                case .recentUploaded:
//                    Text("Recent Uploaded View")
//                case .videos:
//                    Text("Videos View")
//                case .modeling:
//                    Text("3D Modeling View")
//                }
//            }
//        )
        .scrollContentBackground(.hidden)
    }

    private var suggestionsSection: some View {
        Section("Suggestions") {
            suggestionLink(
                .bestArtist,
                icon: "star.fill",
                color: .yellow,
                title: "Best artist",
                subtitle: "Top 50 artist of the month"
            )

            suggestionLink(
                .recentUploaded,
                icon: "square.and.arrow.up.fill",
                color: .green,
                title: "Recent uploaded",
                subtitle: "Top 50 artist of the month"
            )

            suggestionLink(
                .videos,
                icon: "play.circle.fill",
                color: .red,
                title: "Videos",
                subtitle: "Top 50 artist of the month")
        }
    }

    private var searchHistorySection: some View {
        Section("Search history") {
            suggestionLink(
                .modeling,
                icon: "cube.fill",
                color: .gray,
                title: "3D modeling",
                subtitle: "256 results"
            )

            suggestionLink(
                .videos,
                icon: "play.circle.fill",
                color: .gray,
                title: "Videos",
                subtitle: "Top 50 artist of the month"
            )

            if !store.searchHistory.isEmpty {
                Button("Clear History") {
                    store.send(.clearSearchHistory)
                }
                .foregroundColor(.red)
            }
        }
    }

    private func suggestionLink(
        _ destination: SearchReducer.SearchDestination,
        icon: String,
        color: Color,
        title: String,
        subtitle: String
    ) -> some View {
        Button {
            store.send(.destinationSelected(destination))
        } label: {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.headline)
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        // Empty state
        SearchView(
            store: Store(initialState: SearchReducer.State()) {
                SearchReducer()
            }
        )

        // Filled state
        SearchView(
            store: Store(
                initialState: SearchReducer.State(
                    searchBar: .init(searchText: "Bitcoin"),
                    isSearching: true
                )
            ) {
                SearchReducer()
            }
        )
    }
    .padding()
}
