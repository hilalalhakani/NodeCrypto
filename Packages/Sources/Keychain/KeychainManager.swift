//
//  File.swift
//
//
//  Created by HH on 20/04/2023.
//

import Foundation
import NodeCryptoCore

@DependencyClient
public struct KeychainManager: Sendable {
    public var set: @Sendable (_ value: Data, _ key: KeychainKey) throws -> Void
    public var delete: @Sendable (_ key: KeychainKey) throws -> Void
    public var deleteAll: @Sendable () throws -> Void
    public var get: @Sendable (_ key: KeychainKey) throws -> Data
    public var contains: @Sendable (_ key: KeychainKey) throws -> Bool

    public enum Error: Swift.Error, Equatable {
        case securityError(OSStatus)
        case operationError
        case itemNotFound

        var localizedDescription: String {
            switch self {
            case .operationError:
                return "Error performing operation in keychain"
            case .itemNotFound:
                return "Item not found in keychain"
            case let .securityError(status):
                return "Security error: \(SecCopyErrorMessageString(status, nil) as? String ?? "")"
            }
        }

        public static func ~= (keychainError: KeychainManager.Error, value: OSStatus) -> Bool {
            switch keychainError {
            case let .securityError(status):
                return status == value
            default:
                return false
            }
        }
    }
}

public enum KeychainKey: String, Sendable {
    case user
}

public extension DependencyValues {
    var keychainManager: KeychainManager {
        get { self[KeychainManager.self] }
        set { self[KeychainManager.self] = newValue }
    }
}

extension KeychainManager: DependencyKey {
    public static let testValue: KeychainManager = .test()
    public static var liveValue: KeychainManager { .live(service: "Node-Crypto") }
}
