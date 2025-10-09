import Foundation
import ComposableArchitecture

@CasePathable
public enum WalletType: String, Sendable {
  case rainbow
  case coinbase
  case metamask
}
