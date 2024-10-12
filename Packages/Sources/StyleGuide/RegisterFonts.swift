import Foundation


#if canImport(UIKit)
 import UIKit

extension UIFont {
    struct FontDescription: Hashable {
        let bundleIdentifier: String
        let fontName: String
        let fontExtension: String
    }

    private class FontRegistrar: @unchecked Sendable {
        static let shared = FontRegistrar()
        private var registeredFontNames = Set<FontDescription>()
        private let lock = NSLock()

        func isFontRegistered(_ description: FontDescription) -> Bool {
            lock.lock()
            defer { lock.unlock() }
            return registeredFontNames.contains(description)
        }

        func registerFontDescription(_ description: FontDescription) {
            lock.lock()
            defer { lock.unlock() }
            registeredFontNames.insert(description)
        }
    }

    @discardableResult
    static func registerFont(bundle: Bundle, fontName: String, fontExtension: String) -> Bool {
        let description = FontDescription(
            bundleIdentifier: bundle.bundleIdentifier ?? "",
            fontName: fontName,
            fontExtension: fontExtension
        )

        let registrar = FontRegistrar.shared

        if registrar.isFontRegistered(description) {
            return true
        }

        guard let fontURL = bundle.url(forResource: fontName, withExtension: fontExtension) else {
            print("Couldn't find font \(fontName)")
            return false
        }

        guard let fontDataProvider = CGDataProvider(url: fontURL as CFURL) else {
            print("Couldn't load data from the font \(fontName)")
            return false
        }

        guard let font = CGFont(fontDataProvider) else {
            print("Couldn't create font from data")
            return false
        }

        var error: Unmanaged<CFError>?
        let success = CTFontManagerRegisterGraphicsFont(font, &error)
        if !success {
            let errorDescription = error?.takeUnretainedValue().localizedDescription ?? "Unknown error"
            print("Error registering font \(fontName): \(errorDescription)")
            return true
        }

        registrar.registerFontDescription(description)
        return true
    }
}
#endif
