import ComposableArchitecture
import Keychain
import XCTest

@MainActor
final class KeychainTests: XCTestCase {
    let keychain = KeychainManager.live(service: "TestService")
    let key = KeychainKey(rawValue: "Test")
    let value = "TestValue".data(using: .utf8)!
    let key2 = KeychainKey(rawValue: "Test2")
    let value2 = "TestValue2".data(using: .utf8)!

    /// Tests adding a new item with valid data. Expects successful addition without errors.
    func test_addItemWithValidData_success() async {
        XCTAssertNoThrow {
            try await self.keychain.set(self.value, self.key)
            let retrievedValue = try await self.keychain.get(key: self.key)
            XCTAssertEqual(self.value, retrievedValue)
        }
    }

    /// Tests retrieving an added item with valid data. Expects successful retrieval without errors.
    func test_retriveItem_success() async {
        XCTAssertNoThrow { [self] in
            try await self.keychain.set(self.value, self.key)
            let retrievedValue = try await self.keychain.get(key: self.key)
            XCTAssertTrue(try self.keychain.contains(key: self.key))
            XCTAssertEqual(self.value, retrievedValue)
        }
    }

    /// Tests deleting an added item with valid data. Expects successful deletion without errors.
    func test_deleteItem_success() async {
        XCTAssertNoThrow {
            try await self.keychain.set(self.value, self.key)
            try await self.keychain.delete(self.key)
            XCTAssertFalse(try self.keychain.contains(key: self.key))
        }
    }

    /// Tests deleting an added item with valid data. Expects successful deletion without errors.
    func test_deleteAll_success() async {
        XCTAssertNoThrow {
            try await self.keychain.set(self.value, self.key)
            try await self.keychain.set(self.value2, self.key2)

            try await self.keychain.deleteAll()
            XCTAssertFalse(try self.keychain.contains(key: self.key))
            XCTAssertFalse(try self.keychain.contains(key: self.key2))
        }
    }
}
