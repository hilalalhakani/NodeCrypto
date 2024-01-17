import Foundation
import SwiftUI

struct TabItem: View {
  var tab: Tab
  @Binding var activeTab: Tab
  var animation: Namespace.ID
  @Environment(\.colorScheme) var colorScheme

  var body: some View {
    VStack(alignment: .center, spacing: 2) {
      Image(tab.systemImage)
        .font(.title2)
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
    struct Preview: View {
        @Namespace var homeAnimation
        @Namespace var notificationsAnimation
        @Namespace var searchAnimation
        @Namespace var profileAnimation

        var body: some View {
            VStack(spacing: 30) {
                HStack{
                    TabItem(tab: .home, activeTab: .constant(.home), animation: homeAnimation)
                    TabItem(tab: .home, activeTab: .constant(.notifications), animation: homeAnimation)
                }

                HStack{
                    TabItem(tab: .notifications, activeTab: .constant(.notifications), animation: notificationsAnimation)
                    TabItem(tab: .notifications, activeTab: .constant(.home), animation: notificationsAnimation)
                }

                HStack{
                    TabItem(tab: .search, activeTab: .constant(.search), animation: searchAnimation)
                    TabItem(tab: .search, activeTab: .constant(.home), animation: searchAnimation)
                }

                HStack{
                    TabItem(tab: .profile, activeTab: .constant(.profile), animation: profileAnimation)
                    TabItem(tab: .profile, activeTab: .constant(.home), animation: profileAnimation)
                }
            }
        }
    }

    return Preview()
}
