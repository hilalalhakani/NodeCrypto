//
//  SearchView.swift
//  Main
//
//  Created by Hilal Hakkani on 23/02/2025.
//

import APIClient
import NodeCryptoCore
import ResourceProvider
import SwiftUI
import SharedViews // For ExpandingMenuButton
import StyleGuide // For FontName

@Reducer
public struct SearchReducer: Sendable {
    @Dependency(\.apiClient.profile) var profileAPI
    
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
        var searchHistory: [String] = []
        var isSearching: Bool = false
        var selectedDestination: SearchDestination? = nil
        public var selectedTitle: String = "Hot Bids"
        public var titles = ["Hot Bids", "Hot collection", "Hot artist"]
        public var searchResults: IdentifiedArrayOf<NFT> = []
        public var isLoading = true

        public init(
            searchBar: SearchBarReducer.State = .init(),
            searchHistory: [String] = [],
            isSearching: Bool = false,
            selectedDestination: SearchDestination? = nil,
            selectedTitle: String = "Hot Bids",
            titles: [String] = ["Hot Bids", "Hot collection", "Hot artist"],
            searchResults: IdentifiedArrayOf<NFT> = [],
            isLoading: Bool = true
        ) {
            self.searchBar = searchBar
            self.searchHistory = searchHistory
            self.isSearching = isSearching
            self.selectedDestination = selectedDestination
            self.selectedTitle = selectedTitle
            self.titles = titles
            self.searchResults = searchResults
            self.isLoading = isLoading
        }
    }

    @CasePathable
    public enum Action: TCAFeatureAction, Sendable {
        case view(ViewAction)
        case `internal`(InternalAction)
        case delegate(DelegateAction)
        case searchBar(SearchBarReducer.Action)
    }

    @CasePathable
    public enum InternalAction: Sendable {
        case onSelectedTitleChange(String)
        case onGetNFTResponse(Result<[NFT], Error>)
        case onSelectedDestinationChange(SearchDestination?)
    }

    @CasePathable
    public enum DelegateAction: Sendable {}

    @CasePathable
    public enum ViewAction: Sendable {
        case searchResultTapped(String)
        case historyItemTapped(String)
        case destinationSelected(SearchDestination)
        case clearSearchHistory
        case onAppear
    }

    public var body: some ReducerOf<Self> {
        Scope(state: \.searchBar, action: \.searchBar) {
            SearchBarReducer()
        }

        CombineReducers {
            NestedAction(\.view) { state, action in
                switch action {
                case .onAppear:
                    return .run { send in
                        await send(
                            .internal(
                                .onGetNFTResponse(
                                    .init(catching: {
                                        try await profileAPI.getSavedNFT()
                                    })
                                )
                            )
                        )
                    }

                case .clearSearchHistory:
                    state.searchHistory.removeAll()
                    return .none
                case .destinationSelected(let selectedDestination):
                    state.selectedDestination = selectedDestination
                    return .none
                default:
                    return .none
                }
            }

            NestedAction(\.internal) { state, action in
                switch action {
                case let .onGetNFTResponse(result):
                    switch result {
                    case .success(let nfts):
                        state.searchResults = .init(uniqueElements: nfts)
                        state.isLoading = false
                    case .failure:
                        state.isLoading = false
                    }
                    return .none
                case .onSelectedTitleChange(let title):
                    state.selectedTitle = title
                    return .none
                default:
                    return .none
                }
            }
        }

        NestedAction(\.searchBar) { state, action in
            switch action {
            case let .searchTextChanged(text):
                state.isSearching = !text.isEmpty
                return .none

            case .clearSearchText:
                state.isSearching = false
                return .none

            case .searchButtonPressed:
                state.searchHistory.append(state.searchBar.searchText)
                return .none
            default:
                return .none
            }
        }
    }
}

