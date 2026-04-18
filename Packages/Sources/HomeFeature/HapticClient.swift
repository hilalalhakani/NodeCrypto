//
//  HapticClient.swift
//  Main
//
//  Created by Antigravity on 27/01/2026.
//

import Dependencies
import DependenciesMacros

/// Platform-agnostic haptic feedback intensity, mirroring UIImpactFeedbackGenerator.FeedbackStyle.
public enum HapticFeedbackStyle: Sendable {
    case light
    case medium
    case heavy
    case soft
    case rigid
}

@DependencyClient
public struct HapticClient: Sendable {
    public var impactOccurred: @Sendable (HapticFeedbackStyle) -> Void
}

#if canImport(UIKit)
import UIKit

extension HapticClient: DependencyKey {
    public static let liveValue = Self(
        impactOccurred: { style in
            Task { @MainActor in
                let uiStyle: UIImpactFeedbackGenerator.FeedbackStyle
                switch style {
                case .light:  uiStyle = .light
                case .medium: uiStyle = .medium
                case .heavy:  uiStyle = .heavy
                case .soft:   uiStyle = .soft
                case .rigid:  uiStyle = .rigid
                }
                let generator = UIImpactFeedbackGenerator(style: uiStyle)
                generator.prepare()
                generator.impactOccurred()
            }
        }
    )

    public static let testValue = Self(
        impactOccurred: { _ in }
    )
}
#else
extension HapticClient: DependencyKey {
    public static let liveValue = Self(impactOccurred: { _ in })
    public static let testValue = Self(impactOccurred: { _ in })
}
#endif

extension DependencyValues {
    public var haptics: HapticClient {
        get { self[HapticClient.self] }
        set { self[HapticClient.self] = newValue }
    }
}
