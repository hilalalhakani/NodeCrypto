//
//  iOSApp.swift
//  iOS
//
//  Created by HH on 19/11/2023.
//

import AppFeature
@preconcurrency import ComposableAnalytics
import ComposableArchitecture
import OnboardingFeature
import SwiftUI
import XCTestDynamicOverlay
import APIClientLive
import Firebase

@MainActor
final class AppDelegate: NSObject {
    let store = Store(
        initialState: AppViewReducer.State(),
        reducer: {
            AppViewReducer()
                .dependency(\.analyticsClient, .consoleLogger)
                .dependency(\.apiClient, APIClient.liveValue)
        }
    )

    @Dependency(\.userNotificationCenter) var userNotificationCenter
    @Dependency(\.userNotificationDelegate) var userNotificationDelegate
}

#if os(iOS)
    extension AppDelegate: UIApplicationDelegate {
        func application(
            _: UIApplication,
            didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey:
                Any]? = nil
        ) -> Bool {
            userNotificationCenter.delegate = userNotificationDelegate
            store.send(
                AppViewReducer.Action.internal(
                    .appDelegate(.didFinishLaunching)
                )
            )
            FirebaseApp.configure()
            return true
        }

        func application(
            _: UIApplication,
            didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
        ) {
            store.send(
                AppViewReducer.Action.internal(
                    .appDelegate(
                        .didRegisterForRemoteNotifications(
                            .success(deviceToken)
                        )
                    )
                )
            )
        }

        func application(
            _: UIApplication,
            didFailToRegisterForRemoteNotificationsWithError error: Error
        ) {
            store.send(
                AppViewReducer.Action.internal(
                    .appDelegate(
                        .didRegisterForRemoteNotifications(.failure(error))
                    )
                )
            )
        }
    }
#endif

#if os(macOS)
    extension AppDelegate: NSApplicationDelegate {
        func applicationDidFinishLaunching(_: Foundation.Notification) {
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
            if !isTesting {
                AppView(store: appDelegate.store)
            }
        }
    }
}

//     That's how we send an action to the child from the parent
// func updateStepper(state: inout State) -> Effect<Action> {
//        OnboardingStepperReducer(totalSteps: OnboardingStep.allCases.count)
//          .reduce(into: &state.onboardingStepper, action: .internal(.updateStep(state.currentStep)))
//          .map { Action.view(.onboardingStepper($0)) }
//      }
