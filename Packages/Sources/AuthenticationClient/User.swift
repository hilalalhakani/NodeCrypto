//
//  User.swift
//  Main
//
//  Created by Hilal Hakkani on 15/12/2024.
//

import ComposableArchitecture
import SharedModels
import Dependencies
import Keychain


extension SharedKey where Self == SharedKeychainKey<User?> {
  public static var user: Self {
      .keychain(.user)
  }
}

