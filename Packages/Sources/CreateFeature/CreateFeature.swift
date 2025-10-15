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
    @Dependency(\.dismiss) var dismiss

    public init() {}

    @Reducer(state: .sendable, .equatable, action: .sendable)
    public enum Path {
        case empty(EmptyReducer)
    }

    @ObservableState
    public struct State: Equatable, Sendable {
        var path = StackState<Path.State>()
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
        case path(StackAction<Path.State, Path.Action>)
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
                state.path.append(.empty(.init()))
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

            case .internal, .delegate, .path:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}

@Reducer
public struct EmptyReducer: Reducer {
    public struct State: Equatable {
        public init() {}
    }
    public enum Action: Sendable {}

    public var body: some ReducerOf<Self> {
        Reduce { _, _ in
            return .none
        }
    }
}
