import UIKit

protocol HomeCoordinatorDelegate: AnyObject {
  func homeCoordinatorDidLogOut(_ coordinator: HomeCoordinator)
}

/// An example of a coordinator that manages main content of the app.
final class HomeCoordinator {

  weak var delegate: HomeCoordinatorDelegate?

  let rootViewController: UINavigationController
  var childCoordinators: [AnyObject] = []
  var username: String

  init(navigationController: UINavigationController, username: String) {
    print("[\(type(of: self))] \(#function)")
    self.rootViewController = navigationController
    self.username = username
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    print("[\(type(of: self))] \(#function)")
  }

  func start() {
    let viewController = HomeViewController()
    viewController.delegate = self
    viewController.username = username
    rootViewController.setViewControllers([viewController], animated: false)

    Task { @MainActor in
      if !UserDefaults.standard.onboardingShown {
        await showOnboarding()
      }
      if UserDefaults.standard.consent == nil {
        await showConsentAlert()
      }
      // - handle deeplinks
      // - show in app messaging
      // - etc.
    }
  }

  func stop() {
    rootViewController.setViewControllers([], animated: false)
  }

  func showPurchase() {
//    let coordinator = PurchaseCoordinator(navigationController: rootViewController, productType: .svod)
//    childCoordinators.append(coordinator)
//    coordinator.delegate = self
//    coordinator.start()

    Task { @MainActor in
      let coordinator = PurchaseAsyncCoordinator(navigationController: rootViewController, productType: .svod)
      let result = await coordinator.start()
      switch result {
      case .didPurchaseSVOD, .didPurchaseTVOD, .didRestorePurchase:
        print("Purchase OK")
      case .cancelled:
        print("Purchase Cancelled")
      }
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

//extension HomeCoordinator: PurchaseCoordinatorDelegate {
//  func purchaseCoordinatorDidPurchase(_ coordinator: PurchaseCoordinator) {
//    print("Purchase OK")
//    childCoordinators.removeAll { $0 === coordinator }
//  }
//
//  func purchaseCoordinatorDidStop(_ coordinator: PurchaseCoordinator) {
//    print("Purchase Cancelled")
//    childCoordinators.removeAll { $0 === coordinator }
//  }
//}

extension HomeCoordinator: OnboardingViewControllerDelegate {
  func onboardingViewControllerDidFinish(_ viewController: OnboardingViewController) {
    viewController.dismiss(animated: true)
  }
}

