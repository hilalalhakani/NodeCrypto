import ComposableArchitecture
import Foundation
import NodeCryptoCore
import Photos
import SharedViews
import SwiftUI
import UIKit

@Reducer
public struct CreateFeature: Sendable {
    @Dependency(\.photoLibraryClient) var photoLibraryClient

    public init() {}

    @ObservableState
    public struct State: Equatable, Sendable {
        var galleryImages: [Image] = []
        var picker: ImagesPicker.State

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
    }

    @CasePathable
    public enum InternalAction: Sendable {
        case picker(ImagesPicker.Action)
        case initialGalleryImagesLoaded(Result<[(Image, Data)], Error>)
    }

    @CasePathable
    public enum DelegateAction: Sendable {
        case imageSelected(Image?, Data?)
        case multipleImagesSelected([(Image, Data)])
    }

    public var body: some ReducerOf<Self> {
        Scope(state: \.picker, action: \.internal.picker) {
            ImagesPicker()
        }

        Reduce { state, action in
            switch action {
            case .view(.nextButtonTapped):
                return .none

            case .view(.onAppear):
                return .run { send in
                    await send(
                        .internal(
                            .initialGalleryImagesLoaded(
                                Result {
                                    try await photoLibraryClient.fetchImages(7)
                                }
                            )
                        )
                    )
                }

//            case let .internal(
//                .picker(.singleImagePicker(.delegate(.loadSingleImage(image))))
//            ):
//                return .none
//
//            case let .internal(
//                .picker(
//                    .multipleImagePicker(.delegate(.loadMultipleImages(images)))
//                )
//            ):
//                if let firstImage = images.first?.0 {
//                    state.selectedMainImage = firstImage
//                }
//                state.galleryImages = images.map { $0.0 }
//                return .none

            case let .internal(.initialGalleryImagesLoaded(.success(images))):
                state.galleryImages.insert(
                    contentsOf: images.map { $0.0 },
                    at: 0
                )
                return .none

            case .internal(.initialGalleryImagesLoaded(.failure(let error))):
                print("Failed to load initial gallery images: \(error)")
                return .none

            case .internal:
                return .none
                    
            case .delegate:
                return .none
            }
        }
    }
}
