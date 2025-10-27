//
//  File.swift
//
//
//  Created by Hilal Hakkani on 21/04/2024.
//
import Combine
import Foundation
import ComposableArchitecture
import Dependencies

extension SharedReaderKey {
    public static func keychain<Value: Codable & Sendable & Equatable>(_ key: KeychainKey) -> Self
    where Self == SharedKeychainKey<Value?> {
        SharedKeychainKey(key: key)
    }
}

public struct SharedKeychainKey<Value: Codable & Sendable & Equatable>: SharedKey {
    let key: KeychainKey
    @Dependency(\.keychainManager) var keychainManager

    public init(key: KeychainKey) {
        self.key = key
    }

    public func subscribe(
      context _: LoadContext<Value>, subscriber _: SharedSubscriber<Value>
    ) -> SharedSubscription {
      SharedSubscription {}
    }

    public func load(context _: LoadContext<Value>, continuation: LoadContinuation<Value>) {
        guard let data = try? keychainManager.get(key), !data.isEmpty else {
            continuation.resumeReturningInitialValue()
            return
        }
        if let value = try? JSONDecoder().decode(Value.self, from: data) {
            continuation.resume(returning: value)
        } else {
            continuation.resumeReturningInitialValue()
        }
    }

    public func save(_ value: Value, context: SaveContext, continuation: SaveContinuation) {
        func isNil<T>(_ value: T) -> Bool {
            let mirror = Mirror(reflecting: value)
            return mirror.displayStyle == .optional && mirror.children.isEmpty
        }

        if isNil(value) {
            try? keychainManager.delete(key: key)
        } else {
            guard let data = try? JSONEncoder().encode(value) else { return }
            try? keychainManager.set(data, key)
        }
        continuation.resume()
    }


//    public func save(_ value: Value, immediately: Bool) {
//        func isNil<T>(_ value: T) -> Bool {
//            let mirror = Mirror(reflecting: value)
//            return mirror.displayStyle == .optional && mirror.children.isEmpty
//        }
//        if isNil(value) {
//            try? keychainManager.delete(key: key)
//        } else {
//            guard let data = try? JSONEncoder().encode(value) else { return }
//            try? keychainManager.set(data, key)
//        }
//    }
//
//    public func load(initialValue: Value?) -> Value? {
//        guard let data = try? keychainManager.get(key) else { return nil }
//        return try? JSONDecoder().decode(Value.self, from: data)
//    }
//
//    public func subscribe(
//        initialValue: Value?,
//        didSet receiveValue: @escaping (Value?) -> Void
//    ) -> SharedSubscription {
//        SharedSubscription {}
//    }
}

extension SharedKeychainKey: Hashable, Sendable {
    public static func == (lhs: SharedKeychainKey<Value>, rhs: SharedKeychainKey<Value>) -> Bool {
        lhs.key == rhs.key
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(key)
    }
}
