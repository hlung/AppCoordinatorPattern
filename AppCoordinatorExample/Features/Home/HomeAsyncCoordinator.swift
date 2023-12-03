import UIKit

final class HomeAsyncCoordinator: Coordinator {

  let rootViewController: UINavigationController
  private var continuation: CheckedContinuation<Void, Never>?
  var username: String

  init(navigationController: UINavigationController, session: Session) {
    print("[\(type(of: self))] \(#function)")
    self.rootViewController = navigationController
    self.username = session.user.username
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    print("[\(type(of: self))] \(#function)")
  }

  @MainActor func start() async {
    let viewController = HomeViewController()
    viewController.delegate = self
    viewController.username = UserDefaults.standard.loggedInUsername ?? "-"
    rootViewController.setViewControllers([viewController], animated: false)

    if !UserDefaults.standard.onboardingShown {
      await showOnboarding()
    }
    if UserDefaults.standard.consent == nil {
      await showConsentAlert()
    }
    // can do more stuff here, such as:
    // - handle deeplinks
    // - show in app messages
    // - complete account detail

    await withCheckedContinuation { self.continuation = $0 }

    rootViewController.setViewControllers([], animated: false)

    return
  }

  func showPurchase() {
    Task { @MainActor in
      let coordinator = PurchaseAsyncCoordinator(navigationController: rootViewController, productType: .svod)
      let output = await coordinator.start()
      switch output {
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

extension HomeAsyncCoordinator: HomeViewControllerDelegate {
  func homeViewControllerDidLogOut(_ viewController: HomeViewController) {
    continuation?.resume()
  }

  func homeViewControllerPurchase(_ viewController: HomeViewController) {
    showPurchase()
  }

  func homeViewControllerDidTapOnboarding(_ viewController: HomeViewController) {
    Task { await showOnboarding() }
  }
}

extension HomeAsyncCoordinator: OnboardingViewControllerDelegate {
  func onboardingViewControllerDidFinish(_ viewController: OnboardingViewController) {
    viewController.dismiss(animated: true)
  }
}

