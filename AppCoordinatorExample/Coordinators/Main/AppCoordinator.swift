//
//  AppCoordinator.swift
//  AppCoordinatorExample
//
//  Created by Kolyutsakul, Thongchai on 17/10/21.
//

import UIKit

final class AppCoordinator {

  private let window: UIWindow
  private let navigationController: UINavigationController

  private lazy var homeViewController = HomeViewController()

  init(window: UIWindow) {
    self.window = window
    self.navigationController = UINavigationController()
  }

  func start() {
    navigationController.setViewControllers([homeViewController], animated: false)
    window.rootViewController = navigationController
  }

  // MARK: - Navigation

  // Make sure to use coordinator from closure argument rather than the outside one,
  // otherwise there will be a retain cycle.

  func showLoginFlow() {
    let coordinator = LoginNavigationController(viewController: navigationController)
    coordinator.start()
    coordinator.stop = { coordinator in
      print("result: \(coordinator.result)")
    }
  }

  func showPurchaseFlow() {
    let coordinator = PurchaseCoordinator(viewController: navigationController)
    coordinator.start()
    coordinator.stop = { coordinator in
      print("result: \(coordinator.result)")
    }
  }

}


extension UIApplication {
  var coordinator: AppCoordinator {
    return (delegate as! AppDelegate).coordinator
  }
}
