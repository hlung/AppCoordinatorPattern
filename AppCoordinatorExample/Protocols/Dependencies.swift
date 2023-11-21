import Foundation

protocol UsernameProvider {
  var loggedInUsername: String? { get set }
  mutating func clear()
}
