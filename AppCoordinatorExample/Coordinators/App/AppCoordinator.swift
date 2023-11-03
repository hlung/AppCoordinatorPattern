import UIKit

/* --- Main structure ---
 - AppCoordinator
    - If not logged in, start LoginCoordinator
    - If logged in, start HomeController
 - LoginCoordinator
    - perform login
 - HomeController
    - If new user, start OnboardingCoordinator
    - If user have no email, start EmailInputCoordinator
    - If Sourcepoint returns a CMP banner vc, show it
    - When user want to buy, start PurchaseCoordinator
 - PurchaseCoordinator
    - Show different VC depending on ProductType
    - If user haven't verify email, start EmailVerificationCoordinator

 Rules:
 - A view controller should never dismiss itself. It requests its delegate (coordinator) to dismiss, which will call coordinator.stop().
 */

final class AppCoordinator: ParentCoordinator {

  let rootViewController: UINavigationController
  var childCoordinators: [any Coordinator] = []

  init(navigationController: UINavigationController) {
    self.rootViewController = navigationController
  }

  func start() {
    if UserDefaults.standard.isLoggedIn {
      showHome()
    }
    else {
      showLogin()
    }
  }

  // MARK: - Navigation

  func showHome() {
    let coordinator = HomeCoordinator(navigationController: rootViewController)
    addChild(coordinator)
    coordinator.delegate = self
    coordinator.start()
  }

  func showLogin() {
    let coordinator = LoginCoordinator(navigationController: rootViewController)
    addChild(coordinator)
    coordinator.delegate = self
    coordinator.start()
  }

}

extension AppCoordinator: HomeCoordinatorDelegate {
  func homeCoordinatorDidLogOut(_ coordinator: HomeCoordinator) {
    UserDefaults.standard.loggedInUsername = nil
    UserDefaults.standard.onboardingShown = false
    UserDefaults.standard.consent = nil
    UserDefaults.standard.emailVerified = false
    removeChild(coordinator)
    showLogin()
  }
}

extension AppCoordinator: LoginCoordinatorDelegate {
  func loginCoordinator(_ coordinator: LoginCoordinator, didLogInWith username: String) {
    print("Login result: \(username)")
    UserDefaults.standard.loggedInUsername = username
    removeChild(coordinator)
    showHome()
  }
}
