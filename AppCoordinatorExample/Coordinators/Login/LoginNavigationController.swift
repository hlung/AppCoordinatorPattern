//
//  LoginNavigationController.swift
//  AppCoordinatorExample
//
//  Created by Kolyutsakul, Thongchai on 18/10/21.
//

import UIKit

class LoginNavigationController: UINavigationController, Coordinator {

  var deinitHandler: ((LoginNavigationController) -> Void)?
  var result: String = "-"

  let viewController: UIViewController

  init(viewController: UIViewController) {
    print("\(#fileID) \(#function)")
    self.viewController = viewController

    let landingViewController = LoginLandingViewController()
    super.init(rootViewController: landingViewController)
    landingViewController.coordinator = self
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func start() {
    viewController.present(self, animated: true)
  }

  deinit {
    print("\(#fileID) \(#function)")
    deinitHandler?(self)
  }

  // MARK: - Navigation

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

  func cancel() {
    dismiss(animated: true)
  }

  func finish(result: String) {
    self.result = result
    dismiss(animated: true)
  }

  func reset() {
    popToRootViewController(animated: true)
  }

}
