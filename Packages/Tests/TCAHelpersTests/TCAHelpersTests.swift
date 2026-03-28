import ComposableArchitecture
import Testing
@testable import TCAHelpers
import Foundation

@CasePathable
enum TestAction: Equatable {
    case view(TestViewAction)
    case other
}

enum TestViewAction: Equatable {
    case buttonTapped
}

struct TestState: Equatable {
    var tapped = false
}

@MainActor
struct TCAHelpersTests {
    @Test
    func test_nestedAction_extractsAndReduces() async {
        let reducer = NestedAction<TestState, TestAction, TestViewAction>(\.view) { state, action in
            if case .buttonTapped = action {
                state.tapped = true
            }
            return .none
        }
        
        var state = TestState()
        let _ = reducer.reduce(into: &state, action: .view(.buttonTapped))
        
        #expect(state.tapped == true)
    }

    @Test
    func test_nestedAction_ignoresUnmatchedAction() async {
        let reducer = NestedAction<TestState, TestAction, TestViewAction>(\.view) { state, action in
            state.tapped = true
            return .none
        }
        
        var state = TestState()
        let _ = reducer.reduce(into: &state, action: .other)
        
        #expect(state.tapped == false)
    }
}
