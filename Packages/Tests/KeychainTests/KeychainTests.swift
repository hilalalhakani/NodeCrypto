import ComposableArchitecture
import Testing
import Keychain
import NodeCryptoCore
import XCTest


//This is crashing since keychain sharing is turned off

//@MainActor
//@Suite(.serialized)
//struct KeychainTests {
//    let keychain = KeychainManager.live(service: "TestService")
//    let key = KeychainKey.user
//    let value = "TestValue".data(using: .utf8)!
//
//    /// Tests adding a new item with valid data. Expects successful addition without errors.
//    @Test func test_addItemWithValidData_success() {
//        #expect(throws: Never.self) {
//            setup()
//            try! self.keychain.set(self.value, self.key)
//            let retrievedValue = try! self.keychain.get(key: self.key)
//            #expect(self.value == retrievedValue)
//        }
//    }
//
//    @Test
//    /// Tests retrieving an added item with valid data. Expects successful retrieval without errors.
//    func test_retriveItem_success() {
//        #expect(throws: Never.self) { [self] in
//            try self.keychain.set(self.value, self.key)
//            let retrievedValue = try self.keychain.get(key: self.key)
//            #expect(try self.keychain.contains(key: self.key) == true)
//            #expect(self.value == retrievedValue)
//        }
//    }
//
//    @Test
//    /// Tests deleting an added item with valid data. Expects successful deletion without errors.
//    func test_deleteItem_success() {
//        #expect(throws: Never.self) {
//            try self.keychain.set(self.value, self.key)
//            try self.keychain.delete(self.key)
//            #expect(try self.keychain.contains(key: self.key) == false)
//        }
//    }
//
//    @Test
//    /// Tests deleting an added item with valid data. Expects successful deletion without errors.
//    func test_deleteAll_success() {
//        #expect(throws: Never.self) {
//            try self.keychain.set(self.value, self.key)
//
//            try self.keychain.deleteAll()
//            #expect(try self.keychain.contains(key: self.key) == false)
//        }
//    }
//
//    @Test
//    func test_sharedUser_doesntExist() throws {
//        withDependencies {
//            $0.keychainManager.get = { @Sendable _  in throw NSError(domain: "", code: 0) }
//        } operation: {
//            let sharedValue = SharedKeychainKey<User>(key: .user)
//            let user = sharedValue.load(initialValue: nil)
//            #expect(user == nil)
//        }
//    }
//
//    @Test
//    func test_sharedUser_exists() throws {
//        withDependencies {
//            $0.keychainManager.get = { @Sendable _ in try JSONEncoder().encode(User.mock1) }
//        } operation: {
//            let sharedValue = SharedKeychainKey<User>(key: .user)
//            let user = sharedValue.load(initialValue: nil)
//            #expect(user != nil)
//        }
//    }
//
//    func setup() {
//        try? keychain.deleteAll()
//    }
//}
