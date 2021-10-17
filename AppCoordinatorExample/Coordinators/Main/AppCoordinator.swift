//
//  AppCoordinator.swift
//  AppCoordinatorExample
//
//  Created by Kolyutsakul, Thongchai on 17/10/21.
//

import UIKit

final class AppCoordinator: Coordinator {

  weak var delegate: CoordinatorDelegate?

  private let window: UIWindow

  private lazy var homeViewController: HomeViewController = {
    HomeViewController()
  }()

  init(window: UIWindow) {
    self.window = window
  }

  func start() {
    let navigationController = UINavigationController(rootViewController: homeViewController)
    window.rootViewController = navigationController
  }

}
