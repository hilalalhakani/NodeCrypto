import Foundation
import NodeCryptoCore
import SwiftUI

@Reducer
public struct RootViewReducer {
  public init() {}
  public struct State: Equatable { public init() {} }
  public enum Action {}

  public func reduce(into state: inout State, action: Action) -> Effect<Action> {
    return .none
  }
}

public struct RootView: View {
  @State private var activeTab: Tab = .home
  @Namespace var animation
  let store: StoreOf<RootViewReducer>

  public init(store: StoreOf<RootViewReducer>) {
    self.store = store
  }

  public var body: some View {
    VStack(spacing: 0) {
      TabView(selection: $activeTab) {
        Color.red
          .tag(Tab.home)
          .hideToolbar()
        Text("Services", bundle: .module)
          .tag(Tab.search)
          .hideToolbar()
        Text("Notifications", bundle: .module)
          .tag(Tab.notifications)
          .hideToolbar()
        Text("Profile", bundle: .module)
          .tag(Tab.profile)
          .hideToolbar()
      }
      customTabBar()
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

  func makeTabItem(_ tab: Tab) -> some View {
    TabItem(
      tab: tab,
      activeTab: $activeTab
    )
  }
}

#Preview {
  RootView(
    store: .init(
      initialState: .init(),
      reducer: { RootViewReducer() }
    )
  )
}

extension View {
    func hideToolbar() -> some View {
        #if os(iOS)
        self.toolbar(.hidden, for: .tabBar)
        #else
        self
        #endif
    }
}
