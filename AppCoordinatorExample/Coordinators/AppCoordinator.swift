import UIKit

@MainActor final class AppCoordinator {

  private let window: UIWindow

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
    if UserDefaults.standard.isLoggedIn {
      showHome()
    }
    else {
      showLogin()
    }
  }

  // MARK: - Private

  private func showHome() {
    Task {
      let coordinator = HomeCoordinator(window: window)
      try? await coordinator.start()

      // When HomeCoordinator ends, it means we have logged out.
      UserDefaults.standard.isLoggedIn = false
      start()
    }
  }

  private func showLogin() {
    Task {
      let coordinator = LoginCoordinator(window: window)
      let result = try? await coordinator.start()

      // When LoginCoordinator ends, it means we have successfully logged in.
      print("Login result: \(String(describing: result))")
      UserDefaults.standard.isLoggedIn = true
      start()
    }
  }

}
