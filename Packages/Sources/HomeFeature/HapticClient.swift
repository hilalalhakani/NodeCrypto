//
//  HapticClient.swift
//  Main
//
//  Created by Antigravity on 27/01/2026.
//

import UIKit
import Dependencies
import DependenciesMacros

@DependencyClient
public struct HapticClient: Sendable {
    public var impactOccurred: @Sendable (UIImpactFeedbackGenerator.FeedbackStyle) -> Void
}

extension HapticClient: DependencyKey {
    public static let liveValue = Self(
        impactOccurred: { style in
            Task { @MainActor in
                let generator = UIImpactFeedbackGenerator(style: style)
                generator.prepare()
                generator.impactOccurred()
            }
        }
    )
    
    public static let testValue = Self(
        impactOccurred: { _ in }
    )
}

extension DependencyValues {
    public var haptics: HapticClient {
        get { self[HapticClient.self] }
        set { self[HapticClient.self] = newValue }
    }
}
