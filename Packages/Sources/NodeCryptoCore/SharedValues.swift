//
//  Untitled.swift
//  Main
//
//  Created by Hilal Hakkani on 12/10/2024.
//

import ComposableArchitecture
import Sharing

extension SharedKey where Self == InMemoryKey<Bool>.Default {
  public static var isTabBarVisible: Self {
      Self[.inMemory("isTabBarVisible"), default: true]
  }
}
