//
//  AppCoordinator.swift
//  AppCoordinatorExample
//
//  Created by Kolyutsakul, Thongchai on 17/10/21.
//

import UIKit

final class AppCoordinator {

  static var shared = AppCoordinator()

  private var window: UIWindow!
  private var childCoordinators: [AnyObject] = []

  func setup(with window: UIWindow) {
    self.window = window
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
//    coordinator.completion = { [weak self] coordinator in
//      UserDefaults.standard.isLoggedIn = false
//      self?.childCoordinators.removeAll(where: { $0 === coordinator })
//      self?.showLogin()
//    }
    coordinator.delegate = self
    coordinator.start()
    childCoordinators.append(coordinator)
  }

  func showLogin() {
    let coordinator = LoginCoordinator(window: window)
//    coordinator.completion = { [weak self] coordinator in
//      print("Login result: \(coordinator.result)")
//      UserDefaults.standard.isLoggedIn = true
//      self?.childCoordinators.removeAll(where: { $0 === coordinator })
//      self?.showHome()
//    }
    coordinator.start()
    childCoordinators.append(coordinator)
  }

  func showPurchase() {
    guard let viewController = window.rootViewController else { return }
    let coordinator = PurchaseCoordinator(presenterViewController: viewController)
//    coordinator.completion = { [weak self] coordinator in
//      print("Purchase result: \(coordinator.result)")
//      self?.childCoordinators.removeAll(where: { $0 === coordinator })
//    }
    coordinator.start()
    childCoordinators.append(coordinator)
  }

}

extension AppCoordinator: ChildCoordinatorDelegate {
  func childCoordinatorDidStop(_ coordinator: ChildCoordinator) {
    
  }
}
