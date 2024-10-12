//
//  File.swift
//
//
//  Created by Hilal Hakkani on 21/04/2024.
//

import Combine
import Foundation
import NodeCryptoCore

extension PersistenceReaderKey {
    public static func keychain<Value: Codable & Sendable & Equatable>(_ key: KeychainKey) -> Self
    where Self == SharedKeychainKey<Value?> {
        SharedKeychainKey(key: key)
    }
}

public struct SharedKeychainKey<Value: Codable & Sendable & Equatable & AnyOptional>: PersistenceKey
{
    public let id = UUID()
    let key: KeychainKey
    @Dependency(\.keychainManager) var keychainManager

    public func save(_ value: Value) {
        if value.isNil {
            try? keychainManager.delete(key: key)
        }
        else {
            guard let data = try? JSONEncoder().encode(value) else { return }
            try? keychainManager.set(data, key)
        }
    }

    public func load(initialValue: Value?) -> Value? {
        guard let data = try? keychainManager.get(key) else { return nil }
        return try? JSONDecoder().decode(Value.self, from: data)
    }

}

extension SharedKeychainKey: Hashable, Sendable {
    public static func == (lhs: SharedKeychainKey<Value>, rhs: SharedKeychainKey<Value>) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

public protocol AnyOptional {
    var isNil: Bool { get }
}

extension Optional: AnyOptional, Sendable {
    public var isNil: Bool { self == nil }
}

public final class UserManager: @unchecked Sendable {
    @Shared(.keychain(.user)) public var user: User? {
        didSet {
            publisher.send(user)
        }
    }
    public let publisher = PassthroughSubject<User?, Never>()
}

public enum UserManagerKey: DependencyKey {
    public static let liveValue = UserManager()
    public static let testValue = UserManager()
}

extension DependencyValues {
    public var userManager: UserManager {
        get { self[UserManagerKey.self] }
        set { self[UserManagerKey.self] = newValue }
    }
}
