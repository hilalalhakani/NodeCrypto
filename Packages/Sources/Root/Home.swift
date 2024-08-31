import Foundation
import NodeCryptoCore
import ProfileFeature
import SwiftUI

@Reducer
public struct RootViewReducer {
    public init() {}
    @ObservableState
    public struct State: Equatable {
        var profile: ProfileCoordinatorReducer.State
        var showsProfileActionsList = false

        public init(user: User, showsProfileActionsList: Bool = false) {
            self.showsProfileActionsList = showsProfileActionsList
            profile = .init(user: user)
        }
    }

    public enum Action {
        case profile(ProfileCoordinatorReducer.Action)
        case hideProfileActionsList
        case editButtonPressed
        case shareButtonPressed
        case removeButtonPressed
    }

    public var body: some ReducerOf<Self> {
        Scope(state: \.profile, action: \.profile) {
            ProfileCoordinatorReducer()
        }

        Reduce { state, action in
            switch action {
                case .hideProfileActionsList:
                    state.showsProfileActionsList = false
                    return .none
                case .profile(.menuButtonPressed):
                    state.showsProfileActionsList = true
                    return .none
                case .editButtonPressed:
                    state.showsProfileActionsList = false
                    return navigateToEditProfile(state: &state)
                default:
                    return .none
            }
        }
    }

    func navigateToEditProfile(state: inout State) -> Effect<Action> {
        ProfileCoordinatorReducer()
            .reduce(into: &state.profile, action: .navigateToEditScreen)
            .map { _ in Action.editButtonPressed }
    }
}

public struct RootView: View {
    @State private var activeTab: Tab
    @Namespace var animation
    let store: StoreOf<RootViewReducer>
    @Shared(.inMemory("isTabBarVisible")) var isTabBarVisible = true

    public init(store: StoreOf<RootViewReducer>, tab: Tab = Tab.home) {
        self.activeTab = tab
        self.store = store
    }

    public var body: some View {
        WithPerceptionTracking {
            VStack(spacing: 0) {
                tabBarViews()
                if isTabBarVisible {
                    customTabBar()
                }
            }
            .overlay {
                if store.showsProfileActionsList {
                    blurView
                }
            }
        }
    }

    @ViewBuilder
    func customTabBar() -> some View {
        HStack(spacing: 0) {
            makeTabItem(.home)
            makeTabItem(.search)
            AddButton {}
            makeTabItem(.notifications)
            makeTabItem(.profile)
        }
        .animation(.easeIn, value: activeTab)
    }

    @ViewBuilder
    func tabBarViews() -> some View {
        ZStack {
            Group {
                Color.red
                    .isHidden(activeTab != .home)

                Text("Services", bundle: .module)
                    .isHidden(activeTab != .search)

                Text("Notifications", bundle: .module)
                    .isHidden(activeTab != .notifications)

                ProfileCoordinatorView(
                    store: store.scope(state: \.profile, action: \.profile)
                )
                .isHidden(activeTab != .profile)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    @ViewBuilder
    var blurView: some View {
        Rectangle()
            .foregroundStyle(.clear)
            .background(BlurView(style: .extraLight))
            .ignoresSafeArea()
            .onTapGesture {
                store.send(.hideProfileActionsList, animation: .easeIn(duration: 0.2))
            }
            .overlay(alignment: .topTrailing) {
                ProfileActionsList(
                    editButtonPressed: { store.send(.editButtonPressed) },
                    shareButtonPressed: {},
                    replaceButtonPressed: {},
                    removeButtonPressed: {}
                )
            }
    }

    func makeTabItem(_ tab: Tab) -> some View {
        TabItem(
            tab: tab,
            activeTab: $activeTab
        )
    }
}

struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}

#Preview {
    RootView(
        store: .init(
            initialState: .init(user: .mock1),
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
