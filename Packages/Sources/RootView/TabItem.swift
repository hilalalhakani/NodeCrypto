import Foundation
import SwiftUI

struct TabItem: View {
  var tab: Tab
  @Binding var activeTab: Tab

  var body: some View {
    VStack(alignment: .center, spacing: 2) {
      Image(tab.systemImage)
        .font(.title2)
        .frame(width: 24, height: 24)
        .frame(maxWidth: .infinity)
        .onTapGesture {
          activeTab = tab
        }
        Circle()
            .fill(tab == activeTab ? Color.neutral8 : .clear)
            .frame(width: 10, height: 10, alignment: .center)
    }

  }
}

#Preview {
    struct Preview: View {

        var body: some View {
            VStack(spacing: 30) {
                HStack{
                    TabItem(tab: .home, activeTab: .constant(.home))
                    TabItem(tab: .home, activeTab: .constant(.notifications))
                }
                HStack{
                    TabItem(tab: .notifications, activeTab: .constant(.notifications))
                    TabItem(tab: .notifications, activeTab: .constant(.home))
                }
                HStack{
                    TabItem(tab: .search, activeTab: .constant(.search))
                    TabItem(tab: .search, activeTab: .constant(.home))
                }
                HStack{
                    TabItem(tab: .profile, activeTab: .constant(.profile))
                    TabItem(tab: .profile, activeTab: .constant(.home))
                }
            }
        }
    }

  return Preview()
}
