//
//  iOSApp.swift
//  iOS
//
//  Created by HH on 19/11/2023.
//

import AppFeature
import NodeCryptoCore
import OnboardingFeature
import SwiftUI

final class AppDelegate: NSObject {
    let store = Store(
        initialState: .init(),
        reducer: {
            AppViewReducer()
                ._printChanges()
        }
    )

    @Dependency(\.userNotificationCenter) var userNotificationCenter
    @Dependency(\.userNotificationDelegate) var userNotificationDelegate
}

#if os(iOS)
    extension AppDelegate: UIApplicationDelegate {
        func application(
            _: UIApplication,
            didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil
        ) -> Bool {
            userNotificationCenter.delegate = userNotificationDelegate
            store.send(.internal(.appDelegate(.didFinishLaunching)))
            return true
        }

        func application(
            _: UIApplication,
            didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
        ) {
            store.send(.internal(.appDelegate(.didRegisterForRemoteNotifications(.success(deviceToken)))))
        }

        func application(
            _: UIApplication,
            didFailToRegisterForRemoteNotificationsWithError error: Error
        ) {
            store.send(.internal(.appDelegate(.didRegisterForRemoteNotifications(.failure(error)))))
        }
    }
#endif

#if os(macOS)
    extension AppDelegate: NSApplicationDelegate {
        func applicationDidFinishLaunching(_: Notification) {
            userNotificationCenter.delegate = userNotificationDelegate
        }
    }
#endif

@main
struct NodeCryptoApp: App {
    #if os(iOS)
        @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    #endif
    #if os(macOS)
        @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    #endif

    var body: some Scene {
        WindowGroup {
            AppView(store: appDelegate.store)
        }
    }
}
