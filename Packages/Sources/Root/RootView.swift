import Foundation
import NodeCryptoCore
import ProfileFeature
import SwiftUI
import NotificationsFeature
import HomeFeature
import SearchFeature

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

        public init(showsProfileActionsList: Bool = false) {
            self.showsProfileActionsList = showsProfileActionsList
        }
    }

    @CasePathable
    public enum Action: TCAFeatureAction {
        case view(ViewAction)
        case `internal`(InternalAction)
        case delegate(DelegateAction)
    }

    @CasePathable
    public enum InternalAction: BindableAction {
        case binding(BindingAction<State>)
        case profile(ProfileCoordinatorReducer.Action)
        case notifications(NotificationReducer.Action)
        case search(SearchReducer.Action)
        case home(HomeCoordinatorReducer.Action)
    }

    @CasePathable
    public enum DelegateAction {}

    @CasePathable
    public enum ViewAction {
        case hideProfileActionsList
        case editButtonPressed
        case shareButtonPressed
        case removeButtonPressed
        case toggleWobbleMenu
        case hideWobbleMenu
    }

    public var body: some ReducerOf<Self> {
        CombineReducers {
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

                case .toggleWobbleMenu:
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
    }

    private func navigateToEditProfile(state: inout State) -> Effect<Action> {
        ProfileCoordinatorReducer()
            .reduce(into: &state.profile, action: .navigateToEditScreen)
            .map { _ in Action.view(.editButtonPressed) }
    }
}

public struct RootView: View {
    @State private var activeTab: Tab
    @Namespace var animation
    let store: StoreOf<RootViewReducer>
    @Shared(.isTabBarVisible) var isTabBarVisible

    public init(store: StoreOf<RootViewReducer>, tab: Tab = Tab.home) {
        self.activeTab = tab
        self.store = store
    }

    public var body: some View {
        VStack(spacing: 0) {
            tabBarViews()
            if isTabBarVisible {
                customTabBar()
            }
        }
        .ignoresSafeArea(.keyboard)
        .overlay {
            if store.showsProfileActionsList {
                blurView
            }
        }
    }

    @ViewBuilder
    private func wobbleMenuView() -> some View {
        VStack(spacing: 30) {
            Button(action: {}, label: {
                Text("Single")
                    .foregroundStyle(Color.neutral8)
                    .font(Font(FontName.dmSansBold, size: 16))
            })

            Divider()
                .background(Color.white.opacity(0.3))

            Button(action: {}) {
                Text("Multiple")
                    .foregroundStyle(Color.neutral8)
                    .font(Font(FontName.dmSansBold, size: 16))
            }
        }
            .padding(.bottom, 30)
            .frame(maxHeight: .infinity)
            .padding(.horizontal, 20)
        .background(
            Image(.wobbleMenu)
                .frame(width: 240, height: 216)
        )
        .frame(width: 240, height: 216)
        .transition(.opacity)
    }

    @ViewBuilder
    private func customTabBar() -> some View {
        HStack(spacing: 0) {
            makeTabItem(.home)
            makeTabItem(.search)
            AddButton {
                let nextAction: RootViewReducer.Action = store.showsWobbleMenu
                    ? .view(.hideWobbleMenu)
                    : .view(.toggleWobbleMenu)

                store.send(
                    nextAction,
                    animation: .spring(response: 0.3, dampingFraction: 0.8)
                )
            }
            .background(alignment: .bottom) {
                if store.showsWobbleMenu {
                    wobbleMenuView()
                }
            }
            makeTabItem(.notifications)
            makeTabItem(.profile)
        }
        .animation(.easeIn, value: activeTab)
    }

    @ViewBuilder
    private func tabBarViews() -> some View {
        ZStack {
            Group {
                HomeCoordinatorView(
                    store: store.scope(state: \.home, action: \.internal.home)
                )
                .isHidden(activeTab != .home)

                NavigationStack {
                    SearchView(
                        store: store.scope(state: \.search, action: \.internal.search)
                    )
                }
                .isHidden(activeTab != .search)

                NotificationsView(
                    store: store.scope(state: \.notifications, action: \.internal.notifications)
                )
                .isHidden(activeTab != .notifications)

                ProfileCoordinatorView(
                    store: store.scope(state: \.profile, action: \.internal.profile)
                )
                .isHidden(activeTab != .profile)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
                store.send(.view(.hideProfileActionsList), animation: .easeIn(duration: 0.2))
            }
            .overlay(alignment: .topTrailing) {
                ProfileActionsList(
                    editButtonPressed: { store.send(.view(.editButtonPressed)) },
                    shareButtonPressed: { store.send(.view(.shareButtonPressed)) },
                    replaceButtonPressed: {},
                    removeButtonPressed: { store.send(.view(.removeButtonPressed)) }
                )
            }
    }

    private func makeTabItem(_ tab: Tab) -> some View {
        TabItem(
            tab: tab,
            activeTab: $activeTab
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

extension View {
    @ViewBuilder func isHidden(_ hidden: Bool) -> some View {
        self
            .opacity(hidden ? 0 : 1)
            .disabled(hidden)
    }
}
