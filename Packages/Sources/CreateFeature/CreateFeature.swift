import ComposableArchitecture
import Foundation
import Photos
import SharedViews
import SwiftUI
import UIKit
import TCAHelpers

@Reducer
public struct CreateFeature: Sendable {
    @Dependency(\.photoLibraryClient) var photoLibraryClient
    @Dependency(\.dismiss) var dismiss

    public init() {}

    @ObservableState
    public struct State: Equatable, Sendable {
        var galleryImages: [Image] = []
        var picker: ImagesPicker.State
        var isNextButtonEnabled = false

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
        case galleryImageTapped
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
            case .view(.backButtonTapped):
                return .run { _ in
                    await self.dismiss()
                }

            case .view(.galleryImageTapped):
                return .none

            case let .internal(.initialGalleryImagesLoaded(.success(images))):
                state.galleryImages.insert(
                    contentsOf: images.map { $0.0 },
                    at: 0
                )
                return .none

            case .internal(.initialGalleryImagesLoaded(.failure(let error))):
                print("Failed to load initial gallery images: \(error)")
                return .none

            case .internal, .delegate:
                return .none
            }
        }
    }
}
