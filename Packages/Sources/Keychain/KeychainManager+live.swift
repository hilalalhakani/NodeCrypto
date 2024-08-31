import Foundation
//
//  File.swift
//
//
//  Created by HH on 20/04/2023.
//
import Security

public extension KeychainManager {
    static func live(service: String) -> Self {
        .init { value, key in

            let status = SecItemCopyMatching(
                [
                    kSecClass: kSecClassGenericPassword,
                    kSecAttrAccount: key.rawValue,
                    kSecAttrService: service,
                    kSecReturnData: false
                ] as NSDictionary, nil
            )
            switch status {
            case errSecSuccess:
                //Update

                    let updateQuery: [CFString: Any] = [
                        kSecClass: kSecClassGenericPassword,
                        kSecAttrService: service as CFString,
                        kSecAttrAccount: key.rawValue
                    ]

                    let newAttributes: [CFString: Any] = [
                        kSecAttrAccount: key.rawValue,
                        kSecValueData: value
                    ]

                   let status = SecItemUpdate(updateQuery as CFDictionary, newAttributes as CFDictionary)

                    guard status == errSecSuccess else { throw Error.operationError }
            case errSecItemNotFound:
                //Add
                    let status = SecItemAdd(
                        [
                            kSecClass: kSecClassGenericPassword,
                            kSecAttrAccount: key.rawValue,
                            kSecAttrService: service,
                            kSecAttrAccessible: kSecAttrAccessibleAfterFirstUnlock,
                            kSecValueData: value
                        ] as NSDictionary, nil
                    )
                    guard status == errSecSuccess else { throw Error.operationError }


            default:
                throw Error.securityError(status)
            }
        } delete: { key in

            let status = SecItemDelete(
                [
                    kSecClass: kSecClassGenericPassword,
                    kSecAttrAccount: key.rawValue,
                    kSecAttrService: service
                ] as NSDictionary)
            guard status == errSecSuccess else { throw Error.operationError }

        } deleteAll: {
            let status = SecItemDelete(
                [
                    kSecClass: kSecClassGenericPassword
                ] as NSDictionary)
            guard status == errSecSuccess else { throw Error.operationError }

        } get: { key in

            /// Result of getting the item
            var result: AnyObject?
            /// Status for the query
            let status = SecItemCopyMatching(
                [
                    kSecClass: kSecClassGenericPassword,
                    kSecAttrAccount: key.rawValue,
                    kSecAttrService: service,
                    kSecReturnData: true
                ] as NSDictionary, &result
            )
            // Switch to conditioning statement
            switch status {
            case errSecSuccess:
                if let data = result as? Data {
                    return data
                } else {
                    throw Error.itemNotFound
                }
            case errSecItemNotFound:
                throw Error.itemNotFound
            default:
                throw Error.securityError(status)
            }

        } contains: { key in
            let status = SecItemCopyMatching(
                [
                    kSecClass: kSecClassGenericPassword,
                    kSecAttrAccount: key.rawValue,
                    kSecAttrService: service,
                    kSecReturnData: false
                ] as NSDictionary, nil
            )
            switch status {
            case errSecSuccess:
                return true
            case errSecItemNotFound:
                return false
            default:
                throw Error.securityError(status)
            }
        }
    }
}
