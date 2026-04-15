import ComposableArchitecture
import Testing
import HomeFeature
import SharedModels

@MainActor
struct PlayerViewTests {
    let nft = NFTItem(
        image: "Dummy",
        name: "Test Name",
        creator: "Test Creator",
        creatorImage: "Dummy HUD",
        price: "$10.0",
        cryptoPrice: "1 ETH",
        videoURL: "Dummy"
    )

    @Test func testOnAppear() async {
        let loadedURL = LockIsolated<String?>(nil)
        let store = TestStore(initialState: PlayerViewReducer.State(nft: nft)) {
            PlayerViewReducer()
        } withDependencies: {
            $0.videoPlayer.load = { url in loadedURL.withValue { $0 = url } }
        }

        await store.send(\.onAppear)
        #expect(loadedURL.value == "Dummy")
    }

    @Test func testPlayPause() async {
        let store = TestStore(initialState: PlayerViewReducer.State(isPlaying: true, nft: nft)) {
            PlayerViewReducer()
        } withDependencies: {
            $0.videoPlayer.isPlaying = { true }
            $0.videoPlayer.pause = { }
            $0.videoPlayer.play = { }
        }

        await store.send(\.playPauseButtonTapped) {
            $0.isPlaying = false
        }
        
        store.dependencies.videoPlayer.isPlaying = { false }

        await store.send(\.playPauseButtonTapped) {
            $0.isPlaying = true
        }
    }

    @Test func testShowHideControls() async {
        let store = TestStore(initialState: PlayerViewReducer.State(areControlsHidden: false, nft: nft)) {
            PlayerViewReducer()
        }

        await store.send(\.hideControlsButtonTapped) {
            $0.areControlsHidden = true
        }

        await store.send(\.showControlsTapped) {
            $0.areControlsHidden = false
        }
    }

    @Test func testVolume() async {
        let setVolume = LockIsolated<Float?>(nil)
        let store = TestStore(initialState: PlayerViewReducer.State(nft: nft)) {
            PlayerViewReducer()
        } withDependencies: {
            $0.videoPlayer.setVolume = { volume in setVolume.withValue { $0 = volume } }
        }

        await store.send(.binding(.set(\.volume, 0.8))) {
            $0.volume = 0.8
        }
        #expect(setVolume.value == 0.8)
    }

    @Test func testStopPlayer() async {
        let destroyed = LockIsolated(false)
        let store = TestStore(initialState: PlayerViewReducer.State(nft: nft)) {
            PlayerViewReducer()
        } withDependencies: {
            $0.videoPlayer.destroy = { destroyed.withValue { $0 = true } }
        }

        await store.send(\.stopPlayerButtonTapped)
        await store.receive(\.delegate.playerClosed)
        #expect(destroyed.value)
    }
}
