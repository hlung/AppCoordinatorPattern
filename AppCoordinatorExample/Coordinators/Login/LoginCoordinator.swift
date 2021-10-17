//
//  LoginCoordinator.swift
//  AppCoordinatorExample
//
//  Created by Kolyutsakul, Thongchai on 17/10/21.
//

import UIKit

final class LoginCoordinator: Coordinator, LoginViewControlerDelegate {

  weak var delegate: CoordinatorDelegate?
  private let rootViewController: UIViewController
  private let navigationController: UINavigationController

  private lazy var loginViewController: LoginViewController = {
    LoginViewController()
  }()

  init(rootViewController: UIViewController, delegate: CoordinatorDelegate) {
    self.delegate = delegate
    self.rootViewController = rootViewController
    self.navigationController = UINavigationController()
  }

  func start() {
    navigationController.setViewControllers([loginViewController], animated: false)
    rootViewController.present(navigationController, animated: true)
    loginViewController.delegate = self
  }

  func loginViewControllerDidFinish(_ viewController: LoginViewController) {
    stop()
  }

  deinit {
    print("\(self) \(#function)")
  }

}
