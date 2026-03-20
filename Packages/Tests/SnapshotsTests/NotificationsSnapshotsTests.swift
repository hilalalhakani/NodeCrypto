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
})
@MainActor
struct NotificationsSnapshotsTests {
    @Test func test_notifications_loading() throws {
        let store: StoreOf<NotificationFeature> = .init(
            initialState: .init(),
            reducer: {
                NotificationFeature()
            }
        )

            let notificationsView = NotificationsView(
                store: store
            )

            try assert(notificationsView)
        }

    @Test
    func test_notifications_empty() throws {
        let emptyNotifications = [SharedModels.Notification]()

        let store = StoreOf<NotificationFeature>(
            initialState: .init(
                itemsState: NotificationFeature.ItemsState.empty,
                notifications: emptyNotifications
            ),
            reducer: {
                NotificationFeature()
            }
        )

        let notificationsView = NotificationsView(store: store)

        try assert(notificationsView)

    }

    @Test
    func test_notifications_loaded() throws {
        let notifications: [SharedModels.Notification] = [
            .init(
                senderName: "KidEight",
                senderImageURLString: "https://picsum.photos/200/300",
                date: "9 Jul 2021, 11:34 PM"
            ),
            .init(
                senderName: "Rotation ahsdjkashdkjashdjksahdjksahdjkashdkj",
                senderImageURLString: "https://picsum.photos/200/300",
                date: "19 Jul 2020, 11:34 PM"
            ),
        ]

        let store = StoreOf<NotificationFeature>(
            initialState: .init(
                itemsState: NotificationFeature.ItemsState.loaded,
                notifications: notifications
            ),
            reducer: {
                NotificationFeature()
            }
        )

        let notificationsView = NotificationsView(store: store)

        try assert(notificationsView)

    }

}
