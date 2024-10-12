//
//  File.swift
//
//
//  Created by HH on 09/12/2023.
//

import Foundation
import NodeCryptoCore
import UserNotifications

@Reducer
public struct AppDelegateReducer : Sendable {
    public struct State: Equatable, Sendable {}

    @CasePathable
    public enum Action {
        case didFinishLaunching
        case didRegisterForRemoteNotifications(Result<Data, Error>)
    }

    @Dependency(\.userNotificationCenter) var userNotificationCenter

    public init() {}

    public func reduce(into _: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .didFinishLaunching:
            return .run { _ in
                try await requestUserNotificationsAuthorization()
            }
        default:
            return .none
        }
    }

    func requestUserNotificationsAuthorization() async throws {
        let settings = await userNotificationCenter.notificationSettings()
        let status = settings.authorizationStatus

        if status == .notDetermined {
            guard
                try await userNotificationCenter.requestAuthorization(options: [
                    .alert, .sound
                ])
            else {
                return
            }
        }
    }
}
