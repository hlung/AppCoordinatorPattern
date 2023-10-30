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
    // I want to make delegate assignment part of addChild(),
    // but there are some protocol/associatedType problems.
    coordinator.delegate = self
    addChild(coordinator)
  }

  func showLogin() {
    let coordinator = LoginCoordinator(window: window)
    coordinator.delegate = self
    addChild(coordinator)
  }

  func showPurchase() {
    let coordinator = PurchaseCoordinator(window: window)
    coordinator.delegate = self
    addChild(coordinator)
  }

}

extension AppCoordinator: HomeCoordinatorDelegate {
  func homeCoordinatorDidLogOut(_ coordinator: HomeCoordinator) {
    UserDefaults.standard.isLoggedIn = false
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
    UserDefaults.standard.isLoggedIn = true
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
