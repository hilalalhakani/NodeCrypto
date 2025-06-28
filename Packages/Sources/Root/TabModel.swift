import Foundation
import SwiftUI

public enum Tab: CaseIterable, Sendable {
  case home
  case search
  case add
  case notifications
  case profile

    public var systemImage: String {
    switch self {
    case .home:
      return "HomeIcon"
    case .search:
      return "SearchIcon"
    case .add:
      return "plus"
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
