import ComposableArchitecture
import Testing
import Root
import Foundation

@MainActor
struct RootTests {
    @Test
    func test_tabSelected() async {
        let store = TestStore(initialState: RootFeature.State()) {
            RootFeature()
        }

        await store.send(.view(.tabSelected(.search))) {
            $0.selectedTab = .search
        }

        await store.send(.view(.tabSelected(.notifications))) {
            $0.selectedTab = .notifications
        }
    }

    @Test
    func test_tabSelected_add_triggers_addButtonPressed() async {
        let store = TestStore(initialState: RootFeature.State()) {
            RootFeature()
        }

        await store.send(.view(.tabSelected(.add)))
        await store.receive(\.view.addButtonPressed) {
            $0.showsWobbleMenu = true
        }
    }

    @Test
    func test_addButtonPressed_togglesWobbleMenu() async {
        let store = TestStore(initialState: RootFeature.State()) {
            RootFeature()
        }

        await store.send(.view(.addButtonPressed)) {
            $0.showsWobbleMenu = true
        }

        await store.send(.view(.addButtonPressed)) {
            $0.showsWobbleMenu = false
        }
    }

    @Test
    func test_createSingleButtonTapped() async {
        let store = TestStore(initialState: RootFeature.State(showsWobbleMenu: true)) {
            RootFeature()
        }

        await store.send(.view(.createSingleButtonTapped)) {
            $0.create = .init(pickerMode: .single)
            $0.showsWobbleMenu = false
        }
    }

    @Test
    func test_createMultipleButtonTapped() async {
        let store = TestStore(initialState: RootFeature.State(showsWobbleMenu: true)) {
            RootFeature()
        }

        await store.send(.view(.createMultipleButtonTapped)) {
            $0.create = .init(pickerMode: .multiple)
            $0.showsWobbleMenu = false
        }
    }

    @Test
    func test_hideWobbleMenu() async {
        let store = TestStore(initialState: RootFeature.State(showsWobbleMenu: true)) {
            RootFeature()
        }

        await store.send(.view(.hideWobbleMenu)) {
            $0.showsWobbleMenu = false
        }
    }

    @Test
    func test_profile_delegate_menuButtonPressed_showsProfileActionsList() async {
        let store = TestStore(initialState: RootFeature.State()) {
            RootFeature()
        }

        await store.send(.internal(.profile(.delegate(.menuButtonPressed)))) {
            $0.showsProfileActionsList = true
        }
    }
}
