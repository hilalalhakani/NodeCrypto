//
//  File.swift
//
//
//  Created by HH on 07/12/2023.
//

import Foundation
import SwiftUI
//import DependenciesAdditions

//public extension UserDefaults.Dependency {
//    var userPreferences: AsyncStream<UserPreferences> {
//        @Dependency(\.decode) var decode
//        return dataValues(forKey: UserPreferences.userDefaultsKey)
//            .map {
//                (try? $0.map { try decode(UserPreferences.self, from: $0) }) ?? UserPreferences()
//            }
//            .eraseToStream()
//    }
//
//    // We strictly don't need async here, but it allows to select the correct `.fireAndForget`
//    // overload. It should ideally be async, but UserDefaults writes on disk on a private
//    // queue and swallows the errors.
//    func saveUserPreferences(_ userPreferences: UserPreferences?) async throws {
//        @Dependency(\.encode) var encode
//        if let userPreferences {
//            let data = try encode(userPreferences)
//            // self.set(userPreferences.selectedLanguage?.rawValue, forKey: "AppleLanguage")
//            set(data, forKey: UserPreferences.userDefaultsKey)
//        } else {
//            removeValue(forKey: "AppleLanguage")
//            removeValue(forKey: UserPreferences.userDefaultsKey)
//        }
//    }
//}
//
//public struct UserPreferences {
//    public var areNotificationsEnabled: Bool = false
////    public var selectedLanguage: AppLanguage? = nil
//    static let userDefaultsKey = "UserPreference"
//
////    public var layoutDirection: LayoutDirection {
////        selectedLanguage == .arabic ? .rightToLeft : .leftToRight
////    }
//
//    public init(
//        areNotificationsEnabled: Bool = false // ,
////        selectedLanguage: AppLanguage? = nil
//    ) {
//        self.areNotificationsEnabled = areNotificationsEnabled
//        // self.selectedLanguage = selectedLanguage
//    }
//}
//
//extension UserPreferences: Codable {}
//
//extension UserPreferences: Equatable {}
//
//public struct UserPreferenceKey: EnvironmentKey {
//    public static var defaultValue: UserPreferences {
//        UserPreferences()
//    }
//}
//
//public extension EnvironmentValues {
//    var userPreference: UserPreferences {
//        get { self[UserPreferenceKey.self] }
//        set { self[UserPreferenceKey.self] = newValue }
//    }
//}
