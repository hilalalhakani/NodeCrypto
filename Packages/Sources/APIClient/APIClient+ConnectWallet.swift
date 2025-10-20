@_exported import Dependencies
import Foundation
@_exported import SharedModels

extension APIClient {
    public struct ConnectWallet: Sendable {
        public var connectWallet: @Sendable (WalletType, String) async throws -> User
        public enum Error: Swift.Error {
            case accountNotFound
        }
        public init(
            _ connectWallet: @escaping @Sendable (WalletType, String) async throws -> User = { _,_ in .mock1 }
        ) {
            self.connectWallet = connectWallet
        }
   }
}

