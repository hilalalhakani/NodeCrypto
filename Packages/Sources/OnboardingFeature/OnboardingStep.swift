import Foundation
import StyleGuide
import SwiftUI

public enum OnboardingStep: Int, CaseIterable, Comparable, Equatable {
    public struct Step {
        let title: String
        let subtitle: String
        let imageName: ImageResource
        let gradientColors: [Color]
    }

    case step1
    case step2
    case step3
    case step4

    mutating func next() {
        self = Self(rawValue: rawValue + 1) ?? Self.allCases.last!
    }

    mutating func previous() {
        self = Self(rawValue: rawValue - 1) ?? Self.allCases.first!
    }

    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue < rhs.rawValue
    }

    public func value() -> Step {
        switch self {
        case .step1:
            return Step(
                title: "The new NFT marketplace",
                subtitle: "Explore and trade in a diverse world of digital art and collectibles.",
                imageName: ImageResource.onboarding1,
                gradientColors: [
                    Color(red: 0.89, green: 0.89, blue: 1),
                    Color(red: 0.92, green: 0.87, blue: 1)
                ]
            )
        case .step2:
            return Step(
                title: "Get success in the crypto art",
                subtitle: "Unlock your potential in a booming market of crypto-based artistry.",
                imageName: ImageResource.onboarding2,
                gradientColors: [Color.hex(0xC5DDC9), Color.hex(0xFFA4E0)]
            )
        case .step3:
            return Step(
                title: "A new NFT experience",
                subtitle: "Immerse yourself in a cutting-edge platform for NFT discovery and acquisition.",
                imageName: ImageResource.onboarding3,
                gradientColors: [Color.hex(0xFFFDC9), Color.hex(0xFFFFFF)]
            )
        case .step4:
            return Step(
                title: "Lowest fees in the market",
                subtitle: "Enjoy trading and collecting NFTs with minimal fees and maximum value.",
                imageName: ImageResource.onboarding4,
                gradientColors: [Color.hex(0xA4A8FF), Color.hex(0xFFA4E0)]
            )
        }
    }
}
