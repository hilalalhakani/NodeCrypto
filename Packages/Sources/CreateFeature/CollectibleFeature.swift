import ComposableArchitecture
import Foundation
import TCAHelpers

@Reducer
public struct CollectibleFeature: Sendable {
    public init() {}

    public struct CollectionItem: Equatable, Identifiable, Sendable {
        public let id: String
        public let title: String
        public let imageName: String
        
        public init(id: String, title: String, imageName: String) {
            self.id = id
            self.title = title
            self.imageName = imageName
        }
    }

    @ObservableState
    public struct State: Equatable, Sendable {
        public var collections: [CollectionItem] = [
            CollectionItem(id: "1", title: "The great collection", imageName: "Collection1"),
            CollectionItem(id: "3", title: "Bento\nillustration", imageName: "Collection3"),
            CollectionItem(id: "4", title: "Robot\ncollection", imageName: "Collection4"),
            CollectionItem(id: "5", title: "Amazing\ncollection", imageName: "Collection5")
        ]
        public var selectedCollectionId: String? = nil
        
        public init() {}
    }

    @CasePathable
    public enum Action: TCAFeatureAction, Sendable {
        case view(ViewAction)
        case `internal`(InternalAction)
        case delegate(DelegateAction)
    }

    @CasePathable
    public enum ViewAction: Sendable {
        case backButtonTapped
        case createCollectionTapped
        case collectionTapped(String)
        case uploadItemTapped
    }

    @CasePathable
    public enum InternalAction: Sendable {}

    @CasePathable
    public enum DelegateAction: Sendable {}

    @Dependency(\.dismiss) var dismiss

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(.backButtonTapped):
                return .run { _ in await dismiss() }
                
            case .view(.createCollectionTapped):
                // Handle create collection
                return .none
                
            case let .view(.collectionTapped(id)):
                state.selectedCollectionId = id
                return .none
                
            case .view(.uploadItemTapped):
                // Handle upload
                return .none
                
            case .delegate, .internal:
                return .none
            }
        }
    }
}
