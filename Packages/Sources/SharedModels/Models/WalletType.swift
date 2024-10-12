import Foundation
import CasePaths

@CasePathable
public enum WalletType: String, Sendable {
  case rainbow
  case coinbase
  case metamask
}
