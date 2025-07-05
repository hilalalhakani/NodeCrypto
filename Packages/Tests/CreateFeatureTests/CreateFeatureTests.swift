
import ComposableArchitecture
import XCTest

@testable import CreateFeature

@MainActor
final class CreateFeatureTests: XCTestCase {
    func testFeatureInitialization() async {
        let store = TestStore(initialState: CreateFeature.State()) {
            CreateFeature()
        }

        XCTAssertNotNil(store)
    }
}
