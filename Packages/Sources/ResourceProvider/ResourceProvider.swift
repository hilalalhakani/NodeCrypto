import ComposableArchitecture
import Dependencies
import DependenciesAdditions
import Foundation
import LocalStorage
import SharedModels
import SharedViews
import SwiftUI

public enum ResourceError: Error {
    case invalidKey
    case invalidData
    case resourceNotFound
}

public struct ResourceProvider: Sendable {
    fileprivate var _fetch: @Sendable (Any) async throws -> any Sendable
    public init(
        fetch: @escaping @Sendable (Any) async throws -> any Sendable
    ) {
        self._fetch = fetch
    }
}

extension ResourceProvider {
    public func fetch<T: Sendable>(key: ResourceKey<T>) async throws -> T {
        try await self._fetch(key) as! T
    }
}

extension DependencyValues {
    public var resourceProvider: ResourceProvider {
        get { self[ResourceProvider.self] }
        set { self[ResourceProvider.self] = newValue }
    }
}

extension ResourceProvider: DependencyKey {

    public static var liveValue: ResourceProvider {

        @Dependency(\.urlSession) var urlSession
        @Dependency(\.logger["ResourceProvider"]) var logger
        @Dependency(\.localStorage) var localStorage

        return ResourceProvider { key in
            switch key {
                case let key as ResourceKey<ImageDataResource>:
                    return try await fetchImage(key: key)
                default:
                    print("Unhandled resource key: \(key)")
                    throw ResourceProviderError.unsupportedType
            }
        }

        @Sendable func fetchImage(
            key: ResourceKey<ImageDataResource>
        ) async throws -> ImageDataResource {
            switch key.location {
                case .url(let url):

                    if let localValue = try? await localStorage.get(key: key) {
                        return localValue
                    }

                    let data = try await urlSession.data(for: URLRequest(url: url)).0
                    let resource = ImageDataResource(data: data)
                    guard resource.image != nil else {
                        throw ResourceError.invalidData
                    }
                    try await localStorage.set(resource, forKey: key, destination: .cache)
                    return resource

                case .local:
                    //Read some values from local directory (or a database)
                    if let localValue = try? await localStorage.get(key: key),
                        localValue.image != nil
                    {
                        return localValue
                    }
                    throw ResourceError.resourceNotFound
            }
        }
    }

    public static var testValue: ResourceProvider {
        .liveValue
    }

    public static var previewValue: ResourceProvider {
        .liveValue
    }

}

public protocol ViewRepresentable {
    associatedtype ViewType: View
    var viewRepresentation: ViewType { get }
}

extension ImageDataResource: ViewRepresentable {
    public var viewRepresentation: Image? { self.image }
}

@Reducer
struct ResourceModel<Output: Sendable> {
    @ObservableState
    struct State {
        let key: ResourceKey<Output>
        var output: Result<Output, Error>?
    }
    enum Action {
        case load
        case onResource(Result<Output, Error>)
    }
    @Dependency(\.resourceProvider) var resourceProvider
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
            case .load:
                return .run { [key = state.key] send in
                    await send(
                        .onResource(
                            .init(catching: {
                                try await resourceProvider.fetch(key: key)
                            })
                        )
                    )
                }
            case .onResource(let output):
                state.output = output
                return .none
        }
    }
}

public struct ResourceView<Output: ViewRepresentable>: View where Output: Sendable {
    let store: StoreOf<ResourceModel<Output>>
    public init(key: ResourceKey<Output>) {
        self.store = .init(
            initialState: .init(key: key),
            reducer: { ResourceModel() }
        )
    }

    public var body: some View {
        WithPerceptionTracking {
            if let _ = NSClassFromString("XCTest") {
                Color.red
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            else {
                ZStack {
                    switch store.state.output {
                        case let .some(.success(output)):
                            output.viewRepresentation
                        case let .some(.failure(error)):
                            Text(String(describing: error))
                        case .none:
                            Rectangle()
                                .foregroundStyle(.black.opacity(0.1))
                                .task {
                                    store.send(.load)
                                }
                    }
                }
            }
        }
    }
}

public enum ResourceProviderError: Error, Equatable {
    case unsupportedType
}

#Preview {
    ResourceView(key: imageKey)
        .frame(width: 300, height: 400)
}

let imageKey = ResourceKey<ImageDataResource>(
    location: .url(URL(string: "https://via.placeholder.com/360x360")!)
)
