//
//  SwiftUIView.swift
//
//
//  Created by HH on 09/01/2024.
//

import SwiftUI

enum Tab: String, CaseIterable {
  case home = "home"
  case search = "search"
  case notifications = "notifications"
  case profile = "profile"

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
