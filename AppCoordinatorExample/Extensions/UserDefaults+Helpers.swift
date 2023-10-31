import Foundation

private enum Key {
  static let loggedInUsername = "loggedInUsername"
}

extension UserDefaults {
  var loggedInUsername: String? {
    get {
      string(forKey: Key.loggedInUsername)
    }
    set {
      set(newValue, forKey: Key.loggedInUsername)
    }
  }

  var isLoggedIn: Bool {
    loggedInUsername != nil
  }
}
