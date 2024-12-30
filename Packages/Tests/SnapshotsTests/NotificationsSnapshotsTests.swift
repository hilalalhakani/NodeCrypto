//
//  NotificationsSnapshotsTests.swift
//  Main
//
//  Created by Hilal Hakkani on 12/10/2024.
//

import ComposableArchitecture
import Foundation
import NotificationsFeature
import SharedModels
import SnapshotTesting
import SwiftUI
import Testing

@MainActor
    struct NotificationsSnapshotsTests {
        @Test func test_notifications_loading() throws {
            let store: StoreOf<NotificationReducer> = .init(
                initialState: .init(),
                reducer: {
                    NotificationReducer()
                        .dependency(\.apiClient.profile.getNotifications, { try await Task.never() })
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

            let store = StoreOf<NotificationReducer>(
                initialState: .init(
                    itemsState: NotificationReducer.ItemsState.empty,
                    notifications: emptyNotifications
                ),
                reducer: {
                    NotificationReducer()
                        .dependency(\.analyticsClient.sendAnalytics, { _ in })
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

            let store = StoreOf<NotificationReducer>(
                initialState: .init(
                    itemsState: NotificationReducer.ItemsState.loaded,
                    notifications: notifications
                ),
                reducer: {
                    NotificationReducer()
                }
            )

            let notificationsView = NotificationsView(store: store)

            try assert(notificationsView)

        }

    }
