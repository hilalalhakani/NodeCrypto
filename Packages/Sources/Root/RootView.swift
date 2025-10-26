import CreateFeature
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

    @Shared(.inMemory("addButtonVisibility")) var addButtonVisibility: Bool = true

    @ObservableState
    public struct State: Equatable, Sendable {
        var profile: ProfileReducer.State = .init()
        var notifications: NotificationReducer.State = .init()
        var home: HomeReducer.State = .init()
        var search: SearchReducer.State = .init()
        @Presents var create: CreateFeature.State?
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
        case create(PresentationAction<CreateFeature.Action>)
        case profile(ProfileReducer.Action)
        case notifications(NotificationReducer.Action)
        case search(SearchReducer.Action)
        case home(HomeReducer.Action)
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

    public var body: some ReducerOf<Self> {


            Scope(state: \.profile, action: \.internal.profile) {
                ProfileReducer()
            }

            Scope(state: \.search, action: \.internal.search) {
                SearchReducer()
            }

            Scope(state: \.notifications, action: \.internal.notifications) {
                NotificationReducer()
            }

            Scope(state: \.home, action: \.internal.home) {
                HomeReducer()
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

public struct RootView: View {
    @Bindable var store: StoreOf<RootViewReducer>
    @SharedReader(.inMemory("addButtonVisibility")) var addButtonVisibility: Bool = true

    public init(store: StoreOf<RootViewReducer>) {
        self.store = store
    }

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
                .toolbarBackground(.white, for: .tabBar)
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
        .fullScreenCover(item: $store.scope(state: \.create, action: \.internal.create)) { store in
            CreateView(store: store)
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
                        store.send(.view(.createSingleButtonTapped))
                    }) {
                        Text("Single")
                            .foregroundStyle(Color.white)
                            .font(.system(size: 16, weight: .bold))
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                    Divider()
                        .background(Color.white.opacity(0.3))

                    Button(action: {
                        store.send(.view(.createMultipleButtonTapped))
                    }) {
                        Text("Multiple")
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
