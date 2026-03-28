import APIClient
import StyleGuide
import AVFoundation
import AVKit
import Dependencies
import SwiftUI
import ComposableArchitecture
import SharedModels
import TCAHelpers
import SharedViews

@Reducer
public struct HomeFeature: Sendable {
    @Dependency(\.apiClient.home) var api

    // MARK: - Initialization
    public init() {}

    // MARK: - State
    @ObservableState
    public struct State: Equatable, Sendable {

        @Presents public var allCreatorsState: AllCreatorsReducer.State?
        public var creators: IdentifiedArrayOf<Creator> = []
        public var errorMessage: String?
        public var isLoading = true
        public var nfts: IdentifiedArrayOf<NFTItem> = []
        @Presents public var playerViewReducerState: PlayerViewReducer.State?

        public init() {}
        
        public init(
            allCreatorsState: AllCreatorsReducer.State? = nil,
            creators: [Creator] = [],
            errorMessage: String? = nil,
            isLoading: Bool = true,
            nfts: [NFTItem] = [],
            playerViewReducerState: PlayerViewReducer.State? = nil
        ) {
            self.allCreatorsState = allCreatorsState
            self.creators = .init(uniqueElements: creators)
            self.errorMessage = errorMessage
            self.isLoading = isLoading
            self.nfts = .init(uniqueElements: nfts)
            self.playerViewReducerState = playerViewReducerState
        }
    }

    // MARK: - Action
    @CasePathable
    public enum Action: Sendable, TCAFeatureAction {
        case delegate(DelegateAction)
        case `internal`(InternalAction)
        case view(ViewAction)
    }

    @CasePathable
    public enum DelegateAction: Sendable {}

    @CasePathable
    public enum InternalAction: Sendable {
        case allCreatorsAction(PresentationAction<AllCreatorsReducer.Action>)
        case creatorsResponse(Result<[Creator], any Error>)
        case nftsResponse(Result<[NFTItem], any Error>)
        case playerViewAction(PresentationAction<PlayerViewReducer.Action>)
    }

    @CasePathable
    public enum ViewAction: Sendable {
        case allCreatorsButtonTapped
        case nftTapped(NFTItem)
        case retryButtonTapped
        case task
    }

    // MARK: - Reducer
    public var body: some Reducer<State, Action> {

        CombineReducers {
            // MARK: Internal Actions
            NestedAction(\.internal) { state, action in

                switch action {
                case .allCreatorsAction:
                    return .none

                case .creatorsResponse(.failure):
                    state.errorMessage = "Failed to load items"
                    state.isLoading = false
                    return .none

                case let .creatorsResponse(.success(items)):
                    state.creators = .init(uniqueElements: items)
                    return .none

                case .nftsResponse(.failure):
                    state.errorMessage = "Failed to load items"
                    state.isLoading = false
                    return .none

                case let .nftsResponse(.success(items)):
                    state.nfts = .init(uniqueElements: items)
                    state.isLoading = false
                    return .none

                case .playerViewAction(.presented(.delegate(.playerClosed))):
                    state.playerViewReducerState = nil
                    return .none

                case .playerViewAction:
                    return .none
                }
            }

            // MARK: View Actions
            NestedAction(\.view) { state, action in

                switch action {

                case .allCreatorsButtonTapped:
                    state.allCreatorsState = .init(
                        creators: state.creators.elements
                    )
                    return .none

                case let .nftTapped(nftItem):
                    state.playerViewReducerState = .init(nft: nftItem)
                    return .none

                case .retryButtonTapped, .task:
                    guard state.nfts.isEmpty && state.creators.isEmpty else { return .none }
                    state.errorMessage = nil
                    state.isLoading = true
                    return .run { send in
                        do {
                            async let creators = try await api.getCreators()
                            async let nfts = try await api.getNFTS()

                            let (fetchedCreators, fetchedNFTs) = try await (creators, nfts)

                            await send(.internal(.creatorsResponse(.success(fetchedCreators))))
                            await send(.internal(.nftsResponse(.success(fetchedNFTs))))
                        } catch {
                            await send(.internal(.creatorsResponse(.failure(error))))
                        }
                    }

                }
            }
        }
        .ifLet(\.$allCreatorsState, action: \.internal.allCreatorsAction) {
            AllCreatorsReducer()
        }
        .ifLet(\.$playerViewReducerState, action: \.internal.playerViewAction) {
            PlayerViewReducer()
        }
    }
}

public struct HomeView: View {
    // MARK: - Properties
    @Bindable var store: StoreOf<HomeFeature>

    // MARK: - Initialization
    public init(store: StoreOf<HomeFeature>) {
        self.store = store
    }

