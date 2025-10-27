import APIClient
import Dependencies
import Keychain
import SharedModels
import SwiftUI
import SharedViews
import ComposableArchitecture
import TCAHelpers
import StyleGuide

@Reducer
public struct ProfileReducer: Sendable {
    @Dependency(\.openURL) var openURL
    @Dependency(\.apiClient.profile) var profileAPI
    @Shared(.user) var user
    @Shared(.inMemory("addButtonVisibility")) var addButtonVisibility: Bool = true

    public init() {}

    //MARK: State
    @ObservableState
    public struct State: Equatable, Sendable {
        public var nfts: IdentifiedArrayOf<NFT> = []
        public var likedNfts: IdentifiedArrayOf<NFT> = []
        public var createdNfts: IdentifiedArrayOf<NFT> = []
        public var aboutMeItems: IdentifiedArrayOf<AboutMeItem> = []
        public var isLoading = true
        public var selectedTitle: String = "On sale"
        public var titles = ["On sale", "Created", "About me", "Liked"]
        @Presents var editProfile: EditProfile.State? = nil
        public init() {}

        public init(
            nfts: [NFT],
            aboutMeItems: [AboutMeItem],
            isLoading: Bool,
            selectedTitle: String
        ) {
            self.isLoading = isLoading
            self.nfts = .init(uniqueElements: nfts)
            self.aboutMeItems = .init(uniqueElements: aboutMeItems)
            self.selectedTitle = selectedTitle
        }

    }

    //MARK: Action
    @CasePathable
    public enum Action: TCAFeatureAction, Sendable {
        case view(ViewAction)
        case `internal`(InternalAction)
        case delegate(DelegateAction)
    }

    //MARK: Internal Actions
    @CasePathable
    public enum InternalAction: Sendable {
        case onGetNFTResponse(Result<[NFT], Error>)
        case onGetCreatedNFTResponse(Result<[NFT], Error>)
        case onGetLikedNFTResponse(Result<[NFT], Error>)
        case onGetAboutItemsResponse(Result<[AboutMeItem], Error>)
        case onSelectedTitleChange(String)
        case editProfile(PresentationAction<EditProfile.Action>)
        case dismissEditProfile
    }

    //MARK: Delegate Actions
    @CasePathable
    public enum DelegateAction: Sendable {
         case menuButtonPressed
    }
    @CasePathable
    public enum ViewAction: Sendable {
        case onAppear
        case openURL(SocialAccount)
        case logout
        case menuButtonPressed
        case navigateToEditProfile
    }

    public var body: some ReducerOf<Self> {
        CombineReducers {
            //MARK: Internal Action Handler
            NestedAction(\.internal) { state, action in
                switch action {
                    case .onGetNFTResponse(.success(let nfts)):
                        state.nfts = .init(uniqueElements: nfts)
                        state.isLoading = false
                        return .none
                        
                    case .onGetNFTResponse(.failure):
                        state.isLoading = false
                        return .none
                        
                    case .onGetAboutItemsResponse(.success(let items)):
                        state.aboutMeItems = .init(uniqueElements: items)
                        return .none
                        
                    case .onGetLikedNFTResponse(.success(let items)):
                        state.likedNfts = .init(uniqueElements: items)
                        return .none
                        
                    case .onGetCreatedNFTResponse(.success(let items)):
                        state.createdNfts = .init(uniqueElements: items)
                        return .none
                        
                    case .onGetAboutItemsResponse(.failure):
                        return .none
                        
                    case .onGetLikedNFTResponse(.failure):
                        return .none
                        
                    case .onGetCreatedNFTResponse(.failure):
                        return .none
                        
                    case .onSelectedTitleChange(let newValue):
                        state.selectedTitle = newValue
                        return .none
                        
                    case .dismissEditProfile:
                        $addButtonVisibility.withLock { $0 = true}
                        state.editProfile = nil
                        return .none
                        
                    case .editProfile(.presented(.delegate(.didTapBack))):
                        return .send(.internal(.dismissEditProfile))
                        
                    case .editProfile:
                        return .none
                }
            }

            //MARK: View Action Handler
            NestedAction(\.view) { state, action in
                switch action {
                    case .onAppear:
                        return .run { send in
                            
                            await withThrowingTaskGroup(of: Void.self) { group in
                                group.addTask {
                                    await send(
                                        .internal(
                                            .onGetNFTResponse(
                                                .init(catching: {
                                                    try await profileAPI.getSavedNFT()
                                                })
                                            )
                                        )
                                    )
                                }
                                group.addTask {
                                    await send(
                                        .internal(
                                            .onGetAboutItemsResponse(
                                                .init(catching: {
                                                    try await profileAPI.getUserInfo()
                                                })
                                            )
                                        )
                                    )
                                }
                                
                                group.addTask {
                                    await send(
                                        .internal(
                                            .onGetLikedNFTResponse(
                                                .init(catching: {
                                                    try await profileAPI.getLikedNFT()
                                                })
                                            )
                                        )
                                    )
                                }
                                
                                group.addTask {
                                    await send(
                                        .internal(
                                            .onGetCreatedNFTResponse(
                                                .init(catching: {
                                                    try await profileAPI.getCreatedNFT()
                                                })
                                            )
                                        )
                                    )
                                }
                            }
                        }
                    case .logout:
                        $user.withLock({ $0 = nil })
                        return .none
                    case .openURL(_):
                        return .run { send in
                            if let url = URL(string: "https://google.com") {
                                await self.openURL(url)
                            }
                        }
                        
                    case .menuButtonPressed:
                        return .send(.delegate(.menuButtonPressed))
                        
                    case .navigateToEditProfile:
                        if let user = user {
                            state.editProfile = .init(user: user)
                        }
                        return .none
                }
            }
        }
        .ifLet(\.$editProfile, action: \.internal.editProfile) {
            EditProfile()
        }
    }
}

