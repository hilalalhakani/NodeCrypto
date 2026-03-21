import ComposableArchitecture
import Foundation
import TCAHelpers

@Reducer
public struct ItemDetailsFeature: Sendable {
    public init() {}

    @ObservableState
    public struct State: Equatable, Sendable {
        public var label: String = ""
        public var description: String = ""
        public var isFixedPrice: Bool = true // false for Live auction
        public var price: String = ""
        public var currency: String = "ETH"
        public var royalties: String = "10"
        public var isUnlockOncePurchased: Bool = false
        public var isPutOnSale: Bool = true
        @Presents public var collectible: CollectibleFeature.State? = nil
        
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
        case nextButtonTapped
        case fixedPriceTapped
        case liveAuctionTapped
        case labelChanged(String)
        case descriptionChanged(String)
        case priceChanged(String)
        case currencyChanged(String)
        case royaltiesChanged(String)
        case unlockOncePurchasedChanged(Bool)
        case putOnSaleChanged(Bool)
    }

    @CasePathable
    public enum InternalAction: Sendable {
        case collectible(PresentationAction<CollectibleFeature.Action>)
    }

    @CasePathable
    public enum DelegateAction: Sendable {}

    @Dependency(\.dismiss) var dismiss

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(.backButtonTapped):
                return .run { _ in await dismiss() }
                
            case .view(.nextButtonTapped):
                state.collectible = CollectibleFeature.State()
                return .none
                
            case .view(.fixedPriceTapped):
                state.isFixedPrice = true
                return .none
                
            case .view(.liveAuctionTapped):
                state.isFixedPrice = false
                return .none
                
            case let .view(.labelChanged(label)):
                state.label = label
                return .none
                
            case let .view(.descriptionChanged(desc)):
                state.description = desc
                return .none
                
            case let .view(.priceChanged(price)):
                state.price = price
                return .none
                
            case let .view(.currencyChanged(currency)):
                state.currency = currency
                return .none
                
            case let .view(.royaltiesChanged(royalties)):
                state.royalties = royalties
                return .none
                
            case let .view(.unlockOncePurchasedChanged(val)):
                state.isUnlockOncePurchased = val
                return .none
                
            case let .view(.putOnSaleChanged(val)):
                state.isPutOnSale = val
                return .none
                
            case .internal(.collectible):
                return .none
                
            case .delegate:
                return .none
            }
        }
        .ifLet(\.$collectible, action: \.internal.collectible) {
            CollectibleFeature()
        }
    }
}
