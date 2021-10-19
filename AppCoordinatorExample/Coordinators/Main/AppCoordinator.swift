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

  func showLoginFlow() {
    let controller = LoginNavigationController()
    print("\(#function) show")
    navigationController.present(controller, animated: true)

    controller.deinitHandler = { _ in
      print("\(#function) deinit")
    }
  }

  func showPurchaseFlow() {

  }

}


extension UIApplication {
  var coordinator: AppCoordinator {
    return (delegate as! AppDelegate).coordinator
  }
}
