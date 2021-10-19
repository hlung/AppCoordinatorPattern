//
//  LoginNavigationController.swift
//  AppCoordinatorExample
//
//  Created by Kolyutsakul, Thongchai on 18/10/21.
//

import UIKit

class LoginNavigationController: UINavigationController, Coordinator {

  var deinitHandler: ((LoginNavigationController) -> Void)?

  init() {
    let viewController = LoginLandingViewController()
    super.init(rootViewController: viewController)
    viewController.coordinator = self
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func showLoginPage() {
    let viewController = LoginViewController()
    viewController.coordinator = self
    pushViewController(viewController, animated: true)
  }

  func showSignUpPage() {
    let viewController = SignUpViewController()
    viewController.coordinator = self
    pushViewController(viewController, animated: true)
  }

  func finish(success: Bool) {
    // handle authentication result
    dismiss(animated: true)
  }

  deinit {
    deinitHandler?(self)
  }

}
