import UIKit

protocol HomeCoordinatorDelegate: AnyObject {
  func homeCoordinatorDidLogOut(_ coordinator: HomeCoordinator)
}

/// An example of a coordinator that manages main content of the app.
final class HomeCoordinator: ParentCoordinator {

  weak var delegate: HomeCoordinatorDelegate?
  let rootViewController: UINavigationController
  var childCoordinators: [any Coordinator] = []

  init(navigationController: UINavigationController) {
    print("\(type(of: self)) \(#function)")
    self.rootViewController = navigationController
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    print("\(type(of: self)) \(#function)")
  }

  func start() {
    let appearance = UINavigationBarAppearance()
    appearance.backgroundColor = .systemGray3
    rootViewController.navigationBar.scrollEdgeAppearance = appearance

    let viewController = HomeViewController()
    viewController.delegate = self
    rootViewController.setViewControllers([viewController], animated: false)

    showStartUpAlertsIfNeeded()
  }

  func showPurchase() {
    let coordinator = PurchaseCoordinator(navigationController: rootViewController, productType: .svod)
    addChild(coordinator)
    coordinator.delegate = self
    coordinator.start()
  }

  func showStartUpAlertsIfNeeded() {
    Task {
      if !UserDefaults.standard.onboardingShown {
        await showOnboarding()
      }
      if UserDefaults.standard.consent == nil {
        await showConsentAlert()
      }
      if !UserDefaults.standard.emailVerified {
        await showEmailVerificationAlert()
      }
      // handle deeplinks
      // and other things here
    }
  }

  @MainActor func showOnboarding() async {
    await withCheckedContinuation { continuation in
      let viewController = OnboardingViewController()
      viewController.delegate = self
      viewController.deinitHandler = { continuation.resume() }
      rootViewController.present(viewController, animated: true)
      UserDefaults.standard.onboardingShown = true
    }
  }

  @MainActor func showConsentAlert() async {
    await withCheckedContinuation { continuation in
      let alert = UIAlertController(title: "CMP Consent", message: "Do you want to accept?", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Reject", style: .destructive, handler: { _ in
        UserDefaults.standard.consent = "reject"
        continuation.resume()
      }))
      alert.addAction(UIAlertAction(title: "Accept", style: .default, handler: { _ in
        UserDefaults.standard.consent = "accept"
        continuation.resume()
      }))
      rootViewController.present(alert, animated: true)
    }
  }

  @MainActor func showEmailVerificationAlert() async {
    await withCheckedContinuation { continuation in
      let alert = UIAlertController(title: "Verify email", message: nil, preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Verify", style: .default, handler: { _ in
        UserDefaults.standard.emailVerified = true
        continuation.resume()
      }))
      rootViewController.present(alert, animated: true)
    }
  }

}

extension HomeCoordinator: HomeViewControllerDelegate {
  func homeViewControllerDidLogOut(_ viewController: HomeViewController) {
    delegate?.homeCoordinatorDidLogOut(self)
  }

  func homeViewControllerPurchase(_ viewController: HomeViewController) {
    showPurchase()
  }

  func homeViewControllerDidTapOnboarding(_ viewController: HomeViewController) {
    Task { await showOnboarding() }
  }
}

extension HomeCoordinator: PurchaseCoordinatorDelegate {
  func purchaseCoordinatorDidPurchase(_ coordinator: PurchaseCoordinator) {
    print("Purchase OK")
    coordinator.stop()
  }

  func purchaseCoordinatorDidStop(_ coordinator: PurchaseCoordinator) {
    print("Purchase stop")
    removeChild(coordinator)
  }
}

extension HomeCoordinator: OnboardingViewControllerDelegate {
  func onboardingViewControllerDidFinish(_ viewController: OnboardingViewController) {
    viewController.dismiss(animated: true)
  }
}

