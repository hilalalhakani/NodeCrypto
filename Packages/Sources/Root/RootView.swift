import CreateFeature
import Foundation
import HomeFeature
import NotificationsFeature
import ProfileFeature
import SearchFeature
import SwiftUI
import ComposableArchitecture
import TCAHelpers

@Reducer
public struct RootFeature: Sendable {
    // MARK: - Properties
    @Shared(.inMemory("addButtonVisibility")) var addButtonVisibility: Bool = true

    // MARK: - Initialization
    public init() {}

    // MARK: - State
    @ObservableState
    public struct State: Equatable, Sendable {
        public var profile: ProfileFeatureReducer.State = .init()
        public var notifications: NotificationFeature.State = .init()
        public var home: HomeFeature.State = .init()
        public var search: SearchFeatureReducer.State = .init()
        @Presents public var create: CreateFeature.State?
        public var showsProfileActionsList = false
        public var showsWobbleMenu = false
        public var selectedTab: Tab = .home

        public init(
            showsProfileActionsList: Bool = false,
            showsWobbleMenu: Bool = false,
            selectedTab: Tab = .home
        ) {
            self.showsProfileActionsList = showsProfileActionsList
            self.showsWobbleMenu = showsWobbleMenu
            self.selectedTab = selectedTab
        }
    }

    // MARK: - Action
    @CasePathable
    public enum Action: TCAFeatureAction, Sendable {
        case view(ViewAction)
        case `internal`(InternalAction)
        case delegate(DelegateAction)
    }

    @CasePathable
    public enum InternalAction: BindableAction, Sendable {
        case binding(BindingAction<State>)
        case create(PresentationAction<CreateFeature.Action>)
        case profile(ProfileFeatureReducer.Action)
        case notifications(NotificationFeature.Action)
        case search(SearchFeatureReducer.Action)
        case home(HomeFeature.Action)
    }

    @CasePathable
    public enum DelegateAction: Sendable {}

    @CasePathable
    public enum ViewAction: Sendable {
        case hideProfileActionsList
        case editButtonPressed
        case shareButtonPressed
        case removeButtonPressed
        case tabSelected(Tab)
        case addButtonPressed
        case hideWobbleMenu
        case createButtonTapped
        case createSingleButtonTapped
        case createMultipleButtonTapped
    }

    // MARK: - Reducer
    public var body: some ReducerOf<Self> {

        Scope(state: \.profile, action: \.internal.profile) {
            ProfileFeatureReducer()
        }

        Scope(state: \.search, action: \.internal.search) {
            SearchFeatureReducer()
        }

        Scope(state: \.notifications, action: \.internal.notifications) {
            NotificationFeature()
        }

        Scope(state: \.home, action: \.internal.home) {
            HomeFeature()
        }

        CombineReducers {

            BindingReducer(action: \.internal)

            NestedAction(\.view) { state, viewAction in
                switch viewAction {
                    case .hideProfileActionsList:
                        state.showsProfileActionsList = false
                        return .none

                    case .editButtonPressed:
                        state.showsProfileActionsList = false
                        $addButtonVisibility.withLock{ $0 = false }
                        return navigateToEditProfile(state: &state)

                    case .tabSelected(let tab):
                        if tab == .add {
                            return .send(.view(.addButtonPressed))
                        }
                        state.selectedTab = tab
                        return .none

                    case .addButtonPressed:
                        state.showsWobbleMenu.toggle()
                        return .none

                    case .createSingleButtonTapped:
                        state.create = .init(pickerMode: .single)
                        state.showsWobbleMenu = false
                        return .none

                    case .createMultipleButtonTapped:
                        state.create = .init(pickerMode: .multiple)
                        state.showsWobbleMenu = false
                        return .none

                    case .hideWobbleMenu:
                        state.showsWobbleMenu = false
                        return .none

                    default:
                        return .none
                }
            }

            NestedAction(\.internal) { state, internalAction in
                switch internalAction {
                    case .profile(.delegate(.menuButtonPressed)):
                        state.showsProfileActionsList = true
                        return .none

                    default:
                        return .none
                }
            }

        }
        .ifLet(\.$create, action: \.internal.create) {
            CreateFeature()
        }
    }

    private func navigateToEditProfile(state: inout State) -> Effect<Action> {
        return .send(.internal(.profile(.view(.navigateToEditProfile))))
    }
}

// MARK: - RootView
public struct RootView: View {
    // MARK: - Properties
    @Bindable var store: StoreOf<RootFeature>
    @SharedReader(.inMemory("addButtonVisibility")) var addButtonVisibility: Bool = true

    // MARK: - Initialization
    public init(store: StoreOf<RootFeature>) {
        self.store = store
    }

