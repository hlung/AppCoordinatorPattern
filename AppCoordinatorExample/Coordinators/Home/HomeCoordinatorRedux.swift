import UIKit

protocol HomeCoordinatorReduxDelegate: AnyObject {
  func homeCoordinatorReduxDidLogOut(_ coordinator: HomeCoordinatorRedux)
}

/// An example of a coordinator that manages main content of the app.
final class HomeCoordinatorRedux: CoordinatorRedux {

  struct State: Equatable {
    var username: String

//    var modal: Modal?
//
//    enum Modal {
//      case onboarding
//      case consent
//    }
  }

  enum Action {
    case showPurchase
    case didPurchase
  }

  private(set) var state: State {
    didSet {
      guard state != oldValue else { return }
      print("[\(type(of: self))]", #function, oldValue, "->", state)
      translateStateToUI()
    }
  }

  weak var delegate: HomeCoordinatorReduxDelegate?

  let rootViewController: UINavigationController
  var childCoordinators: [AnyObject] = []

  init(navigationController: UINavigationController, username: String) {
    print("[\(type(of: self))] \(#function)")
    self.rootViewController = navigationController
    self.state = State(
      username: username
    )
    print("[\(type(of: self))] initial state", state)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    print("[\(type(of: self))] \(#function)")
  }

  func start() {
    translateStateToUI()
    showStartUpAlertsIfNeeded()
  }

  func stop() {
    rootViewController.setViewControllers([], animated: false)
  }

  lazy var homeViewController: HomeViewController = {
    let viewController = HomeViewController()
    viewController.delegate = self
    rootViewController.setViewControllers([viewController], animated: false)
    return viewController
  }()

  func translateStateToUI() {
    homeViewController.username = state.username
  }

  func send(_ action: Action) {
    print("[\(type(of: self))]", #function, action)
    switch action {
    case .showPurchase:
      showPurchase()
      break
    case .didPurchase:
      // update some state
      break
    }
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
      // - handle deeplinks
      // - show in app messaging
      // - etc.
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

extension HomeCoordinatorRedux: HomeViewControllerDelegate {
  func homeViewControllerDidLogOut(_ viewController: HomeViewController) {
    delegate?.homeCoordinatorReduxDidLogOut(self)
  }

  func homeViewControllerPurchase(_ viewController: HomeViewController) {
    send(.showPurchase)
  }

  func homeViewControllerDidTapOnboarding(_ viewController: HomeViewController) {
    Task { await showOnboarding() }
  }
}

extension HomeCoordinatorRedux: PurchaseCoordinatorDelegate {
  func purchaseCoordinatorDidPurchase(_ coordinator: PurchaseCoordinator) {
    print("Purchase OK")
    send(.didPurchase)
    removeChild(coordinator)
  }

  func purchaseCoordinatorDidStop(_ coordinator: PurchaseCoordinator) {
    print("Purchase stop")
    removeChild(coordinator)
  }
}

extension HomeCoordinatorRedux: OnboardingViewControllerDelegate {
  func onboardingViewControllerDidFinish(_ viewController: OnboardingViewController) {
    viewController.dismiss(animated: true)
  }
}

