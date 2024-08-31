import Foundation
import SwiftUI

public enum Tab: CaseIterable {
  case home
  case search
  case notifications
  case profile

    public var systemImage: String {
    switch self {
    case .home:
      return "HomeIcon"
    case .search:
      return "SearchIcon"
    case .notifications:
      return "NotificationsIcon"
    case .profile:
      return "ProfileIcon"
    }
  }

    public var index: Int {
    Tab.allCases.firstIndex(of: self) ?? 0
  }
}
