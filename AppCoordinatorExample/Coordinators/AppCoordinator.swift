import UIKit

@MainActor final class AppCoordinator {

  private let window: UIWindow

  init(window: UIWindow) {
    self.window = window

    // Note:
    // Need to set a dummy view controller to window.rootViewController here because
    // in coordinator.start(), where the correct viewController is set up, is an async task.
    // App will crash if rootViewController at the end of application didFinishLaunchingWithOptions.
    // It will be briefly visible, which should be ok for demo purpose.
    // In a real production app, you may want to handle this more gracefully.
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
