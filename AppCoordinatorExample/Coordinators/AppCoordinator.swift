import UIKit

@MainActor final class AppCoordinator {

  private var window: UIWindow!

  init(window: UIWindow) {
    self.window = window
  }

  func start() {
    window.makeKeyAndVisible()

    if UserDefaults.standard.isLoggedIn {
      showHome()
    }
    else {
      showLogin()
    }
  }

  // MARK: - Navigation

  // Note: coordinator.start(), where window.rootViewController is set up,
  // has to be outside Task. Otherwise app will crash because window has no
  // rootViewController at the end of application didFinishLaunchingWithOptions.

  func showHome() {
    let coordinator = HomeCoordinator(window: window)
    coordinator.delegate = self
    coordinator.start()

    Task {
      try? await coordinator.result()
      UserDefaults.standard.isLoggedIn = false
      showLogin()
    }
  }

  func showLogin() {
    let coordinator = LoginCoordinator(window: window)
    coordinator.start()

    Task {
      let result = try? await coordinator.result()
      print("Login result: \(String(describing: result))")
      UserDefaults.standard.isLoggedIn = true
      showHome()
    }
  }

  func showPurchase() {
    guard let viewController = window.rootViewController else { return }
    let coordinator = PurchaseCoordinator(presenterViewController: viewController)
    coordinator.start()

    Task {
      let result = try? await coordinator.result()
      print("Purchase result: \(String(describing: result))")
    }
  }

}

extension AppCoordinator: HomeCoordinatorDelegate {
  func homeCoordinatorDidSelectPurchase(_ coordinator: HomeCoordinator) {
    showPurchase()
  }
}
