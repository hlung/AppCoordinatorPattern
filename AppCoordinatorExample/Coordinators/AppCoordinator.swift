import UIKit

@MainActor final class AppCoordinator {

  private var window: UIWindow!

  init(window: UIWindow) {
    self.window = window
  }

  func start() {
    // Note:
    // Need to set a dummy view controller to window.rootViewController here because
    // in coordinator.start(), where the correct viewController is set up, is an async task.
    // App will crash if rootViewController at the end of application didFinishLaunchingWithOptions.
    // It will be briefly visible, which should be ok for demo purpose.
    // In a real production app, you may want to handle this more gracefully.
    window.rootViewController = UIViewController()
    window.makeKeyAndVisible()

    if UserDefaults.standard.isLoggedIn {
      showHome()
    }
    else {
      showLogin()
    }
  }

  // MARK: - Navigation

  func showHome() {
    Task {
      let coordinator = HomeCoordinator(window: window)
      coordinator.delegate = self
      try? await coordinator.start()
      UserDefaults.standard.isLoggedIn = false
      showLogin()
    }
  }

  func showLogin() {
    Task {
      let coordinator = LoginCoordinator(window: window)
      let result = try? await coordinator.start()
      print("Login result: \(String(describing: result))")
      UserDefaults.standard.isLoggedIn = true
      showHome()
    }
  }

  func showPurchase() {
    Task {
      guard let viewController = window.rootViewController else { return }
      let coordinator = PurchaseCoordinator(presenterViewController: viewController)
      let result = try? await coordinator.start()
      print("Purchase result: \(String(describing: result))")
    }
  }

}

extension AppCoordinator: HomeCoordinatorDelegate {
  func homeCoordinatorDidSelectPurchase(_ coordinator: HomeCoordinator) {
    showPurchase()
  }
}
