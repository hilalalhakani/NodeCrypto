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
public struct AppDelegateReducer {
    public struct State: Equatable {}

    public enum Action: Equatable {
        case didFinishLaunching
        case didRegisterForRemoteNotifications(Result<Data, Error>)

        public static func == (lhs: AppDelegateReducer.Action, rhs: AppDelegateReducer.Action) -> Bool {
            switch (lhs, rhs) {
             case (.didFinishLaunching, .didFinishLaunching):
                 return true

             case (.didRegisterForRemoteNotifications(let lhsResult), .didRegisterForRemoteNotifications(let rhsResult)):

                switch (lhsResult, rhsResult) {
                case (.success(let lhsData), .success(let rhsData)):
                    return lhsData == rhsData
                case (.failure, .failure):
                    return true
                default:
                    return false
                }

             default:
                 return false
             }
         }
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
