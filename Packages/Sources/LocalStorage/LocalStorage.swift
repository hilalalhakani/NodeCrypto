//
//  File.swift
//  
//
//  Created by Hilal Hakkani on 08/04/2024.
//

import Foundation
import CoreData
import DependenciesAdditions
import Foundation
import SharedModels
import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

protocol StorableKeyProtocol {
    var stringValue: String { get }
    var valueTypeName: String { get }
    func encodeValueForStorage(_ value: Any) throws -> Data
    func decodeDataFromStorage(_ data: Data) throws -> Any
}

extension ResourceKey: StorableKeyProtocol {
    var stringValue: String {
        switch self.location {
        case let .local(string): return "local-\(string)"
        case let .url(url): return url.absoluteString
        }
    }

    var valueTypeName: String {
        _typeName(Output.self)
    }

    func encodeValueForStorage(_ value: Any) throws -> Data {
        let value = value as! Output
        switch Output.self {
        case is ImageDataResource.Type:
            return (value as! ImageDataResource).data
        case is PDFResource.Type:
            return (value as! PDFResource).data
        default:
            throw LocalStorageError.unsupportedType
        }
    }
    func decodeDataFromStorage(_ data: Data) throws -> Any {
        switch Output.self {
        case is ImageDataResource.Type:
            return ImageDataResource(data: data)
        case is PDFResource.Type:
            return PDFResource(data: data)
        default:
            throw LocalStorageError.unsupportedType
        }
    }
}

public struct LocalStorage: Sendable {
    public enum Destination: Sendable {
        case persistent
        case cache
    }
    var _get: @Sendable (_ key: Any) async throws -> Any
    var _set: @Sendable (_ value: Any, _ key: Any, Destination) async throws -> Void
    var _delete: @Sendable (_ key: Any) async throws -> Void

    init(
        get: @escaping @Sendable (_ key: Any) async throws -> Any,
        set: @escaping @Sendable (_ value: Any, _ key: Any, Destination) async throws -> Void,
        delete: @escaping @Sendable (_ key: Any) async throws -> Void
    ) {
        self._get = get
        self._set = set
        self._delete = delete
    }
}

extension LocalStorage {
    public func get<Output>(key: ResourceKey<Output>) async throws -> Output {
        try await self._get(key) as! Output
    }
    public func set<Output>(
        _ value: Output, forKey key: ResourceKey<Output>, destination: Destination
    ) async throws {
        try await self._set(value, key, destination)
    }
    public func delete<Output>(key: ResourceKey<Output>) async throws {
        try await self._delete(key)
    }
}

extension DependencyValues {
    public var localStorage: LocalStorage {
        get { self[LocalStorage.self] }
        set { self[LocalStorage.self] = newValue }
    }
}

extension LocalStorage: DependencyKey {

    public static var liveValue: LocalStorage {
        localStorage(with: PersistentContainer(bundle: .module))
    }

    public static var testValue: LocalStorage {
        localStorage(with: PersistentContainer(bundle: .module, inMemory: true))
    }

    public static var previewValue: LocalStorage {
        localStorage(
            with: PersistentContainer(bundle: .module, inMemory: true)
                .setUp(operation: { context in
                    // … Create preview data here (we can make a static function to allow customization)
                })
        )
    }

    static func localStorage(with persistentContainer: PersistentContainer) -> LocalStorage {
        @Dependency(\.date) var date
        let context = LockIsolated(persistentContainer.newBackgroundContext())

        return LocalStorage { key in
            guard let key = key as? StorableKeyProtocol else {
                throw LocalStorageError.invalidKey
            }
            let context = context.value
            return try await context.perform {
                let request = Item.fetchRequest()
                let predicate = NSPredicate(format: "%K LIKE %@", "key", key.stringValue)
                request.fetchLimit = 1
                request.predicate = predicate
                guard let data = try context.fetch(request).first?.payload else {
                    throw LocalStorageError.noItemFound
                }
                return try key.decodeDataFromStorage(data)
            }
        } set: { value, key, destination in
            guard let key = key as? StorableKeyProtocol else {
                throw LocalStorageError.invalidKey
            }
            let context = context.value
            try await withEscapedDependencies { continuation in
                try await context.perform {
                    try continuation.yield {
                        let item = destination == .cache ? CachedItem(context: context) : Item(context: context)
                        item.key = key.stringValue
                        item.payload = try key.encodeValueForStorage(value)
                        item.type = key.valueTypeName
                        item.creationDate = date.now
                        try context.save()
                    }
                }
            }

        } delete: { key in

            let context = context.value
            return try await context.perform {
                guard let key = key as? StorableKeyProtocol else {
                    throw LocalStorageError.invalidKey
                }
                let request = Item.fetchRequest()
                let predicate = NSPredicate(format: "%K LIKE %@", "key", key.stringValue)
                request.predicate = predicate
                for object in try context.fetch(request) {
                    context.delete(object)
                }
                if context.hasChanges {
                    try context.save()
                }
            }
        }
    }
}

public enum LocalStorageError: Error, Equatable {
    case invalidKey
    case unsupportedType
    case invalidSave
    case noItemFound
}