    // MARK: - Body
    public var body: some View {
        ZStack {
            TabView(selection: $store.selectedTab.sending(\.view.tabSelected)) {
                NavigationStack {
                    HomeView(
                        store: store.scope(state: \.home, action: \.internal.home)
                    )
                }
                .tabItem {
                    Image(Tab.home.systemImage, bundle: .module)
                        .renderingMode(.template)
                }
                .tag(Tab.home)
                #if os(iOS)
                .toolbarBackground(.white, for: .tabBar)
                #endif

                NavigationStack {
                    SearchView(
                        store: store.scope(
                            state: \.search,
                            action: \.internal.search
                        )
                    )
                }
                .tabItem {
                    Image(Tab.search.systemImage, bundle: .module)
                        .renderingMode(.template)
                }
                .tag(Tab.search)
                #if os(iOS)
                .toolbarBackground(.white, for: .tabBar)
                #endif

                Color.clear
                    .tabItem {
                        Color.clear
                            .frame(width: 30, height: 30)
                    }
                    .tag(Tab.add)

                NotificationsView(
                    store: store.scope(
                        state: \.notifications,
                        action: \.internal.notifications
                    )
                )
                .tabItem {
                    Image(Tab.notifications.systemImage, bundle: .module)
                        .renderingMode(.template)
                }
                .tag(Tab.notifications)
                #if os(iOS)
                .toolbarBackground(.white, for: .tabBar)
                #endif

                NavigationStack {
                    ProfileView(
                        store: store.scope(
                            state: \.profile,
                            action: \.internal.profile
                        )
                    )
                }
                .tabItem {
                    Image(Tab.profile.systemImage, bundle: .module)
                        .renderingMode(.template)
                }
                .tag(Tab.profile)
                #if os(iOS)
                .toolbarBackground(.white, for: .tabBar)
                .toolbar(addButtonVisibility ? .visible : .hidden, for: .tabBar)
                #endif
            }

            if store.showsWobbleMenu {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        store.send(.view(.hideWobbleMenu))
                    }
                    .ignoresSafeArea()
            }

            VStack {
                if store.showsWobbleMenu {
                    wobbleMenuView
                }

                if addButtonVisibility {
                    AddButton {
                        store.send(.view(.addButtonPressed))
                    }
                }
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .ignoresSafeArea(.keyboard)
        }
        .overlay {
            if store.showsProfileActionsList {
                blurView
            }
        }
        #if canImport(UIKit)
        .fullScreenCover(item: $store.scope(state: \.create, action: \.internal.create)) { store in
            CreateView(store: store)
        }
        #else
        .sheet(item: $store.scope(state: \.create, action: \.internal.create)) { store in
            CreateView(store: store)
        }
        #endif
    }

    // MARK: - View Components
    @ViewBuilder
    private var blurView: some View {
        Rectangle()
            .foregroundStyle(.clear)
            .background(BlurView())
            .ignoresSafeArea()
            .onTapGesture {
                store.send(
                    .view(.hideProfileActionsList),
                    animation: .easeIn(duration: 0.2)
                )
            }
            .overlay(alignment: .topTrailing) {
                ProfileActionsList(
                    editButtonPressed: {
                        store.send(.view(.editButtonPressed))
                    },
                    shareButtonPressed: {
                        store.send(.view(.shareButtonPressed))
                    },
                    replaceButtonPressed: {},
                    removeButtonPressed: {
                        store.send(.view(.removeButtonPressed))
                    }
                )
            }
    }

    @ViewBuilder
    private var wobbleMenuView: some View {
        Image("WobbleMenu", bundle: .module)
            .frame(width: 180, height: 150)
            .scaledToFill()
            .transition(.opacity.combined(with: .scale))
            .overlay {
                VStack(spacing: 30) {
                    Button(action: {
                        store.send(.view(.createSingleButtonTapped))
                    }) {
                        Text("Single", bundle: .module)
                            .foregroundStyle(Color.white)
                            .font(.system(size: 16, weight: .bold))
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                    Divider()
                        .background(Color.white.opacity(0.3))

                    Button(action: {
                        store.send(.view(.createMultipleButtonTapped))
                    }) {
                        Text("Multiple", bundle: .module)
                            .foregroundStyle(Color.white)
                            .font(.system(size: 16, weight: .bold))
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .padding(.bottom, 30)
                .padding(.horizontal, 20)
            }
            .animation(
                .spring(response: 0.3, dampingFraction: 0.8),
                value: store.showsWobbleMenu
            )
    }
}

// MARK: - Cross-platform blur view

#if os(iOS)
struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style = .extraLight

    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}
#elseif os(macOS)
struct BlurView: NSViewRepresentable {
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.blendingMode = .withinWindow
        view.state = .active
        view.material = .sidebar // closest match to UIBlurEffect.extraLight on iOS
        return view
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {}
}
#endif

// MARK: - Preview
#Preview {
    RootView(
        store: .init(
            initialState: .init(),
            reducer: { RootFeature() }
        )
    )
}
