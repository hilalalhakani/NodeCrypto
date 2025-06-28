import Foundation
import HomeFeature
import NodeCryptoCore
import NotificationsFeature
import ProfileFeature
import SearchFeature
import SwiftUI

@Reducer
public struct RootViewReducer: Sendable {
    public init() {}

    @ObservableState
    public struct State: Equatable, Sendable {
        var profile: ProfileCoordinatorReducer.State = .init()
        var notifications: NotificationReducer.State = .init()
        var home: HomeCoordinatorReducer.State = .init()
        var search: SearchReducer.State = .init()
        var showsProfileActionsList = false
        var showsWobbleMenu = false
        var selectedTab: Tab = .home

        public init(showsProfileActionsList: Bool = false) {
            self.showsProfileActionsList = showsProfileActionsList
        }
    }

    @CasePathable
    public enum Action: TCAFeatureAction, Sendable {
        case view(ViewAction)
        case `internal`(InternalAction)
        case delegate(DelegateAction)
    }

    @CasePathable
    public enum InternalAction: BindableAction, Sendable {
        case binding(BindingAction<State>)
        case profile(ProfileCoordinatorReducer.Action)
        case notifications(NotificationReducer.Action)
        case search(SearchReducer.Action)
        case home(HomeCoordinatorReducer.Action)
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
    }

    public var body: some ReducerOf<Self> {
        BindingReducer(action: \.internal)

        Scope(state: \.profile, action: \.internal.profile) {
            ProfileCoordinatorReducer()
        }

        Scope(state: \.search, action: \.internal.search) {
            SearchReducer()
        }

        Scope(state: \.notifications, action: \.internal.notifications) {
            NotificationReducer()
        }

        Scope(state: \.home, action: \.internal.home) {
            HomeCoordinatorReducer()
        }

        NestedAction(\.view) { state, viewAction in
            switch viewAction {
            case .hideProfileActionsList:
                state.showsProfileActionsList = false
                return .none

            case .editButtonPressed:
                state.showsProfileActionsList = false
                return navigateToEditProfile(state: &state)

            case .tabSelected(let tab):
                // Prevent the add tab from being selected, trigger add action instead
                if tab == .add {
                    return .send(.view(.addButtonPressed))
                }
                state.selectedTab = tab
                return .none

            case .addButtonPressed:
                state.showsWobbleMenu.toggle()
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
            case .profile(.menuButtonPressed):
                state.showsProfileActionsList = true
                return .none

            default:
                return .none
            }
        }
    }

    private func navigateToEditProfile(state: inout State) -> Effect<Action> {
        ProfileCoordinatorReducer()
            .reduce(into: &state.profile, action: .navigateToEditScreen)
            .map { _ in Action.view(.editButtonPressed) }
    }
}

public struct RootView: View {
    @Bindable var store: StoreOf<RootViewReducer>
    @Shared(.isTabBarVisible) var isTabBarVisible

    public init(store: StoreOf<RootViewReducer>) {
        self.store = store
    }

    public var body: some View {
        ZStack {
            TabView(selection: $store.selectedTab.sending(\.view.tabSelected)) {
                HomeCoordinatorView(
                    store: store.scope(state: \.home, action: \.internal.home)
                )
                .tabItem {
                    Image(Tab.home.systemImage, bundle: .module)
                        .renderingMode(.template)
                }
                .tag(Tab.home)
                .toolbarBackground(.white, for: .tabBar)

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
                .toolbarBackground(.white, for: .tabBar)

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
                .toolbarBackground(.white, for: .tabBar)

                ProfileCoordinatorView(
                    store: store.scope(
                        state: \.profile,
                        action: \.internal.profile
                    )
                )
                .tabItem {
                    Image(Tab.profile.systemImage, bundle: .module)
                        .renderingMode(.template)
                }
                .tag(Tab.profile)
                .toolbarBackground(.white, for: .tabBar)
            }

            if isTabBarVisible {
                VStack {
                    if store.showsWobbleMenu {
                        wobbleMenuView
                    }

                    AddButton {
                        store.send(.view(.addButtonPressed))
                    }

                }
                .frame(maxHeight: .infinity, alignment: .bottom)
            }
        }
        .overlay {
            if store.showsProfileActionsList {
                blurView
            }
        }
        .overlay {
            if store.showsWobbleMenu {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        store.send(.view(.hideWobbleMenu))
                    }
            }
        }
    }

    @ViewBuilder
    private var blurView: some View {
        Rectangle()
            .foregroundStyle(.clear)
            #if os(iOS)
                .background(BlurView(style: .extraLight))
            #endif
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
        Image(.wobbleMenu)
            .frame(width: 180, height: 150)
            .scaledToFill()
            .transition(.opacity.combined(with: .scale))
            .overlay {
                VStack(spacing: 30) {
                    Button(action: {
                        store.send(.view(.hideWobbleMenu))
                    }) {
                        Text("Single")
                            .foregroundStyle(Color.white)
                            .font(.system(size: 16, weight: .bold))
                    }

                    Divider()
                        .background(Color.white.opacity(0.3))

                    Button(action: {
                        store.send(.view(.hideWobbleMenu))
                    }) {
                        Text("Multiple")
                            .foregroundStyle(Color.white)
                            .font(.system(size: 16, weight: .bold))
                    }
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

#if os(iOS)
    struct BlurView: UIViewRepresentable {
        var style: UIBlurEffect.Style

        func makeUIView(context: Context) -> UIVisualEffectView {
            return UIVisualEffectView(effect: UIBlurEffect(style: style))
        }

        func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
            uiView.effect = UIBlurEffect(style: style)
        }
    }
#endif

#Preview {
    RootView(
        store: .init(
            initialState: .init(),
            reducer: { RootViewReducer() }
        )
    )
}
