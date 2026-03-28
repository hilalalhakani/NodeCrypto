import ComposableArchitecture
import Testing
import Foundation
import SharedModels
@testable import NotificationsFeature

@MainActor
struct NotificationsFeatureTests {
    @Test
    func test_onAppear_loadsNotifications() async {
        let notifications = [
            SharedModels.Notification(senderName: "User 1", senderImageURLString: "url1", date: "Today"),
            SharedModels.Notification(senderName: "User 2", senderImageURLString: "url2", date: "Yesterday")
        ]

        let store = TestStore(initialState: NotificationFeature.State()) {
            NotificationFeature()
        } withDependencies: {
            $0.apiClient.profile.getNotifications = { notifications }
        }

        await store.send(.view(.onAppear))
        await store.receive(\.internal.onGetNotifications.success) {
            $0.itemsState = .loaded
            $0.notifications = .init(uniqueElements: notifications)
        }
    }

    @Test
    func test_onAppear_loadsNotifications_empty() async {
        let store = TestStore(initialState: NotificationFeature.State()) {
            NotificationFeature()
        } withDependencies: {
            $0.apiClient.profile.getNotifications = { [] }
        }

        await store.send(.view(.onAppear))
        await store.receive(\.internal.onGetNotifications.success) {
            $0.itemsState = .empty
            $0.notifications = []
        }
    }

    @Test
    func test_onAppear_loadsNotifications_failure() async {
        let store = TestStore(initialState: NotificationFeature.State()) {
            NotificationFeature()
        } withDependencies: {
            $0.apiClient.profile.getNotifications = { throw URLError(.badServerResponse) }
        }

        await store.send(.view(.onAppear))
        await store.receive(\.internal.onGetNotifications.failure) {
            $0.itemsState = .empty
        }
    }
}
