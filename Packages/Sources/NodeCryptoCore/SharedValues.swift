//
//  Untitled.swift
//  Main
//
//  Created by Hilal Hakkani on 12/10/2024.
//

import ComposableArchitecture

extension PersistenceReaderKey where Self == InMemoryKey<Bool> {
  public static var isTabBarVisible: Self {
      .inMemory("isTabBarVisible")
  }
}
