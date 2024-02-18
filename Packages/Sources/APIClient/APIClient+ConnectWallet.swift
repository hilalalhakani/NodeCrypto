import Dependencies
import Foundation
import SharedModels

extension APIClient {
    public struct ConnectWallet: Sendable {
        public var connectWallet: @Sendable (WalletType, String) async throws -> User
        public enum Error: Swift.Error {
            case accountNotFound
        }
   }
}

extension APIClient.ConnectWallet {
    public static var unimplemented: Self {
        .init(
            connectWallet: XCTestDynamicOverlay.unimplemented(
                #"@Dependency(\.apiClient).connectWallet.connectWallet"#
            )
        )
    }

    public static func mock() -> Self {
        @Dependency(\.continuousClock) var clock

        return .init(
            connectWallet: { walletType, deviceId in
                try await clock.sleep(for: .milliseconds(500))
                if walletType == .rainbow { throw APIClient.ConnectWallet.Error.accountNotFound}
                return User.mock1
            }
        )
    }
}

