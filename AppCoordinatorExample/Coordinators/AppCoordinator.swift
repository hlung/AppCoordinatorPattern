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

  var children: [AnyObject] = []

  func start(with window: UIWindow) {
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
    coordinator.delegate = self
    coordinator.teardown = { [weak self] coordinator in
      UserDefaults.standard.isLoggedIn = false
      self?.children.removeAll(where: { $0 === coordinator })
      self?.showLogin()
    }
    coordinator.start()
    children.append(coordinator)
  }

  func showLogin() {
    let coordinator = LoginCoordinator(window: window)
    coordinator.teardown = { [weak self] coordinator in
      print("Login result: \(coordinator.result)")
      UserDefaults.standard.isLoggedIn = true
      self?.children.removeAll(where: { $0 === coordinator })
      self?.showHome()
    }
    coordinator.start()
    children.append(coordinator)
  }

  func showPurchase() {
//    guard let viewController = window.rootViewController else { return }
//    let coordinator = PurchaseCoordinator(presenterViewController: viewController)
//    coordinator.teardown = { coordinator in
//      print("Purchase result: \(coordinator.result)")
//    }
//    coordinator.setup()
  }

}

extension AppCoordinator: HomeCoordinatorDelegate {
  func homeCoordinatorDidSelectPurchase(_ coordinator: HomeCoordinator) {
    showPurchase()
  }
}
