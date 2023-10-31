import UIKit

protocol AppCoordinatorDelegate: AnyObject {}

final class AppCoordinator: ParentCoordinator {

  let window: UIWindow
  var children: [any Coordinator] = []
  weak var delegate: AppCoordinatorDelegate?

  init(window: UIWindow) {
    self.window = window
  }

  func start() {
    if UserDefaults.standard.isLoggedIn {
      showHome()
    }
    else {
      showLogin()
    }
  }

  // MARK: - Navigation

  func showHome() {
    let coordinator = HomeCoordinator(window: window)
    addChild(coordinator)
    // I want to make delegate assignment part of addChild(),
    // but there are some protocol/associatedType problems.
    coordinator.delegate = self
    coordinator.start()
  }

  func showLogin() {
    let coordinator = LoginCoordinator(window: window)
    addChild(coordinator)
    coordinator.delegate = self
    coordinator.start()
  }

  func showPurchase() {
    let coordinator = PurchaseCoordinator(window: window)
    addChild(coordinator)
    coordinator.delegate = self
    coordinator.start()
  }

}

extension AppCoordinator: HomeCoordinatorDelegate {
  func homeCoordinatorDidLogOut(_ coordinator: HomeCoordinator) {
    UserDefaults.standard.loggedInUsername = nil
    coordinator.removeFromParent()
    showLogin()
  }

  func homeCoordinatorDidSelectPurchase(_ coordinator: HomeCoordinator) {
    showPurchase()
  }
}

extension AppCoordinator: LoginCoordinatorDelegate {
  func loginCoordinator(_ coordinator: LoginCoordinator, didLogInWith username: String) {
    print("Login result: \(username)")
    UserDefaults.standard.loggedInUsername = username
    coordinator.removeFromParent()
    showHome()
  }
}

extension AppCoordinator: PurchaseCoordinatorDelegate {
  func purchaseCoordinatorDidPurchase(_ coordinator: PurchaseCoordinator) {
    print("Purchase OK")
    coordinator.removeFromParent()
  }

  func purchaseCoordinatorDidCancel(_ coordinator: PurchaseCoordinator) {
    print("Purchase Cancelled")
    coordinator.removeFromParent()
  }
}
