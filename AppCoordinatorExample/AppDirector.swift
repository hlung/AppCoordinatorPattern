//
//  AppDirector.swift
//  AppCoordinatorExample
//
//  Created by Kolyutsakul, Thongchai on 17/10/21.
//

import UIKit

final class AppDirector {

  static var shared = AppDirector()

//  private lazy var navigationController = UINavigationController()
//  private lazy var homeViewController = HomeViewController()

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
    coordinator.completion = { [weak self] coordinator in
      UserDefaults.standard.isLoggedIn = false
      self?.childCoordinators.removeAll(where: { $0 === coordinator })
      self?.showLogin()
    }
    coordinator.start()
    childCoordinators.append(coordinator)
  }

  func showLogin() {
    let coordinator = LoginCoordinator(window: window)
    coordinator.completion = { [weak self] coordinator in
      print("Login result: \(coordinator.result)")
      UserDefaults.standard.isLoggedIn = true
      self?.childCoordinators.removeAll(where: { $0 === coordinator })
      self?.showHome()
    }
    coordinator.start()
    childCoordinators.append(coordinator)
  }

  func showPurchase() {
    // We have to manually retain PurchaseCoordinator because is not a view controller subclass.
    // So the navigation stack cannot help retain it for us. 😢
//    let coordinator = PurchaseCoordinator(presenterViewController: navigationController)
//    coordinator.completion = { [weak self] coordinator in
//      print("Purchase result: \(coordinator.result)")
//      self?.purchaseCoordinator = nil // release the coordinator
//    }
//    self.purchaseCoordinator = coordinator // retain the coordinator
//    coordinator.start()
  }

}
