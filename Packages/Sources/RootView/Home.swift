import Foundation
import NodeCryptoCore
import SwiftUI

struct RootView: View {
  @State private var activeTab: Tab = .home
  @Namespace var animation

  var body: some View {
    VStack(spacing: 0) {
      TabView(selection: $activeTab) {
        Color.red
          .tag(Tab.home)
          .toolbar(.hidden, for: .tabBar)
          Text("Services", bundle: .module)
          .tag(Tab.search)
          .toolbar(.hidden, for: .tabBar)
        Text("Notifications", bundle: .module)
          .tag(Tab.notifications)
          .toolbar(.hidden, for: .tabBar)
        Text("Profile", bundle: .module)
          .tag(Tab.profile)
          .toolbar(.hidden, for: .tabBar)
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
  RootView()
}
