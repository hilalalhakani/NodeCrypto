//
//  SwiftUIView.swift
//
//
//  Created by HH on 09/01/2024.
//

import NodeCryptoCore
import SwiftUI

struct Home: View {
  @State private var activeTab: Tab = .search
  @Namespace var animation

  var body: some View {
    VStack(spacing: 0) {
      TabView(selection: $activeTab) {
        Color.red
          .tag(Tab.home)
          .toolbar(.hidden, for: .tabBar)

        Text("Services")
          .tag(Tab.search)
          .toolbar(.hidden, for: .tabBar)

        Text("Notifications")
          .tag(Tab.notifications)
          .toolbar(.hidden, for: .tabBar)

        Text("Profile")
          .tag(Tab.profile)
          .toolbar(.hidden, for: .tabBar)
      }

      CustomTabBar()
    }
  }

  @ViewBuilder
  func CustomTabBar(tint: Color = .blue, inactiveTint: Color = .blue) -> some View {
    HStack(spacing: 0) {

      TabItem(
        tint: tint,
        inactiveTint: inactiveTint,
        tab: .home,
        activeTab: $activeTab,
        animation: animation
      )

      TabItem(
        tint: tint,
        inactiveTint: inactiveTint,
        tab: .search,
        activeTab: $activeTab,
        animation: animation
      )

      Button(
        action: {

        },
        label: {
          Image(ImageResource.add)
            .padding(12)
            .background(
              Circle()
                .foregroundStyle(Color.primary1)
            )
        }
      )
      .frame(maxWidth: .infinity)

      TabItem(
        tint: tint,
        inactiveTint: inactiveTint,
        tab: .notifications,
        activeTab: $activeTab,
        animation: animation
      )

      TabItem(
        tint: tint,
        inactiveTint: inactiveTint,
        tab: .profile,
        activeTab: $activeTab,
        animation: animation
      )

    }
    .animation(.easeIn, value: activeTab)
  }
}

struct TabItem: View {
  var tint: Color
  var inactiveTint: Color
  var tab: Tab
  @Binding var activeTab: Tab
  var animation: Namespace.ID
  @Environment(\.colorScheme) var colorScheme

  var body: some View {
    VStack(alignment: .center, spacing: 2) {
      Image(tab.systemImage)
        .font(.title2)
        .foregroundStyle(tint)
        .frame(width: 24, height: 24)
        .frame(maxWidth: .infinity)
        .onTapGesture {
          activeTab = tab
        }

      Group {
        if self.tab == activeTab {
          Circle()
            .fill(colorScheme == .light ? Color.black : Color.neutral8)
        } else {
          Spacer()
        }

      }
      .matchedGeometryEffect(id: "ActiveTab", in: animation)
      .frame(width: 10, height: 10, alignment: .center)
    }

  }
}

#Preview {
  Home()
}
