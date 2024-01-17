import Foundation
import SwiftUI

enum Tab: CaseIterable {
  case home
  case search
  case notifications
  case profile

  var systemImage: ImageResource {
    switch self {
    case .home:
      return .homeIcon
    case .search:
      return .searchIcon
    case .notifications:
      return .notificationsIcon
    case .profile:
      return .profileIcon
    }
  }

  var index: Int {
    Tab.allCases.firstIndex(of: self) ?? 0
  }
}
