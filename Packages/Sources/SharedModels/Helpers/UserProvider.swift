//
//  File.swift
//
//
//  Created by HH on 17/12/2023.
//

import Foundation
import Dependencies
@preconcurrency import Combine

public struct UserProvider: Sendable {
    var _get: @Sendable () -> User?
    var _set: @Sendable (User?) -> Void
    public var _stream: @Sendable () -> AsyncStream<User?>
    public init(
        get: @escaping @Sendable () -> User?,
        set: @escaping @Sendable (User?) -> Void,
        stream: @escaping @Sendable () -> AsyncStream<User?>
    ) {
        _get = get
        _set = set
        _stream = stream
    }
}

extension UserProvider {
  public var get: User? { _get() }
  public func set(_ user: User?) { _set(user) }
  public var stream: AsyncStream<User?> { _stream() }
}

extension UserProvider: DependencyKey {
  public static var liveValue: UserProvider {
    let user = LockIsolated(User?.none)
    let currentValueSubject = CurrentValueSubject<User?, Never>(User?.none)
    return UserProvider {
      user.value
    } set: { newValue in
      user.withValue {
        $0 = newValue
        currentValueSubject.send(newValue)
      }
    } stream: {
      currentValueSubject.values.eraseToStream()
    }
  }

  public static var testValue: UserProvider {
    .liveValue
  }

  public static var previewValue: UserProvider {
    let value = UserProvider.liveValue
    value.set(.mock1)
    return value
  }
}

public extension DependencyValues {
    var user: UserProvider {
        get { self[UserProvider.self] }
        set { self[UserProvider.self] = newValue }
    }
}
