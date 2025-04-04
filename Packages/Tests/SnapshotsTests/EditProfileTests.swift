//
//  File.swift
//
//
//  Created by Hilal Hakkani on 03/08/2024.
//

import ComposableArchitecture
import Foundation
import ProfileFeature
import SharedModels
import SnapshotTesting
import SwiftUI
import Testing


@MainActor
struct EditProfileSnapshotsTests {
    @Test
    func testEditProfileScreen() throws {
        @Shared(.user) var user = .mock1
        let store: StoreOf<EditProfile> = .init(
            initialState: .init(user: User.mock1)
        ) {
            EditProfile()
        } withDependencies: {
            $0.keychainManager.get =  { @Sendable _ in Data() }
        }

        let editProfileView = NavigationStack {
            EditProfileView(store: store)
        }

        try assert(editProfileView)
    }
}
