//
//  File.swift
//
//
//  Created by HH on 09/12/2023.
//

import Foundation
import UserNotifications
import ComposableArchitecture

@Reducer
public struct AppDelegateFeature: Sendable {
    @ObservableState
    public struct State: Equatable, Sendable {
        public init() {}
    }

    @CasePathable
    public enum Action {
        case appDelegateDidFinishLaunching
        case didRegisterForRemoteNotifications(Result<Data, Error>)
    }

    @Dependency(\.userNotificationCenter) var userNotificationCenter

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .appDelegateDidFinishLaunching:
                return .run { _ in
                    try await requestUserNotificationsAuthorization()
                }
            default:
                return .none
            }
        }
    }

    private func requestUserNotificationsAuthorization() async throws {
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
