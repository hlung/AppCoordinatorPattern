import UIKit

final class AppCoordinator: ParentCoordinator {

  private var window: UIWindow!

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
    coordinator.teardown = { [weak self] coordinator in
      UserDefaults.standard.isLoggedIn = false
      self?.showLogin()
      self?.children.removeAll(where: { $0 === coordinator })
    }
    coordinator.start()
    children.append(coordinator)
  }

  func showLogin() {
    let coordinator = LoginCoordinator(window: window)
    coordinator.teardown = { [weak self] coordinator in
      print("Login result: \(coordinator.result)")
      UserDefaults.standard.isLoggedIn = true
      self?.showHome()
      self?.children.removeAll(where: { $0 === coordinator })
    }
    coordinator.start()
    children.append(coordinator)
  }

  func showPurchase() {
    guard let viewController = window.rootViewController else { return }
    let coordinator = PurchaseCoordinator(presenterViewController: viewController)
    coordinator.teardown = { [weak self] coordinator in
      print("Purchase result: \(coordinator.result)")
      self?.children.removeAll(where: { $0 === coordinator })
    }
    coordinator.start()
    children.append(coordinator)
  }

}

extension AppCoordinator: HomeCoordinatorDelegate {
  func homeCoordinatorDidSelectPurchase(_ coordinator: HomeCoordinator) {
    showPurchase()
  }
}
