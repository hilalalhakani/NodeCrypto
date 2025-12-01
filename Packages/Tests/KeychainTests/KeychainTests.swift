//import ComposableArchitecture
//import Testing
//import Keychain
//import XCTest
//import SharedModels
//
////This is crashing since keychain sharing is turned off
//
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
//            cleanup()
//            try setValue()
//            let retrievedValue = try self.keychain.get(key: self.key)
//            #expect(self.value == retrievedValue)
//        }
//    }
//
//    @Test
//    /// Tests retrieving an added item with valid data. Expects successful retrieval without errors.
//    func test_retriveItem_success() {
//        #expect(throws: Never.self) { [self] in
//            cleanup()
//            try setValue()
//            let retrievedValue = try self.keychain.get(key: self.key)
//            #expect(try self.keychain.contains(key: self.key) == true)
//            #expect(self.value == retrievedValue)
//        }
//    }
////
////    @Test
////    /// Tests deleting an added item with valid data. Expects successful deletion without errors.
////    func test_deleteItem_success() {
////        #expect(throws: Never.self) {
////            cleanup()
////            try setValue()
////            try self.keychain.delete(self.key)
////            #expect(try self.keychain.contains(key: self.key) == false)
////        }
////    }
////
////    @Test
////    /// Tests deleting an added item with valid data. Expects successful deletion without errors.
////    func test_deleteAll_success() {
////        #expect(throws: Never.self) {
////            cleanup()
////            try setValue()
////            try self.keychain.deleteAll()
////            #expect(try self.keychain.contains(key: self.key) == false)
////        }
////    }
//
//
//    func setValue() throws {
//        try keychain.set(value, key)
//    }
//
//    func cleanup() {
//        try? keychain.deleteAll()
//    }
//}
