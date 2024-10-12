import ComposableArchitecture
import Foundation

public struct NestedAction<State: Sendable, Action, ViewAction>: Reducer {

    let toChildAction: CaseKeyPath<Action, ViewAction>
    let toEffect: (inout State, ViewAction) -> Effect<Action>


    public init(_ toChildAction: CaseKeyPath<Action, ViewAction>, toEffect: @escaping (inout State, ViewAction) -> Effect<Action>) where Action: CasePathable {
        self.toChildAction = toChildAction
        self.toEffect = toEffect
    }


    public func reduce(into state: inout State, action: Action) -> Effect<Action> {

        guard let childAction = AnyCasePath(self.toChildAction).extract(from: action) else {
            return .none
        }
        return toEffect(&state, childAction)
    }
}
