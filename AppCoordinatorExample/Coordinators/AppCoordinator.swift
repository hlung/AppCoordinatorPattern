import UIKit

@MainActor final class AppCoordinator {

  private let window: UIWindow
  private var observation: NSKeyValueObservation?

  init(window: UIWindow) {
    self.window = window

    // Note:
    // Need to set a dummy view controller to window.rootViewController here because the rootViewController
    // set up in coordinator.start() is async. It won't finish when application didFinishLaunchingWithOptions ends
    // and app will crash.
    let dummyViewController = UIViewController()
    window.rootViewController = dummyViewController
    window.makeKeyAndVisible()
  }

  func start() {
    observation = UserDefaults.standard.observe(
      \.isLoggedIn,
       options: [.initial, .new]
    ) { [weak self] userDefaults, change in

      guard let self = self else { return }
      Task { @MainActor in
        let isLoggedIn = change.newValue ?? false
        if isLoggedIn {
          self.showHome()
        }
        else {
          self.showLogin()
        }
      }
    }
  }

  // MARK: - Private

  private func showHome() {
    Task {
      let coordinator = HomeCoordinator(window: window)
      try? await coordinator.start()

      // When HomeCoordinator ends, it means we have logged out.
      UserDefaults.standard.isLoggedIn = false
    }
  }

  private func showLogin() {
    Task {
      let coordinator = LoginCoordinator(window: window)
      let result = try? await coordinator.start()
      print("Login result: \(String(describing: result))")

      // When LoginCoordinator ends, it means we have successfully logged in.
      UserDefaults.standard.isLoggedIn = true
    }
  }

}

extension UserDefaults {
  private enum Key {
    static let isLoggedIn = "isLoggedIn"
  }

  @objc var isLoggedIn: Bool {
    get {
      bool(forKey: Key.isLoggedIn)
    }
    set {
      setValue(newValue, forKey: Key.isLoggedIn)
    }
  }
}
