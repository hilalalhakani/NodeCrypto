import ComposableArchitecture
import Dependencies
import Foundation
import ProfileFeature
import SharedModels
import Testing

@MainActor
struct ProfileReducerTests {

    @Test func test_initialState() {
        let store = TestStore(initialState: ProfileReducer.State()) {
            ProfileReducer()
        }

        // Verify initial state
        #expect(store.state.nfts == [])
        #expect(store.state.likedNfts == [])
        #expect(store.state.createdNfts == [])
        #expect(store.state.aboutMeItems == [])
        #expect(store.state.isLoading == true)
        let selectedItem = store.state.selectedTitle
        let expectedTitle = "On sale"
        #expect(selectedItem == expectedTitle)
    }

    @Test func test_getNFTs_success() async {
        let nftItems = [NFT(isNew: true, isVideo: false, imageURL: "", videoURL: "")]
        let uuid = UUID()
        let aboutMeItems = [
            AboutMeItem(
                title: "Collection",
                count: "24",
                iconName: "magazine",
                id: uuid
            )
        ]

        let store = TestStore(initialState: ProfileReducer.State()) {
            ProfileReducer()
        } withDependencies: { [nftItems] in
            $0.apiClient.profile.getSavedNFT = { @Sendable in nftItems }
            $0.apiClient.profile.getUserInfo = { @Sendable in aboutMeItems }
            $0.apiClient.profile.getLikedNFT = { @Sendable in nftItems }
            $0.apiClient.profile.getCreatedNFT = { @Sendable in nftItems }
        }

        await store.send(\.view.onAppear)

        await store.receive(\.internal.onGetNFTResponse) {
            $0.nfts = IdentifiedArrayOf(uniqueElements: nftItems)
            $0.isLoading = false
        }

        await store.receive(\.internal.onGetAboutItemsResponse) {
            $0.aboutMeItems = IdentifiedArrayOf(uniqueElements: aboutMeItems)
        }

        await store.receive(\.internal.onGetLikedNFTResponse) {
            $0.likedNfts = IdentifiedArrayOf(uniqueElements: nftItems)
        }

        await store.receive(\.internal.onGetCreatedNFTResponse) {
            $0.createdNfts = IdentifiedArrayOf(uniqueElements: nftItems)
        }

    }
    
    @Test func test_selectedTitleChange() async {
        let store = TestStore(initialState: ProfileReducer.State()) {
            ProfileReducer()
        }

        await store.send(.internal(.onSelectedTitleChange("about Me"))) {
            $0.selectedTitle = "about Me"
        }
    }
}
