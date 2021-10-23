//
//  LoginNavigationController.swift
//  AppCoordinatorExample
//
//  Created by Kolyutsakul, Thongchai on 18/10/21.
//

import UIKit

/**
 For demonstrating a coordinator that is a UIViewController subclass.
 This means UIKit presentation stack can hold on to the coordinator for us, so we don't have to manage its life time.
 */
class LoginNavigationController: UINavigationController, Coordinator {

  var completion: ((LoginNavigationController) -> Void)?
  var result: String = "Cancelled"

  let presenterViewController: UIViewController

  init(presenterViewController: UIViewController) {
    print("\(type(of: self)) \(#function)")
    self.presenterViewController = presenterViewController

    let landingViewController = LoginLandingViewController()
    super.init(rootViewController: landingViewController)
    landingViewController.coordinator = self
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func start() {
    presenterViewController.present(self, animated: true)
  }

  deinit {
    print("\(type(of: self)) \(#function)")
    completion?(self) // this is the only place where we need to call completion!
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
