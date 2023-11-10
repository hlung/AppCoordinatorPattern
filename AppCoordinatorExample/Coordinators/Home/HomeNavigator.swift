import UIKit

protocol HomeNavigatorDelegate: AnyObject {
  func homeNavigatorDidLogOut(_ navigator: HomeNavigator)
}

final class HomeNavigator {

  enum Destination {
    case home
    case onboarding
    case consent
    case purchase
  }

  let rootViewController: UINavigationController
  weak var delegate: HomeNavigatorDelegate?

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
    Task { @MainActor in
      let appearance = UINavigationBarAppearance()
      appearance.backgroundColor = .systemGray3
      rootViewController.navigationBar.scrollEdgeAppearance = appearance

      await navigate(to: .home)

      if !UserDefaults.standard.onboardingShown {
        await navigate(to: .onboarding)
      }
      if UserDefaults.standard.consent == nil {
        await navigate(to: .consent)
      }
      // - handle deeplinks
      // - show in app messaging
      // - etc.
    }
  }

  @MainActor func navigate(to destination: Destination) async {
    switch destination {
    case .home:
      if let _ = rootViewController.viewControllers.first as? HomeViewController {
        rootViewController.popToRootViewController(animated: true)
      }
      else {
        let viewController = HomeViewController()
        viewController.delegate = self
        rootViewController.setViewControllers([viewController], animated: false)
      }
    case .onboarding:
      await showOnboarding()
    case .consent:
      await showConsentAlert()
    case .purchase:
      break
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

  func showPurchase() {
  }

}

extension HomeNavigator: HomeViewControllerDelegate {
  func homeViewControllerDidLogOut(_ viewController: HomeViewController) {
    delegate?.homeNavigatorDidLogOut(self)
  }

  func homeViewControllerPurchase(_ viewController: HomeViewController) {
    showPurchase()
  }

  func homeViewControllerDidTapOnboarding(_ viewController: HomeViewController) {
    Task { await navigate(to: .onboarding) }
  }
}

extension HomeNavigator: OnboardingViewControllerDelegate {
  func onboardingViewControllerDidFinish(_ viewController: OnboardingViewController) {
    viewController.dismiss(animated: true)
  }
}
