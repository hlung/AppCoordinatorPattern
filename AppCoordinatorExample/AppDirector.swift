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

  private var purchaseCoordinator: PurchaseCoordinator?

  func setup(with window: UIWindow) {
    navigationController.setViewControllers([homeViewController], animated: false)
    window.rootViewController = navigationController
    window.makeKeyAndVisible()
  }

  // MARK: - Navigation

  func showLoginFlow() {
    let coordinator = LoginNavigationController(presenterViewController: navigationController)
    coordinator.start()
    coordinator.completion = { coordinator in
      print("Login result: \(coordinator.result)")
    }
    // We don't need to retain/release the coordinator (LoginNavigationController) here
    // because the navigation stack already manages this for us. 😎
  }

  func showPurchaseFlow() {
    let coordinator = PurchaseCoordinator(presenterViewController: navigationController)
    coordinator.start()
    coordinator.completion = { [weak self] coordinator in
      print("Purchase result: \(coordinator.result)")
      self?.purchaseCoordinator = nil // release the coordinator
    }
    self.purchaseCoordinator = coordinator // retain the coordinator
  }

}
