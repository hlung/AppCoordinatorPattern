import Foundation

private enum Key {
  static let loggedInUsername = "loggedInUsername"
  static let onboardingShown = "onboardingShown"
  static let consent = "consent"
  static let emailVerified = "emailVerified"
}

extension UserDefaults {
  var loggedInUsername: String? {
    get { string(forKey: Key.loggedInUsername) }
    set { set(newValue, forKey: Key.loggedInUsername) }
  }

  var isLoggedIn: Bool {
    loggedInUsername != nil
  }

  var onboardingShown: Bool {
    get { bool(forKey: Key.onboardingShown) }
    set { set(newValue, forKey: Key.onboardingShown) }
  }

  var consent: String? {
    get { string(forKey: Key.consent) }
    set { set(newValue, forKey: Key.consent) }
  }

  var emailVerified: Bool {
    get { bool(forKey: Key.emailVerified) }
    set { set(newValue, forKey: Key.emailVerified) }
  }

  func clear() {
    loggedInUsername = nil
    onboardingShown = false
    consent = nil
    emailVerified = false
  }

}

protocol UsernameProvider {
  var loggedInUsername: String? { get set }
  mutating func clear()
}
extension UserDefaults: UsernameProvider {}
