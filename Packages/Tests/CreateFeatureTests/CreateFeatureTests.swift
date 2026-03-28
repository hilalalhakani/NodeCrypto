import ComposableArchitecture
import Testing
@testable import CreateFeature
@testable import SharedViews
import SwiftUI
import Foundation

@MainActor
struct CreateFeatureTests {
    @Test
    func test_nextButtonTapped_presentsItemDetails() async {
        let store = TestStore(initialState: CreateFeature.State(pickerMode: .single)) {
            CreateFeature()
        }

        await store.send(.view(.nextButtonTapped)) {
            $0.itemDetails = ItemDetailsFeature.State()
        }
    }

    @Test
    func test_picker_delegate_loadSingleImage() async {
        let store = TestStore(initialState: CreateFeature.State(pickerMode: .single)) {
            CreateFeature()
        } withDependencies: {
            $0.uuid = .incrementing
        }
        
        let image = Image(systemName: "photo")
        let data = Data("mock-nft-image-data-1".utf8)

        await store.send(.internal(.picker(.delegate(.loadSingleImage(image, data))))) {
            let item = CreateFeature.GalleryItem(id: UUID(0), image: image, data: data)
            $0.selectedItem = item
            $0.selectedItems = [item.id]
            $0.selectedImages = [item]
            $0.isNextButtonEnabled = true
        }
        
        await store.receive(\.delegate.imageSelected)
    }

    @Test
    func test_picker_delegate_loadMultipleImages() async {
        let store = TestStore(initialState: CreateFeature.State(pickerMode: .multiple)) {
            CreateFeature()
        } withDependencies: {
            $0.uuid = .incrementing
        }
        
        let image1 = Image(systemName: "photo.fill")
        let data1 = Data("mock-nft-multiple-data-1".utf8)
        let image2 = Image(systemName: "photo")
        let data2 = Data("mock-nft-multiple-data-2".utf8)

        await store.send(.internal(.picker(.delegate(.loadMultipleImages([(image1, data1), (image2, data2)]))))) {
            let item1 = CreateFeature.GalleryItem(id: UUID(0), image: image1, data: data1)
            let item2 = CreateFeature.GalleryItem(id: UUID(1), image: image2, data: data2)
            $0.selectedImages = [item1, item2]
            $0.selectedItems = [item1.id, item2.id]
            $0.isNextButtonEnabled = true
        }
        
        await store.receive(\.delegate.multipleImagesSelected)
    }

    @Test
    func test_itemDetails_flow() async {
        let store = TestStore(initialState: ItemDetailsFeature.State()) {
            ItemDetailsFeature()
        }

        await store.send(.view(.labelChanged("Moonbound NFT"))) {
            $0.label = "Moonbound NFT"
        }

        await store.send(.view(.descriptionChanged("A rare digital collectible from the lunar surface."))) {
            $0.description = "A rare digital collectible from the lunar surface."
        }

        await store.send(.view(.priceChanged("2.5"))) {
            $0.price = "2.5"
        }
        
        await store.send(.view(.liveAuctionTapped)) {
            $0.isFixedPrice = false
        }
        
        await store.send(.view(.nextButtonTapped)) {
            $0.collectible = CollectibleFeature.State()
        }
    }

    @Test
    func test_collectible_selection() async {
        let store = TestStore(initialState: CollectibleFeature.State()) {
            CollectibleFeature()
        }

        await store.send(.view(.collectionTapped("1"))) {
            $0.selectedCollectionId = "1"
        }
    }
}