public struct SearchView: View {
    @Bindable var store: StoreOf<SearchReducer>
    let gridLayout: [GridItem] = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8),
    ]

    public init(store: StoreOf<SearchReducer>) {
        self.store = store
    }

    public var body: some View {
        VStack(spacing: 20) {
            Text("Discover")
                .foregroundStyle(Color.neutral2)
                .font(.custom(FontName.poppinsBold.rawValue, size: 24))
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity, alignment: .leading)

            SearchBar(
                store: store.scope(
                    state: \.searchBar,
                    action: \.searchBar
                )
            )
            .padding(.horizontal, 25)

            Group {
                if store.isSearching {
                    ZStack(alignment: .bottom) {
                        searchResults
                        ExpandingMenuButton(
                            selectedTitle: $store.selectedTitle.sending(
                                \.internal.onSelectedTitleChange
                            ),
                            titles: store.titles
                        )
                    }
                } else {
                    suggestionsForm
                }
            }
            .transition(.opacity)
        }
        .animation(.easeInOut, value: store.isSearching)
        .task {
            store.send(.view(.onAppear))
        }
        .navigationDestination(item: $store.selectedDestination.sending(\.internal.onSelectedDestinationChange)) {
            switch $0 {
                case .bestArtist:
                    Text("Artist")
                case .modeling:
                    Text("Modeling")
                case .recentUploaded:
                    Text("Recent Uploaded")
                case .videos:
                    Text("Videos")
            }
        }
    }

    @ViewBuilder private var searchResults: some View {
        if store.searchResults.isEmpty {
            Text("No results found for '\(store.searchBar.searchText)'")
                .foregroundColor(.gray)
                .frame(maxHeight: .infinity, alignment: .center)
        } else {
            ScrollView {
                LazyVGrid(columns: gridLayout, spacing: 20) {
                    ForEach(store.searchResults) { nft in
                        AsyncImageView(url: URL(string: nft.imageURL)!)
                            .frame(height: 168)
                            .cornerRadius(8)
                            .clipShape(
                                RoundedRectangle(
                                    cornerRadius: 16, style: .circular)
                            )
                            .overlay(alignment: .topLeading) {
                                if nft.isNew {
                                    Text("New")
                                        .padding(8)
                                        .foregroundStyle(Color.neutral8)
                                        .font(
                                            .custom(
                                                FontName.dmSansBold.rawValue,
                                                size: 14)
                                        )
                                        .background(
                                            Color.primary4
                                        )
                                        .clipShape(
                                            RoundedRectangle(
                                                cornerRadius: 16,
                                                style: .circular)
                                        )
                                        .padding(8)
                                }
                            }
                            .overlay(alignment: .center) {
                                if nft.isVideo {
                                    Image(systemName: "play.circle.fill")
                                        .resizable()
                                        .frame(width: 44, height: 44)
                                        .foregroundColor(.white)
                                }
                            }
                    }
                }
                .padding()
            }
        }
    }

    private var suggestionsForm: some View {
        Form {
            suggestionsSection
            searchHistorySection
        }
        .scrollContentBackground(.hidden)
    }

    private var suggestionsSection: some View {
        Section {
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
                subtitle: "Top 50 artist of the month"
            )
        } header: {
            Text("Suggestions")
                .font(.custom(FontName.poppinsRegular.rawValue, size: 12))
                .foregroundStyle(Color.neutral4)
        }
    }

    private var searchHistorySection: some View {
        Section {
            if store.searchHistory.isEmpty {
                Text("No search history")
                    .foregroundColor(.gray)
                    .italic()
            } else {
                ForEach(store.searchHistory, id: \.self) { item in
                    Button {
                        store.send(.view(.historyItemTapped(item)))
                    } label: {
                        HStack {
                            Image(systemName: "clock.arrow.circlepath")
                                .foregroundColor(.secondary)
                            Text(item)
                                .foregroundColor(.primary)
                            Spacer()
                        }
                    }
                }

                Button("Clear History") {
                    store.send(.view(.clearSearchHistory))
                }
                .foregroundColor(.red)
            }
        } header: {
            Text("Search history")
                .font(.custom(FontName.poppinsRegular.rawValue, size: 12))
                .foregroundStyle(Color.neutral4)
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
            store.send(.view(.destinationSelected(destination)))
        } label: {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .frame(width: 24, height: 24)
                    .padding(8)
                    .background(color.opacity(0.1))
                    .cornerRadius(8)

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                    Text(subtitle)
                        .foregroundColor(.gray)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .padding(.vertical, 4)
    }
}

#Preview {
    SearchView(
        store: Store(
            initialState: SearchReducer.State(
                searchHistory: ["Ethereum", "NFT", "DeFi"]
            )
        ) {
            SearchReducer()
        }
    )
}

#Preview {
    SearchView(
        store: Store(
            initialState: SearchReducer.State(
                searchBar: .init(searchText: "Bitcoin"),
                searchHistory: ["Ethereum", "NFT", "DeFi", "Web3"],
                isSearching: true,
                searchResults: []
            )
        ) {
            SearchReducer()
        }
    )
}
