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
import XCTest

#if os(iOS)
@available(macOS, unavailable)
final class EditProfileSnapshotsTests: BaseTestCase {
    @MainActor
    func testEditProfileScreen_light() {
        let store: StoreOf<EditProfileReducer> = .init(
            initialState: .init(user: User.mock1)
        ) {
            EditProfileReducer()
        }

        let editProfileView = NavigationStack {
            EditProfileView(store: store)
                .environment(\.colorScheme, .light)
        }

        assertSnapshot(
            of: editProfileView,
            as: .image(perceptualPrecision: precision, layout: .device(config: .iPhone13Pro), traits: UITraitCollection(displayScale: 3))
        )
    }
}
#endif
