//
//  File.swift
//  
//
//  Created by Hilal Hakkani on 06/08/2024.
//

import Foundation
import ComposableArchitecture
import Keychain
import SharedModels
import XCTest

class BaseTestCase: XCTestCase {
    override func invokeTest() {
        withDependencies {
            $0.keychainManager.set = { @Sendable _, _ in }
            $0.keychainManager.get = { @Sendable _ in Data() }
        } operation: {
            @Dependency(\.userManager) var userManager
            userManager.user = .mock1
            super.invokeTest()
        }
    }
}
