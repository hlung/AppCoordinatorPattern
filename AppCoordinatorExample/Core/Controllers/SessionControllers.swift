import Foundation

class SessionController: SessionProvider {

  enum NotificationName {
    static let sessionControllerDidUpdate = NSNotification.Name("sessionControllerDidUpdate")
  }

  var session: Session? {
    didSet {
      UserDefaults.standard.loggedInUsername = session?.user.username
      NotificationCenter.default.post(name: NotificationName.sessionControllerDidUpdate, object: nil)
    }
  }

  func loadSavedSession() {
    if let username = UserDefaults.standard.loggedInUsername {
      self.session = Session(user: User(username: username))
    }
  }

}
