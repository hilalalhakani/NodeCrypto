import ComposableArchitecture
import CreateFeature
import DependenciesTestSupport
import Foundation
import SnapshotTesting
import SwiftUI
import Testing

@Suite(.dependencies {
    $0.continuousClock = .immediate
})
@MainActor
struct CreateFeatureSnapshotsTests {

    // MARK: - CreateView

    @Test
    func test_createView_empty() throws {
        let store = Store(
            initialState: CreateFeature.State(pickerMode: .single),
            reducer: { CreateFeature() }
        )

        try assert(CreateView(store: store))
    }

    @Test
    func test_createView_nextButtonDisabled() throws {
        let store = Store(
            initialState: CreateFeature.State(pickerMode: .single),
            reducer: { CreateFeature() }
        )
        try assert(CreateView(store: store))
    }

    @Test
    func test_createView_nextButtonEnabled() throws {
        var initialState = CreateFeature.State(pickerMode: .single)
        initialState.isNextButtonEnabled = true

        let store = Store(
            initialState: initialState,
            reducer: { CreateFeature() }
        )

        try assert(CreateView(store: store))
    }

    @Test
    func test_createView_singleImageSelected() throws {
        var initialState = CreateFeature.State(pickerMode: .single)
        let placeholderImage = Image(systemName: "photo.fill")
        let placeholderData = Data()
        let item = CreateFeature.GalleryItem(image: placeholderImage, data: placeholderData)

        initialState.selectedImages = [item]
        initialState.selectedItems = [item.id]
        initialState.selectedItem = item
        initialState.isNextButtonEnabled = true

        let store = Store(
            initialState: initialState,
            reducer: { CreateFeature() }
        )

        try assert(CreateView(store: store))
    }

    @Test
    func test_createView_multipleImagesSelected() throws {
        var initialState = CreateFeature.State(pickerMode: .multiple)
        let placeholderImage = Image(systemName: "photo.fill")
        let items = (0..<3).map { _ in
            CreateFeature.GalleryItem(image: placeholderImage, data: Data())
        }

        initialState.selectedImages = items
        initialState.selectedItems = Set(items.map(\.id))
        initialState.isNextButtonEnabled = true

        let store = Store(
            initialState: initialState,
            reducer: { CreateFeature() }
        )

        try assert(CreateView(store: store))
    }

    // MARK: - ItemDetailsView

    @Test
    func test_itemDetailsView_defaultState() throws {
        let store = Store(
            initialState: ItemDetailsFeature.State(),
            reducer: { ItemDetailsFeature() }
        )

        try assert(ItemDetailsView(store: store))
    }

    @Test
    func test_itemDetailsView_fixedPrice() throws {
        var state = ItemDetailsFeature.State()
        state.label = "Redeemable Bitcoin Card"
        state.description = "After purchasing you will be able to redeem this rare digital collectible."
        state.isFixedPrice = true
        state.price = "2.5"
        state.currency = "ETH"
        state.royalties = "10"

        let store = Store(
            initialState: state,
            reducer: { ItemDetailsFeature() }
        )

        try assert(ItemDetailsView(store: store))
    }

    @Test
    func test_itemDetailsView_liveAuction() throws {
        var state = ItemDetailsFeature.State()
        state.label = "Rare Digital Art"
        state.description = "One-of-a-kind NFT up for live auction."
        state.isFixedPrice = false
        state.price = "1.0"
        state.currency = "ETH"
        state.royalties = "5"

        let store = Store(
            initialState: state,
            reducer: { ItemDetailsFeature() }
        )

        try assert(ItemDetailsView(store: store))
    }

    @Test
    func test_itemDetailsView_unlockOncePurchased_enabled() throws {
        var state = ItemDetailsFeature.State()
        state.isUnlockOncePurchased = true
        state.isPutOnSale = true

        let store = Store(
            initialState: state,
            reducer: { ItemDetailsFeature() }
        )

        try assert(ItemDetailsView(store: store))
    }

    @Test
    func test_itemDetailsView_putOnSale_disabled() throws {
        var state = ItemDetailsFeature.State()
        state.isPutOnSale = false

        let store = Store(
            initialState: state,
            reducer: { ItemDetailsFeature() }
        )

        try assert(ItemDetailsView(store: store))
    }

    @Test
    func test_itemDetailsView_french() throws {
        var state = ItemDetailsFeature.State()
        state.label = "Redeemable Bitcoin Card"
        state.description = "After purchasing you will be able to redeem this rare digital collectible."
        state.isFixedPrice = true
        state.isUnlockOncePurchased = true
        state.isPutOnSale = true

        let store = Store(
            initialState: state,
            reducer: { ItemDetailsFeature() }
        )

        try assert(
            ItemDetailsView(store: store)
                .environment(\.locale, Locale(identifier: "fr")),
            named: "test_itemDetailsView_fr"
        )
    }
}
