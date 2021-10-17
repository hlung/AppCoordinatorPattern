//
//  AppCoordinator.swift
//  AppCoordinatorExample
//
//  Created by Kolyutsakul, Thongchai on 17/10/21.
//

import UIKit

final class AppCoordinator {

  private let window: UIWindow

  private var childCoordinators = [Coordinator]()
  private let navigationController: UINavigationController

  private lazy var homeViewController: HomeViewController = {
    HomeViewController()
  }()

  init(window: UIWindow) {
    self.window = window
    self.navigationController = UINavigationController()
  }

  func start() {
    navigationController.setViewControllers([homeViewController], animated: false)
    window.rootViewController = navigationController
  }

  func showLoginFlow() {
    let coordinator = LoginCoordinator(rootViewController: navigationController, delegate: self)
    childCoordinators.append(coordinator)
    coordinator.start()
  }

  func showPurchaseFlow() {

  }

}

extension AppCoordinator: CoordinatorDelegate {
  func coordinatorDidStop(_ coordinator: Coordinator) {
    print("\(#function) \(coordinator)")
    if let index = childCoordinators.firstIndex(where: { $0 === coordinator }) {
      childCoordinators.remove(at: index)
    }
  }
}

extension UIApplication {
  var coordinator: AppCoordinator {
    return (delegate as! AppDelegate).coordinator
  }
}
