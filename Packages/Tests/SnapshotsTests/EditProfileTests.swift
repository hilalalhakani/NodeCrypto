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


@Suite(.dependencies {
    $0.defaultInMemoryStorage = .init()
})
@MainActor
struct EditProfileSnapshotsTests {
    @Test
    func testEditProfileScreen() throws {
        @Shared(.user) var user = .mock1
        let store: StoreOf<EditProfileFeature> = .init(
            initialState: .init(user: User.mock1)
        ) {
            EditProfileFeature()
        } withDependencies: {
            $0.keychainManager.get =  { @Sendable _ in Data() }
        }

        let editProfileView = NavigationStack {
            EditProfileView(store: store)
        }

        try assert(editProfileView)
    }

    @Test
    func testEditProfileScreen_french() throws {
        @Shared(.user) var user = User.mock1
        let store: StoreOf<EditProfileFeature> = .init(
            initialState: .init(user: User.mock1)
        ) {
            EditProfileFeature()
        } withDependencies: {
            $0.keychainManager.get = { @Sendable _ in Data() }
        }

        let editProfileView = NavigationStack {
            EditProfileView(store: store)
                .environment(\.locale, Locale(identifier: "fr"))
        }

        try assert(editProfileView, named: "testEditProfileScreen_fr")
    }
}
