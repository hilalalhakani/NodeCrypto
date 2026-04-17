//
//  NotificationsSnapshotsTests.swift
//  Main
//
//  Created by Hilal Hakkani on 12/10/2024.
//

import ComposableArchitecture
import DependenciesTestSupport
import Foundation
import NotificationsFeature
import SharedModels
import SnapshotTesting
import SwiftUI
import Testing

@Suite(.dependencies {
    $0.analyticsClient.sendAnalytics = { _ in }
    $0.defaultInMemoryStorage = .init()
})
@MainActor
struct NotificationsSnapshotsTests {

    @Test
    func testLoadingState() throws {
        let store: StoreOf<NotificationFeature> = .init(
            initialState: .init(),
            reducer: { NotificationFeature() }
        )

        let notificationsView = NotificationsView(store: store)
        try assert(notificationsView)
    }

    @Test
    func testEmptyState() throws {
        let emptyNotifications: [SharedModels.Notification] = [
            .mock1,
            .mock2,
        ]
        let store = StoreOf<NotificationFeature>(
            initialState: .init(
                itemsState: .empty,
                notifications: emptyNotifications
            ),
            reducer: { NotificationFeature() }
        )

        let notificationsView = NotificationsView(store: store)
        try assert(notificationsView)
    }

    @Test
    func testLoadedState() throws {
        let notifications: [SharedModels.Notification] = [
            .mock1,
            .mock2,
        ]
        let store = StoreOf<NotificationFeature>(
            initialState: .init(
                itemsState: .loaded,
                notifications: notifications
            ),
            reducer: { NotificationFeature() }
        )

        let notificationsView = NotificationsView(store: store)
        try assert(notificationsView)
    }

    @Test
    func testLoadedState_french() throws {
        let notifications: [SharedModels.Notification] = [
            .mock1,
        ]
        let store = StoreOf<NotificationFeature>(
            initialState: .init(
                itemsState: .loaded,
                notifications: notifications
            ),
            reducer: { NotificationFeature() }
        )

        let notificationsView = NotificationsView(store: store)
            .environment(\.locale, Locale(identifier: "fr"))

        try assert(notificationsView, named: "testLoadedState_fr")
    }
}
