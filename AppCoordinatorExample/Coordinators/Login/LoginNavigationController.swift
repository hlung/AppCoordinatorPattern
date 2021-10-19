//
//  LoginNavigationController.swift
//  AppCoordinatorExample
//
//  Created by Kolyutsakul, Thongchai on 18/10/21.
//

import UIKit

class LoginNavigationController: UINavigationController, Coordinator, LoginViewControlerDelegate {

  var deinitHandler: ((LoginNavigationController) -> Void)?

  init() {
    let viewController = LoginViewController()
    super.init(rootViewController: viewController)
    viewController.delegate = self
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func loginViewController(_ viewController: LoginViewController, didLogin success: Bool) {
    dismiss(animated: true)
  }

  deinit {
    deinitHandler?(self)
  }

}
