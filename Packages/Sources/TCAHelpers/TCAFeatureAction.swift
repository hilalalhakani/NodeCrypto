import Foundation
import ComposableArchitecture

public protocol TCAFeatureAction {
    associatedtype ViewAction
    associatedtype DelegateAction
    associatedtype InternalAction
    static func view(_: ViewAction) -> Self
    static func delegate(_: DelegateAction) -> Self
    static func `internal`(_: InternalAction) -> Self
}
