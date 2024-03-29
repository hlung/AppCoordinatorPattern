import UIKit

protocol LoginCoordinatorDelegate: AnyObject {
  func loginCoordinator(_ coordinator: LoginCoordinator, didLogInWith username: String)
}

/// An example of a coordinator that manages a UINavigationController and returns a login result.
final class LoginCoordinator: Coordinator, ChildCoordinator {

  weak var resultDelegate: LoginCoordinatorDelegate?
  weak var lifecycleDelegate: CoordinatorLifecycleDelegate?

  let rootViewController: UINavigationController
  var animatedPush: Bool = true

  init(navigationController: UINavigationController) {
    print("[\(type(of: self))] \(#function)")
    self.rootViewController = navigationController
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    print("[\(type(of: self))] \(#function)")
  }

  func start() {
    let viewController = LoginLandingViewController()
    viewController.delegate = self
    rootViewController.setViewControllers([viewController], animated: false)
  }

//  private var completion: ((String) -> Void)?
//
//  func start(completion: @escaping (String) -> Void) {
//    let viewController = LoginLandingViewController()
//    viewController.delegate = self
//    rootViewController.setViewControllers([viewController], animated: false)
//    self.completion = completion
//  }

  // for handling stop request from outside
  func stop() {
    rootViewController.setViewControllers([], animated: false)
    lifecycleDelegate?.coordinatorDidFinish(self)
  }

}

extension LoginCoordinator: LoginLandingViewControllerDelegate {
  func loginLandingViewControllerDidSelectLogin(_ viewController: LoginLandingViewController) {
    let viewController = LoginViewController()
    viewController.delegate = self
    rootViewController.pushViewController(viewController, animated: animatedPush)
  }
}

extension LoginCoordinator: LoginViewControllerDelegate {
  func loginViewController(_ viewController: LoginViewController, didLogInWith username: String) {
    resultDelegate?.loginCoordinator(self, didLogInWith: username)
    lifecycleDelegate?.coordinatorDidFinish(self)
//    completion?(session)
  }

  func loginViewControllerDidCancel(_ viewController: LoginViewController) {
    rootViewController.popToRootViewController(animated: animatedPush)
  }
}
