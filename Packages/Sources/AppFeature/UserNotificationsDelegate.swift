//
//  File.swift
//
//
//  Created by HH on 09/12/2023.
//

import Foundation
import NodeCryptoCore
import UserNotifications

public final class UserNotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    public var willPresent:
        @Sendable (UNUserNotificationCenter, UNNotification) async ->
        UNNotificationPresentationOptions
    public var didReceive:
        @Sendable (UNUserNotificationCenter, UNNotificationResponse) async -> Void
    public var openSettingsFor: @Sendable (UNUserNotificationCenter, UNNotification?) -> Void

    public init(
        willPresent: @escaping @Sendable (UNUserNotificationCenter, UNNotification) async ->
            UNNotificationPresentationOptions,
        didReceive: @escaping @Sendable (UNUserNotificationCenter, UNNotificationResponse) async ->
            Void,
        openSettingsFor: @escaping @Sendable (UNUserNotificationCenter, UNNotification?) -> Void
    ) {
        self.willPresent = willPresent
        self.didReceive = didReceive
        self.openSettingsFor = openSettingsFor
    }

    public func userNotificationCenter(
        _ center: UNUserNotificationCenter, willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        await willPresent(center, notification)
    }

    public func userNotificationCenter(
        _ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse
    ) async {
        await didReceive(center, response)
    }

    public func userNotificationCenter(
        _ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?
    ) {
        openSettingsFor(center, notification)
    }
}

extension UserNotificationDelegate: DependencyKey, @unchecked Sendable {
    public static var liveValue: UserNotificationDelegate {
        UserNotificationDelegate { _, _ in
            .banner
        } didReceive: { _, _ in

        } openSettingsFor: { _, _ in
        }
    }

    public static var testValue: UserNotificationDelegate {
        UserNotificationDelegate(
            willPresent: unimplemented(
                #"@Dependency(\.userNotificationDelegate).willPresent"#, placeholder: []
            ),
            didReceive: unimplemented(#"@Dependency(\.userNotificationDelegate).didReceive"#),
            openSettingsFor: unimplemented(
                #"@Dependency(\.userNotificationDelegate).openSettingsFor"#)
        )
    }

    public static var previewValue: UserNotificationDelegate {
        .liveValue
    }
}

public extension DependencyValues {
    var userNotificationDelegate: UserNotificationDelegate {
        get { self[UserNotificationDelegate.self] }
        set { self[UserNotificationDelegate.self] = newValue }
    }
}
