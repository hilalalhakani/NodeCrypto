import SwiftUI

public extension Color {
    static let primary1 = Color(.primary1)
    static let primary2 = Color(.primary2)
    static let primary3 = Color(.primary3)
    static let primary4 = Color(.primary4)
    static let secondary1 = Color(.secondary1)
    static let secondary2 = Color(.secondary2)
    static let secondary3 = Color(.secondary3)
    static let secondary4 = Color(.secondary4)
    static let neutral1 = Color(.neutral1)
    static let neutral2 = Color(.neutral2)
    static let neutral3 = Color(.neutral3)
    static let neutral4 = Color(.neutral4)
    static let neutral5 = Color(.neutral5)
    static let neutral6 = Color(.neutral6)
    static let neutral7 = Color(.neutral7)
    static let neutral8 = Color(.neutral8)
    static let glassDark = Color(.glassDark)

    // Specials
    static let skipButtonTint = Color(.skipButtonTint)
    static let onboarding1Gradient1 = Color(.onboarding1Gradient1)
    static let onboarding1Gradient2 = Color(.onboarding1Gradient2)
    static let onboarding2Gradient1 = Color(.onboarding2Gradient1)
    static let onboarding2Gradient2 = Color(.onboarding2Gradient2)
    static let onboarding3Gradient1 = Color(.onboarding3Gradient1)
    static let onboarding3Gradient2 = Color(.onboarding3Gradient2)
    static let highlightedButtonSelected = Color(.highlightedButtonSelected)
    static let invisibleColor = Color.white.opacity(0.0001)
    static let connectWalletGradient1 = Color(.connectWalletGradient1)
    static let connectWalletGradient2 = Color(.connectWalletGradient2)
    static let stepperInactive = Color(.stepperInactive)
    static let connectWalletAlertBackground = Color(.connectWalletAlertBackground)
    static let connectWalletCancelBorder = Color(.connectWalletCancelBorder)

    // Create Feature Gradients
    static let createGradient1 = Color(hex: "#FFA4E0")
    static let createGradient2 = Color(hex: "#C5DDC9")
}

public extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}