import UIKit

final class AppCoordinator: Coordinator {

  let window: UIWindow
  var children: [AnyObject] = []

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
    window.makeKeyAndVisible()
  }

  // MARK: - Navigation

  func showHome() {
    let coordinator = HomeCoordinator(window: window)
    coordinator.delegate = self
    coordinator.start()
    children.append(coordinator)
  }

  func showLogin() {
    let coordinator = LoginCoordinator(window: window)
    coordinator.delegate = self
    coordinator.start()
    children.append(coordinator)
  }

  func showPurchase() {
    let coordinator = PurchaseCoordinator(window: window)
    coordinator.delegate = self
    coordinator.start()
    children.append(coordinator)
  }

}

extension AppCoordinator: HomeCoordinatorDelegate {
  func homeCoordinatorDidLogOut(_ coordinator: HomeCoordinator) {
    UserDefaults.standard.isLoggedIn = false
    children.removeAll(where: { $0 === coordinator })
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
    children.removeAll(where: { $0 === coordinator })
    showHome()
  }
}

extension AppCoordinator: PurchaseCoordinatorDelegate {
  func purchaseCoordinatorDidPurchase(_ coordinator: PurchaseCoordinator) {
    print("Purchase OK")
    children.removeAll(where: { $0 === coordinator })
  }

  func purchaseCoordinatorDidCancel(_ coordinator: PurchaseCoordinator) {
    print("Purchase Cancelled")
    children.removeAll(where: { $0 === coordinator })
  }
}
