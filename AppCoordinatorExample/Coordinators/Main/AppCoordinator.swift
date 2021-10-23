//
//  AppCoordinator.swift
//  AppCoordinatorExample
//
//  Created by Kolyutsakul, Thongchai on 17/10/21.
//

import UIKit

final class AppCoordinator {

  static var shared = AppCoordinator()

  private lazy var navigationController = UINavigationController()
  private lazy var homeViewController = HomeViewController()

  func setup(with window: UIWindow) {
    navigationController.setViewControllers([homeViewController], animated: false)
    window.rootViewController = navigationController
  }

  // MARK: - Navigation

  func showLoginFlow() {
    let coordinator = LoginNavigationController(viewController: navigationController)
    coordinator.start()
    coordinator.stop = { coordinator in
      print("result: \(coordinator.result)")
    }
  }

  // Experimental
  func showPurchaseFlow() {
    let coordinator = PurchaseCoordinator(viewController: navigationController)
    coordinator.start()
    coordinator.stop = { coordinator in
      print("result: \(coordinator.result)")
    }
  }

}
