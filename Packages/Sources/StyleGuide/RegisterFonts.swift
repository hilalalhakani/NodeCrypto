import Foundation

#if canImport(UIKit)
    import UIKit
    extension UIFont {
        #if DEBUG
            struct FontDescription: Hashable {
                let bundle: Bundle
                let fontName: String
                let fontExtension: String
            }

            static var lock = NSRecursiveLock()
            static var registeredFontNames = Set<FontDescription>()
        #endif
        @discardableResult
        static func registerFont(bundle: Bundle, fontName: String, fontExtension: String) -> Bool {
            let description = FontDescription(
                bundle: bundle, fontName: fontName, fontExtension: fontExtension
            )
            lock.lock()
            defer { lock.unlock() }
            guard !registeredFontNames.contains(description) else { return true }
            guard let fontURL = bundle.url(forResource: fontName, withExtension: fontExtension)
            else {
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
            guard success else {
                print(
                    """
                    Error registering font: \(fontName). Maybe it was already registered.\
                    \(error.map { " \($0.takeUnretainedValue().localizedDescription)" } ?? "")
                    """
                )
                return true
            }
            // We're already under lock.
            registeredFontNames.insert(description)
            return true
        }
    }
#endif
