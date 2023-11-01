import UIKit

final class AppCoordinator: ParentCoordinator {

  let rootViewController: UINavigationController
  var childCoordinators: [any Coordinator] = []

  init(navigationController: UINavigationController) {
    self.rootViewController = navigationController
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
    let coordinator = HomeCoordinator(navigationController: rootViewController)
    childCoordinators.append(coordinator)
    // I want to make delegate assignment part of addChild(),
    // but there are some protocol/associatedType problems.
    coordinator.delegate = self
    coordinator.start()
  }

  func showLogin() {
    let coordinator = LoginCoordinator(navigationController: rootViewController)
    childCoordinators.append(coordinator)
    coordinator.delegate = self
    coordinator.start()
  }

  func showPurchase() {
    let coordinator = PurchaseCoordinator(navigationController: rootViewController)
    childCoordinators.append(coordinator)
    coordinator.delegate = self
    coordinator.start()
  }

}

extension AppCoordinator: HomeCoordinatorDelegate {
  func homeCoordinatorDidLogOut(_ coordinator: HomeCoordinator) {
    UserDefaults.standard.loggedInUsername = nil
    childCoordinators.removeAll(where: { $0 === self })
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
    childCoordinators.removeAll(where: { $0 === self })
    showHome()
  }
}

extension AppCoordinator: PurchaseCoordinatorDelegate {
  func purchaseCoordinatorDidPurchase(_ coordinator: PurchaseCoordinator) {
    print("Purchase OK")
    childCoordinators.removeAll(where: { $0 === self })
  }

  func purchaseCoordinatorDidCancel(_ coordinator: PurchaseCoordinator) {
    print("Purchase Cancelled")
    childCoordinators.removeAll(where: { $0 === self })
  }
}
