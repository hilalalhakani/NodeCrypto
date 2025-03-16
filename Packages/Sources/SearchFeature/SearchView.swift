//
//  SearchView.swift
//  Main
//
//  Created by Hilal Hakkani on 23/02/2025.
//

import NodeCryptoCore
import SwiftUI

@Reducer
public struct SearchReducer {
    public init() {}

    @ObservableState
    public struct State: Equatable, Sendable {
        var searchBar: SearchBarReducer.State = .init()

        public init(searchBar: SearchBarReducer.State = .init()) {
            self.searchBar = searchBar
        }
    }

    public enum Action: Sendable {
        case searchBar(SearchBarReducer.Action)
    }

    public var body: some ReducerOf<Self> {
        Scope(state: \.searchBar, action: \.searchBar) {
            SearchBarReducer()
        }
    }
}

public struct SearchView: View {
    let store: StoreOf<SearchReducer>

    public init(store: StoreOf<SearchReducer>) {
        self.store = store
    }

    enum SearchDestination {
        case bestArtist
        case recentUploaded
        case videos
        case modeling
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

            if !store.searchBar.searchText.isEmpty {
                List {
                    ForEach(0..<5) { _ in
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
                .listStyle(.plain)
                .transition(.opacity)
            } else {
                Form {
                    Section("Suggestions") {
                        NavigationLink(value: SearchDestination.bestArtist) {
                            HStack {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                VStack(alignment: .leading) {
                                    Text("Best artist")
                                        .font(.headline)
                                    Text("Top 50 artist of the month")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                        }

                        NavigationLink(value: SearchDestination.recentUploaded) {
                            HStack {
                                Image(systemName: "square.and.arrow.up.fill")
                                    .foregroundColor(.green)
                                VStack(alignment: .leading) {
                                    Text("Recent uploaded")
                                        .font(.headline)
                                    Text("Top 50 artist of the month")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                        }

                        NavigationLink(value: SearchDestination.videos) {
                            HStack {
                                Image(systemName: "play.circle.fill")
                                    .foregroundColor(.red)
                                VStack(alignment: .leading) {
                                    Text("Videos")
                                        .font(.headline)
                                    Text("Top 50 artist of the month")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }

                    Section("Search history") {
                        NavigationLink(value: SearchDestination.modeling) {
                            HStack {
                                Image(systemName: "cube.fill")
                                    .foregroundColor(.gray)
                                VStack(alignment: .leading) {
                                    Text("3D modeling")
                                        .font(.headline)
                                    Text("256 results")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                        }

                        NavigationLink(value: SearchDestination.videos) {
                            HStack {
                                Image(systemName: "play.circle.fill")
                                    .foregroundColor(.gray)
                                VStack(alignment: .leading) {
                                    Text("Videos")
                                        .font(.headline)
                                    Text("Top 50 artist of the month")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                }
                .navigationDestination(for: SearchDestination.self) { destination in
                    switch destination {
                    case .bestArtist:
                        Text("Best Artist View")
                    case .recentUploaded:
                        Text("Recent Uploaded View")
                    case .videos:
                        Text("Videos View")
                    case .modeling:
                        Text("3D Modeling View")
                    }
                }
                .scrollContentBackground(.hidden)
            }
        }
        .ignoresSafeArea(.keyboard)
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
                initialState: SearchReducer.State(searchBar: .init(searchText: "Bitcoin"))
            ) {
                SearchReducer()
            }
        )
    }
    .padding()
}
