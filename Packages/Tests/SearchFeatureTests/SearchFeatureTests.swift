import ComposableArchitecture
import Testing
import Foundation
import SharedModels
import SearchFeature

@MainActor
struct SearchFeatureTests {
    @Test
    func test_onAppear_loadsNFTs() async {
        let nfts = [
            NFT(isNew: true, isVideo: false, imageURL: "url1", videoURL: "v1"),
            NFT(isNew: false, isVideo: true, imageURL: "url2", videoURL: "v2")
        ]

        let store = TestStore(initialState: SearchFeatureReducer.State()) {
            SearchFeatureReducer()
        } withDependencies: {
            $0.apiClient.profile.getSavedNFT = { nfts }
        }

        await store.send(.view(.onAppear))
        await store.receive(\.internal.onGetNFTResponse.success) {
            $0.searchResults = .init(uniqueElements: nfts)
            $0.isLoading = false
        }
    }

    @Test
    func test_searchTextDidChange_updatesSearchingState() async {
        let store = TestStore(initialState: SearchFeatureReducer.State()) {
            SearchFeatureReducer()
        }

        await store.send(.searchBar(.delegate(.searchTextDidChange(newText: "Bitcoin")))) {
            $0.isSearching = true
        }

        await store.send(.searchBar(.delegate(.searchTextDidChange(newText: "")))) {
            $0.isSearching = false
        }
    }

    @Test
    func test_searchBarClear_updatesSearchingState() async {
        let store = TestStore(initialState: SearchFeatureReducer.State(isSearching: true)) {
            SearchFeatureReducer()
        }

        await store.send(.searchBar(.delegate(.searchDidClear))) {
            $0.isSearching = false
        }
    }

    @Test
    func test_searchSubmitted_appendsToHistory() async {
        let store = TestStore(initialState: SearchFeatureReducer.State(
            searchBar: .init(searchText: "Ethereum"),
            searchHistory: ["Bitcoin"]
        )) {
            SearchFeatureReducer()
        }

        await store.send(.searchBar(.delegate(.searchSubmitted(query: "Ethereum")))) {
            $0.searchHistory = ["Bitcoin", "Ethereum"]
        }
    }

    @Test
    func test_clearSearchHistory() async {
        let store = TestStore(initialState: SearchFeatureReducer.State(
            searchHistory: ["Bitcoin", "Ethereum"]
        )) {
            SearchFeatureReducer()
        }

        await store.send(.view(.clearSearchHistory)) {
            $0.searchHistory = []
        }
    }
}
