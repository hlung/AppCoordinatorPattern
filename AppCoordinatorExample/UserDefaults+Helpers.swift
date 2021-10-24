import Foundation

private enum Key {
  static let isLoggedIn = "isLoggedIn"
}

extension UserDefaults {
  var isLoggedIn: Bool {
    get {
      bool(forKey: Key.isLoggedIn)
    }
    set {
      setValue(newValue, forKey: Key.isLoggedIn)
    }
  }
}
