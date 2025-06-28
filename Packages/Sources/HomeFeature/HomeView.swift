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
        @Presents public var playerViewReducerState: PlayerViewReducer.State? =
            nil
        public var nfts: IdentifiedArrayOf<NFTItem> = IdentifiedArrayOf(
            uniqueElements: [])
        public var creators: IdentifiedArrayOf<Creator> = IdentifiedArrayOf(
            uniqueElements: [])
        public var isLoading = true
        public init() {}
        public init(playerViewReducerState: PlayerViewReducer.State) {
            self.playerViewReducerState = playerViewReducerState
        }

        public init(nfts: [NFTItem], creators: [Creator], isLoading: Bool) {
            self.nfts = .init(uniqueElements: nfts)
            self.creators = .init(uniqueElements: creators)
            self.isLoading = isLoading
        }

    }

    @CasePathable
    public enum Action: Sendable, TCAFeatureAction {
        case view(ViewAction)
        case `internal`(InternalAction)
        case delegate(DelegateAction)
    }

    @CasePathable
    public enum ViewAction: Sendable {
        case onAppear
        case tappedNFT(NFTItem)
        case navigateToAllCreatorsButtonPressed
    }

    @CasePathable
    public enum InternalAction: Sendable {
        case onCreatorsResponse([Creator])
        case onNFTSResponse([NFTItem])
        case removePlaceHolder
        case playerViewAction(PresentationAction<PlayerViewReducer.Action>)
    }

    @CasePathable
    public enum DelegateAction: Sendable {
        case navigateToAllCreators(creators: [Creator])
    }

    public var body: some Reducer<State, Action> {

        CombineReducers {

            //MARK: Internal Actions

            NestedAction(\.internal) { state, action in

                switch action {
                case .playerViewAction(.presented(.delegate(.playerClosed))):
                    state.playerViewReducerState = nil
                    return .none

                case .playerViewAction:
                    return .none

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

            //MARK: View Actions
            NestedAction(\.view) { state, action in

                switch action {

                case .tappedNFT(let nFTItem):
                    state.playerViewReducerState = .init(nft: nFTItem)
                    return .none

                case .onAppear:
                    return .run(priority: .background) { send in
                        async let creators = try api.getCreators()
                        async let nfts = try api.getNFTS()
                        try? await send(.internal(.onCreatorsResponse(creators)))
                        try? await send(.internal(.onNFTSResponse(nfts)))
                        await send(.internal(.removePlaceHolder))
                    }

                case .navigateToAllCreatorsButtonPressed:
                    return .send(
                        .delegate(
                            .navigateToAllCreators(
                                creators: state.creators.elements
                            )
                        )
                    )
                }
            }
        }
        .ifLet(\.$playerViewReducerState, action: \.internal.playerViewAction) {
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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .fullScreenCover(
            item: $store.scope(
                state: \.playerViewReducerState,
                action: \.internal.playerViewAction
            )
        ) { store in
            PlayerView(store: store)
        }
        .task {
            store.send(.view(.onAppear))
        }
    }

    // MARK: - Subviews
    private var headerView: some View {
        HStack {
            Text("Best sellers")
                .font(Font(FontName.dmSansBold, size: 32))
                .foregroundStyle(Color.neutral2)
                .frame(maxWidth: .infinity, alignment: .leading)

            Button(action: {
                store.send(.view(.navigateToAllCreatorsButtonPressed))
            }) {
                Image(systemName: "arrow.right")
                    .foregroundColor(.gray)
            }
        }
        .padding(.horizontal, 24)
        .redacted(reason: store.isLoading ? .placeholder : [])
    }

    private var bestSellersScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                if !store.isLoading {
                    ForEach(store.creators) { creator in
                        SellerItemView(creator: creator)
                    }
                    .transition(.opacity)
                } else {
                    ForEach(0...10, id: \.self) { _ in
                        HStack(spacing: 10) {
                            Circle()
                                .foregroundStyle(.gray.opacity(0.2))
                                .frame(width: 56, height: 56)

                            VStack(alignment: .leading) {
                                Rectangle()
                                    .foregroundStyle(.gray.opacity(0.2))
                                    .frame(width: 80, height: 12)

                                Rectangle()
                                    .foregroundStyle(.gray.opacity(0.2))
                                    .frame(width: 50, height: 12)

                            }

                        }
                    }
                    .transition(.opacity)
                }
            }
            .padding(.horizontal, 24)
            .animation(.easeInOut(duration: 0.4), value: store.isLoading)
        }
    }

    private var featuredItemsScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                Group {
                    if !store.isLoading {
                        ForEach(store.nfts) { nft in
                            FeaturedItem(nft: nft)
                                .onTapGesture {
                                    store.send(.view(.tappedNFT(nft)))
                                }
                        }
                    } else {
                        ForEach(0...10, id: \.self) { _ in
                            RoundedRectangle(cornerRadius: 24)
                                .foregroundStyle(.gray.opacity(0.2))
                        }
                    }
                }
                .padding(.horizontal, 24)
                .frame(maxWidth: .infinity)
                .containerRelativeFrame(.horizontal)
                .transition(.opacity)
            }
            .frame(maxWidth: .infinity)
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.paging)
        .padding(.vertical)
    }

    struct FeaturedItem: View {
        let nft: NFTItem
        var body: some View {
            if let url = URL(string: nft.image) {
                AsyncImageView(url: url)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .overlay(alignment: .top) {
                        VStack(spacing: 0) {
                            itemInfoView
                            Spacer()
                            playButton
                            Spacer()
                            placeBidButton
                        }
                    }
            }
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
                            if let url = URL(string: nft.creatorImage) {
                                AsyncImageView(url: url)
                                    .aspectRatio(contentMode: .fill)
                                    .clipShape(Circle())
                                    .frame(width: 20, height: 20)
                            }

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
