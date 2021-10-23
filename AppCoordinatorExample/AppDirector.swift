//
//  AppDirector.swift
//  AppCoordinatorExample
//
//  Created by Kolyutsakul, Thongchai on 17/10/21.
//

import UIKit

final class AppDirector {

  static var shared = AppDirector()

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
    coordinator.completion = { coordinator in
      print("result: \(coordinator.result)")
    }
  }

  // Experimental
  func showPurchaseFlow() {
    let coordinator = PurchaseCoordinator(viewController: navigationController)
    coordinator.start()
    coordinator.completion = { coordinator in
      print("result: \(coordinator.result)")
    }
  }

}
