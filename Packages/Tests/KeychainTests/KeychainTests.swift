import ComposableArchitecture
import Keychain
import NodeCryptoCore
import XCTest

final class KeychainTests: XCTestCase {
    let keychain = KeychainManager.live(service: "TestService")
    let key = KeychainKey(rawValue: "Test")
    let value = "TestValue".data(using: .utf8)!
    let key2 = KeychainKey(rawValue: "Test2")
    let value2 = "TestValue2".data(using: .utf8)!

    @MainActor
    /// Tests adding a new item with valid data. Expects successful addition without errors.
    func test_addItemWithValidData_success() {
        XCTAssertNoThrow {
            try self.keychain.set(self.value, self.key)
            let retrievedValue = try self.keychain.get(key: self.key)
            XCTAssertEqual(self.value, retrievedValue)
        }
    }

    @MainActor
    /// Tests retrieving an added item with valid data. Expects successful retrieval without errors.
    func test_retriveItem_success() {
        XCTAssertNoThrow { [self] in
            try self.keychain.set(self.value, self.key)
            let retrievedValue = try self.keychain.get(key: self.key)
            XCTAssertTrue(try self.keychain.contains(key: self.key))
            XCTAssertEqual(self.value, retrievedValue)
        }
    }

    @MainActor
    /// Tests deleting an added item with valid data. Expects successful deletion without errors.
    func test_deleteItem_success() {
        XCTAssertNoThrow {
            try self.keychain.set(self.value, self.key)
            try self.keychain.delete(self.key)
            XCTAssertFalse(try self.keychain.contains(key: self.key))
        }
    }

    /// Tests deleting an added item with valid data. Expects successful deletion without errors.
    func test_deleteAll_success() {
        XCTAssertNoThrow {
            try self.keychain.set(self.value, self.key)
            try self.keychain.set(self.value2, self.key2)

            try self.keychain.deleteAll()
            XCTAssertFalse(try self.keychain.contains(key: self.key))
            XCTAssertFalse(try self.keychain.contains(key: self.key2))
        }
    }

//    func test_sharedUser_doesntExist() throws {
//        withDependencies {
//            $0.keychainManager.get = { @Sendable _  in throw NSError(domain: "", code: 0) }
//        } operation: {
//            let sharedValue = SharedKeychainKey<User>(.user)
//            let user = sharedValue.load(initialValue: nil)
//            XCTAssertNil(user)
//        }
//    }
//
//    func test_sharedUser_exists() throws {
//        withDependencies {
//            $0.keychainManager.get = { @Sendable _ in try JSONEncoder().encode(User.mock1) }
//        } operation: {
//            let sharedValue = SharedKeychainKey<User>(.user)
//            let user = sharedValue.load(initialValue: nil)
//            XCTAssertNotNil(user)
//        }
//    }
}
