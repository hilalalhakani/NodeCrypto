import ComposableArchitecture
import Foundation
import Photos
import SharedViews
import SwiftUI
#if canImport(UIKit)
import UIKit
#endif
import TCAHelpers

@Reducer
public struct CreateFeature: Sendable {
    @Dependency(\.dismiss) var dismiss
    @Dependency(\.uuid) var uuid

    public init() {}

    public struct GalleryItem: Identifiable, Equatable, Sendable {
        public var id = UUID()
        public var image: Image
        public var data: Data

        public init(id: UUID = UUID(), image: Image, data: Data) {
            self.id = id
            self.image = image
            self.data = data
        }

        public static func ==(lhs: GalleryItem, rhs: GalleryItem) -> Bool {
            lhs.id == rhs.id
        }
    }

    @ObservableState
    public struct State: Equatable, Sendable {
        public var picker: ImagesPicker.State
        public var isNextButtonEnabled = false
        public var selectedItem: GalleryItem? = nil
        public var selectedItems: Set<UUID> = []
        public var selectedImages: [GalleryItem] = []
        @Presents public var itemDetails: ItemDetailsFeature.State? = nil

        public init(pickerMode: ImagesPicker.PickerMode) {
            self.picker = ImagesPicker.State(pickerMode: pickerMode)
        }
    }

    @CasePathable
    public enum Action: TCAFeatureAction, Sendable {
        case view(ViewAction)
        case `internal`(InternalAction)
        case delegate(DelegateAction)
    }

    @CasePathable
    public enum ViewAction: Sendable {
        case nextButtonTapped
        case onAppear
        case backButtonTapped
    }

    @CasePathable
    public enum InternalAction: Sendable {
        case picker(ImagesPicker.Action)
        case itemDetails(PresentationAction<ItemDetailsFeature.Action>)
    }

    @CasePathable
    public enum DelegateAction: Sendable {
        case imageSelected(Image?, Data?)
        case multipleImagesSelected([(Image, Data)])
    }

    public var body: some ReducerOf<Self> {
        CombineReducers {
            Scope(state: \.picker, action: \.internal.picker) {
                ImagesPicker()
            }

            Reduce { state, action in
                switch action {
                case let .view(viewAction):
                    switch viewAction {
                    case .nextButtonTapped:
                        state.itemDetails = ItemDetailsFeature.State()
                        return .none

                    case .onAppear:
                        return .none

                    case .backButtonTapped:
                        return .run { _ in
                            await self.dismiss()
                        }
                    }

                case let .internal(internalAction):
                    switch internalAction {
                    case let .picker(.delegate(.loadSingleImage(image, data))):
                        if let image = image, let data = data {
                            let item = GalleryItem(id: self.uuid(), image: image, data: data)
                            state.selectedItem = item
                            state.selectedItems = [item.id]
                            state.selectedImages = [item]
                            state.isNextButtonEnabled = true
                            return .send(.delegate(.imageSelected(image, data)))
                        }
                        return .none

                    case let .picker(.delegate(.loadMultipleImages(images))):
                        let items = images.map { GalleryItem(id: self.uuid(), image: $0.0, data: $0.1) }
                        state.selectedImages = items
                        state.selectedItems = Set(items.map { $0.id })
                        state.isNextButtonEnabled = !images.isEmpty
                        return .send(.delegate(.multipleImagesSelected(images)))

                    case .picker:
                        return .none

                    case .itemDetails:
                        return .none
                    }

                case .delegate:
                    return .none
                }
            }
        }
        .ifLet(\.$itemDetails, action: \.internal.itemDetails) {
            ItemDetailsFeature()
        }
    }
}
