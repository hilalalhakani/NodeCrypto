import APIClient
import AVFoundation
import AVKit
import Dependencies
import NodeCryptoCore
import ResourceProvider
import SwiftUI

@Reducer
public struct HomeReducer: Sendable {
    @Dependency(\.apiClient.home) var api

    public init() {}

    @ObservableState
    public struct State: Equatable, Sendable {
        @Presents var playerViewReducerState: PlayerViewReducer.State? = nil
        var nfts: IdentifiedArrayOf<NFTItem> = IdentifiedArrayOf(uniqueElements: NFTItem.samples())
        var creators: IdentifiedArrayOf<Creator> = IdentifiedArrayOf(uniqueElements:  Creator.samples())
        var isLoading = true
        public init() {}
    }

    public enum Action: Sendable {
        case onAppear
        case tappedNFT(NFTItem)
        case playerViewAction(PresentationAction<PlayerViewReducer.Action>)
        case onCreatorsResponse([Creator])
        case onNFTSResponse([NFTItem])
        case removePlaceHolder
    }

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {

                case .tappedNFT(let nFTItem):
                    state.playerViewReducerState = .init(nft: nFTItem)
                    return .none

                case .playerViewAction(.presented(.stopPlayer)):
                    state.playerViewReducerState = nil
                    return .none

                case .playerViewAction:
                    return .none

                case .onAppear:
                    return .run { send in
                        async let creators = try api.getCreators()
                        async let nfts = try api.getNFTS()
                        try await send(.onCreatorsResponse(creators))
                        try await send(.onNFTSResponse(nfts))
                        await send(.removePlaceHolder)
                    }

                case .removePlaceHolder:
                    state.isLoading = false
                    return .none

                case .onCreatorsResponse(let items):
                    state.creators = .init(uniqueElements: items)
                    return .none

                case .onNFTSResponse(let items):
                    state.nfts = .init(uniqueElements: items)
                    return .none
            }
        }
        .ifLet(\.$playerViewReducerState, action: \.playerViewAction) {
            PlayerViewReducer()
        }

    }
}

public struct HomeView: View {
    @Bindable var store: StoreOf<HomeReducer>

    public init(store: StoreOf<HomeReducer>) {
        self.store = store
    }

    public var body: some View {
        VStack(alignment: .leading) {
            headerView
            bestSellersScrollView
            featuredItemsScrollView
        }
        .redacted(reason: store.isLoading ? .placeholder : [])
        .disabled(store.isLoading)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .fullScreenCover(
            item: $store.scope(state: \.playerViewReducerState, action: \.playerViewAction)
        ) { store in
            PlayerView(store: store)
        }
        .task {
            store.send(.onAppear)
        }
    }

    // MARK: - Subviews
    private var headerView: some View {
        HStack {
            Text("Best sellers")
                .font(.system(size: 32, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)

            Button(action: {}) {
                Image(systemName: "arrow.right")
                    .foregroundColor(.gray)
            }
        }
        .padding(.horizontal, 24)
    }

    private var bestSellersScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(store.creators) { creator in
                    SellerItemView(creator: creator)
                        .frame(width: 200)
                }
            }
            .safeAreaPadding(24)
        }
    }

    private var featuredItemsScrollView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 0) {
                ForEach(store.nfts) { nft in
                    FeaturedItem(nft: nft)
                        .onTapGesture {
                            store.send(.tappedNFT(nft))
                        }
                }
            }
        }
        .scrollTargetBehavior(.paging)
        .padding(.horizontal, 24)
    }

    struct FeaturedItem: View {
        let nft: NFTItem
        var body: some View {
            Group {
                if let url = URL(string: nft.image) {
                    AsyncImageView(url: url)
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                }
                else {
                    RoundedRectangle(cornerRadius: 24)
                        .foregroundStyle(.gray)
                }
            }
            .overlay(alignment: .top) {
                VStack(spacing: 0) {
                    itemInfoView
                    Spacer()
                    playButton
                    Spacer()
                    placeBidButton
                }
            }
            .padding(.vertical)
            .frame(maxWidth: .infinity)
            .containerRelativeFrame(.vertical)
        }

        private var itemInfoView: some View {
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(.white)
                .frame(height: 85)
                .overlay {
                    VStack {
                        HStack {
                            Text(nft.name)
                                .font(.system(size: 24, weight: .bold))
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Text(nft.cryptoPrice)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.gray)
                        }

                        HStack {
                            Group {
                                if let url = URL(string: nft.creatorImage) {
                                    AsyncImageView(url: url)
                                        .clipShape(Circle())
                                }
                                else {
                                    Circle()
                                        .foregroundStyle(.gray)
                                }
                            }
                            .frame(width: 20, height: 20)

                            Text(nft.cryptoPrice)
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Text(nft.price)
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.horizontal, 15)
                }
                .padding(20)
        }

        private var playButton: some View {
            Circle()
                .foregroundColor(.white)
                .frame(height: 48)
                .overlay {
                    Image(systemName: "play.fill")
                        .foregroundColor(.gray)
                }
        }

        private var placeBidButton: some View {
            Button(action: {}) {
                Text("Place a bid")
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
            }
            .buttonStyle(.borderedProminent)
            .font(.system(size: 16, weight: .bold))
            .foregroundColor(.white)
            .tint(.black)
            .clipShape(Capsule())
            .padding(.vertical, 20)
        }

    }

}
