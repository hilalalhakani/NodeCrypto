import Foundation
import CoreText

// MARK: - Shared implementation

private final class FontRegistrar: @unchecked Sendable {
    static let shared = FontRegistrar()

    struct FontDescription: Hashable {
        let bundleIdentifier: String
        let fontName: String
        let fontExtension: String
    }

    private var registered = Set<FontDescription>()
    private let lock = NSLock()

    func contains(_ description: FontDescription) -> Bool {
        lock.lock(); defer { lock.unlock() }
        return registered.contains(description)
    }

    func insert(_ description: FontDescription) {
        lock.lock(); defer { lock.unlock() }
        registered.insert(description)
    }
}

@discardableResult
func _registerFont(bundle: Bundle, fontName: String, fontExtension: String) -> Bool {
    let key = FontRegistrar.FontDescription(
        bundleIdentifier: bundle.bundleIdentifier ?? "",
        fontName: fontName,
        fontExtension: fontExtension
    )
    guard !FontRegistrar.shared.contains(key) else { return true }

    guard let url = bundle.url(forResource: fontName, withExtension: fontExtension) else {
        print("Couldn't find font \(fontName)")
        return false
    }
    guard let provider = CGDataProvider(url: url as CFURL),
          let font = CGFont(provider) else {
        print("Couldn't load font \(fontName)")
        return false
    }

    var error: Unmanaged<CFError>?
    let success = CTFontManagerRegisterGraphicsFont(font, &error)
    if !success {
        let description = error?.takeRetainedValue().localizedDescription ?? "unknown error"
        print("RegisterFonts: failed to register \(fontName): \(description)")
        return false
    }

    FontRegistrar.shared.insert(key)
    return true
}

// MARK: - Bulk registration (shared, runs exactly once across all platforms)

private let _registerAllFontsOnce: Void = {
    guard let urls = Bundle.module.urls(forResourcesWithExtension: "ttf", subdirectory: nil) else { return }
    for url in urls {
        _registerFont(bundle: .module, fontName: url.deletingPathExtension().lastPathComponent, fontExtension: "ttf")
    }
}()

// MARK: - UIFont (iOS / Mac Catalyst)

#if canImport(UIKit)
import UIKit

extension UIFont {
    @discardableResult
    public static func registerFont(bundle: Bundle, fontName: String, fontExtension: String) -> Bool {
        _registerFont(bundle: bundle, fontName: fontName, fontExtension: fontExtension)
    }

    public static func registerAllFonts() { _ = _registerAllFontsOnce }
}
#endif

// MARK: - NSFont (macOS)

#if canImport(AppKit)
import AppKit

extension NSFont {
    @discardableResult
    public static func registerFont(bundle: Bundle, fontName: String, fontExtension: String) -> Bool {
        _registerFont(bundle: bundle, fontName: fontName, fontExtension: fontExtension)
    }

    public static func registerAllFonts() { _ = _registerAllFontsOnce }
}
#endif