    // MARK: - Body
    public var body: some View {
        Group {
            if let errorMessage = store.errorMessage {
                errorView(message: errorMessage)
            } else {
                mainContentView
            }
        }
        .transition(.opacity)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .animation(.easeInOut(duration: 0.3), value: store.errorMessage)
        .fullScreenCover(
            item: $store.scope(
                state: \.playerViewReducerState,
                action: \.internal.playerViewAction
            )
        ) { store in
            PlayerView(store: store)
        }
        .navigationDestination(
            item: $store.scope(state: \.allCreatorsState, action: \.internal.allCreatorsAction),
            destination: AllCreatorsView.init
        )
        .task {
            store.send(.view(.task))
        }
    }

    // MARK: - View Components
    private var mainContentView: some View {
        VStack(alignment: .leading, spacing: 0) {
            headerView
            bestSellersScrollView
            featuredItemsScrollView
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var headerView: some View {
        HStack {
            Text("Best sellers")
                .font(Font(FontName.dmSansBold, size: 32))
                .foregroundStyle(Color.neutral2)
                .frame(maxWidth: .infinity, alignment: .leading)

            Button(action: {
                store.send(.view(.allCreatorsButtonTapped))
            }) {
                Image(systemName: "arrow.right")
                    .foregroundColor(.gray)
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 8)
        .redacted(reason: store.isLoading ? .placeholder : [])
    }
    
    private func errorView(message: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle")
                .foregroundColor(.orange)
                .font(.title2)
            
            Text(message)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button("Retry") {
                store.send(.view(.retryButtonTapped))
            }
            .buttonStyle(.bordered)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var bestSellersScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 16) {
                if !store.isLoading {
                    ForEach(store.creators) { creator in
                        SellerItemView(creator: creator)
                    }
                } else {
                    ForEach(0..<5, id: \.self) { _ in
                        SellerItemSkeletonView()
                    }
                }
            }
            .transition(.opacity)
            .padding(.horizontal, 20)
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
        .animation(.easeInOut(duration: 0.4), value: store.isLoading)
        .frame(height: 100)
        .padding(.bottom, 12)
    }
    
    // MARK: - Subviews
    private struct SellerItemSkeletonView: View {
        var body: some View {
            HStack(spacing: 10) {
                Circle()
                    .foregroundStyle(.gray.opacity(0.2))
                    .frame(width: 56, height: 56)

                VStack(alignment: .leading, spacing: 8) {
                    Rectangle()
                        .foregroundStyle(.gray.opacity(0.2))
                        .frame(width: 80, height: 12)

                    Rectangle()
                        .foregroundStyle(.gray.opacity(0.2))
                        .frame(width: 50, height: 12)
                }
            }
        }
    }

    private var featuredItemsScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 0) {
                Group {
                    if !store.isLoading {
                        ForEach(store.nfts) { nft in
                            FeaturedItem(nft: nft)
                                .onTapGesture {
                                    store.send(.view(.nftTapped(nft)))
                                }
                        }
                    } else {
                        ForEach(0..<3, id: \.self) { _ in
                            FeaturedItemSkeletonView()
                        }
                    }
                }
                .padding(.horizontal, 20)
                .frame(maxWidth: .infinity)
                .containerRelativeFrame(.horizontal)
                .transition(.opacity)
            }
            .frame(maxWidth: .infinity)
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.paging)
        .animation(.easeInOut(duration: 0.4), value: store.isLoading)
    }
    
    private struct FeaturedItemSkeletonView: View {
        var body: some View {
            RoundedRectangle(cornerRadius: 24)
                .foregroundStyle(.gray.opacity(0.2))
        }
    }

    // MARK: - FeaturedItem
    struct FeaturedItem: View {
        let nft: NFTItem
        
        var body: some View {
            ZStack {
                if let url = URL(string: nft.image) {
                    SharedViews.RemoteImageView(url: url)
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .accessibilityLabel("NFT image: \(nft.name)")
                } else {
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color.gray.opacity(0.3))
                        .overlay(
                            Image(systemName: "photo")
                                .foregroundColor(.gray)
                                .font(.largeTitle)
                        )
                }
                
                VStack(spacing: 0) {
                    itemInfoView
                    Spacer()
                    playButton
                    Spacer()
                    placeBidButton
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
                                SharedViews.RemoteImageView(url: url)
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
            Button(action: {
                // Play action is handled by parent tap gesture
            }) {
                Circle()
                    .foregroundColor(.white)
                    .frame(height: 48)
                    .shadow(radius: 4)
                    .overlay {
                        Image(systemName: "play.fill")
                            .foregroundColor(.gray)
                            .font(.title2)
                    }
            }
        }

        private var placeBidButton: some View {
            Button(action: {
                // TODO: Implement bid action
            }) {
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