//MARK: ProfileView
public struct ProfileView: View {
    @Bindable var store: StoreOf<ProfileReducer>
    @Shared(.user) var user
    let gridLayout: [GridItem] = [
        GridItem(.flexible(), spacing: 8), GridItem(.flexible(), spacing: 8)
    ]

    public init(store: StoreOf<ProfileReducer>) {
        self.store = store
    }

    public var body: some View {
            ZStack {
                Image(ImageResource.profileBackground)
                    .resizable()
                    .ignoresSafeArea()

                VStack(spacing: 5) {
                    profileImageView
                    profileDetailsView
                    socialButtonsView
                    Spacer().frame(height: 24)
                    selectedView
                }
                .padding(.horizontal, 24)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)

                ExpandingMenuButton(
                    selectedTitle: $store.selectedTitle.sending(\.internal.onSelectedTitleChange),
                    titles: store.titles
                )
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .task {
                store.send(.view(.onAppear))
            }
            #if os(iOS)
                .toolbar {
                    toolbarContent
                }
            #endif
                .navigationDestination(
                    item: $store.scope(state: \.editProfile, action: \.internal.editProfile)
                ) { store in
                    EditProfileView(store: store)
                        .toolbar(.hidden, for: .tabBar)
                }
    }

    @ViewBuilder
    private var profileImageView: some View {
        if let profileImage = user?.profileImage,
           let url = URL(string: profileImage) {
            SharedViews.RemoteImageView(url: url)
                .frame(width: 100, height: 100)
                .clipShape(.circle)
                .onTapGesture {
                    store.send(.view(.logout))
                }
        }
    }

    @ViewBuilder
    private var profileDetailsView: some View {
        if let email = user?.email,
            let fullName = user?.fullName,
            let description = user?.profileDescription
        {
            VStack(spacing: 12) {
                Text(fullName)
                    .foregroundStyle(Color.neutral2)
                    .font(.custom(FontName.poppinsBold.rawValue, size: 24))

                HStack(spacing: 12) {
                    Text(email)
                        .foregroundStyle(Color.primary1)
                        .font(.custom(FontName.poppinsRegular.rawValue, size: 14))

                    walletAddressView
                }

                Text(description)
                    .font(.custom(FontName.poppinsRegular.rawValue, size: 12))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.neutral4)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
            }
        }
    }

    @ViewBuilder
    private var walletAddressView: some View {
        if let walletAddress = user?.walletAddress {
            Text(walletAddress)
                .font(.custom(FontName.poppinsRegular.rawValue, size: 14))
                .padding(5)
                .frame(width: 100)
                .lineLimit(1)
                .truncationMode(.middle)
                .background(
                    Rectangle()
                        .foregroundStyle(Color.neutral6)
                        .clipShape(Capsule())
                )
        }
    }

    @ViewBuilder
    private var socialButtonsView: some View {
        HStack(spacing: 24) {
            SocialButton(action: {
                 store.send(.view(.openURL(.twitter)))
            }, imageResource: .twitter)
            SocialButton(
                action: {
                  store.send(.view(.openURL(.instagram)))
                },
                imageResource: .instagram
            )
            SocialButton(
                action: {
                   store.send(.view(.openURL(.facebook)))
                },
                imageResource: .facebook
            )
        }
    }

    @ViewBuilder
    private var selectedView: some View {
        Group {
            switch store.selectedTitle {
                case "On sale":
                    onSaleView
                case "About me":
                    aboutMeView
                case "Created":
                    createdView
                case "Liked":
                    likedView
                default:
                    EmptyView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    @ViewBuilder
    private var createdView: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(store.createdNfts) { nft in
                        NFTItemView(nft: nft)
                    }
            }
        }
        .transition(.opacity.animation(.easeInOut))
    }

    @ViewBuilder
    private var likedView: some View {
        ScrollView {
            LazyVStack(spacing: 20) {

                ForEach(store.likedNfts) { nft in
                        NFTItemView(nft: nft)
                    }
            }
        }
        .transition(.opacity.animation(.easeInOut))
    }

    @ViewBuilder
    private var aboutMeView: some View {
        let gridLayout: [GridItem] = [
            GridItem(.flexible(), spacing: 8), GridItem(.flexible(), spacing: 8),
        ]
        let aboutMeColors: [Color] = [.primary4, .primary2, .primary1, .secondary1]

        ScrollView {
            LazyVGrid(columns: gridLayout) {
                ForEach(Array(store.aboutMeItems.enumerated()), id: \.element) {
                    index,
                    aboutMeItem in
                    AboutMeItemView(
                        color: aboutMeColors[safe: index] ?? .primary1,
                        iconName: aboutMeItem.iconName,
                        title: aboutMeItem.title,
                        count: aboutMeItem.count
                    )
                }
            }
        }
        .transition(.opacity.animation(.easeInOut))
    }

#if os(iOS)
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
            ToolbarItem(placement: .topBarTrailing) {
                Button(
                    action: {
                     store.send(.view(.menuButtonPressed), animation: .easeIn(duration: 0.3))
                    },
                    label: {
                        Image(systemName: "ellipsis")
                            .foregroundColor(Color.neutral8)
                            .frame(width: 32, height: 32)
                    }
                )
            }
    }
#endif

    @ViewBuilder
    var onSaleView: some View {
        ScrollView {
            LazyVGrid(columns: gridLayout) {
                if !store.isLoading {
                    ForEach(store.nfts) { nft in
                        if let url = URL(string: nft.imageURL) {
                            SharedViews.RemoteImageView(url: url)
                                .frame(height: 168)
                                .cornerRadius(8)
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .circular))
                                .transition(.opacity)
                                .overlay(alignment: .topLeading) {
                                    if nft.isNew {
                                        Text("New")
                                            .padding(8)
                                            .foregroundStyle(Color.neutral8)
                                            .font(.custom(FontName.dmSansBold.rawValue, size: 14))
                                            .background(
                                                Color.primary4
                                            )
                                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .circular))
                                            .padding(8)
                                    }
                                }
                                .overlay(alignment: .center) {
                                    if nft.isVideo {
                                        Image(ImageResource.circleButton)
                                    }
                                }
                        }
                    }
                }
                else {
                    ForEach(0...30, id: \.self) { _ in
                        RoundedRectangle(cornerRadius: 16, style: .circular)
                            .frame(height: 168)
                            .foregroundStyle(.black.opacity(0.1))
                            .transition(.opacity)
                    }
                }
            }
        }
        .transition(.opacity.animation(.easeInOut))
    }
}

extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

#Preview {
    NavigationStack {
        ProfileView(store: .init(initialState: .init(), reducer: { ProfileReducer() }))
    }
}
