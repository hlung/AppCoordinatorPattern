import UIKit

protocol HomeCoordinatorDelegate: AnyObject {
  func homeCoordinatorDidSelectPurchase(_ coordinator: HomeCoordinator)
}

/// An example of a coordinator that manages main content of the app.
final class HomeCoordinator: Coordinator {

  weak var delegate: HomeCoordinatorDelegate?
  let window: UIWindow
  private lazy var navigationController = UINavigationController()
  private var continuation: CheckedContinuation<Void, Error>?

  init(window: UIWindow) {
    print("\(type(of: self)) \(#function)")
    self.window = window
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
    navigationController.navigationBar.scrollEdgeAppearance = appearance

    let viewController = HomeViewController()
    viewController.delegate = self
    navigationController.setViewControllers([viewController], animated: false)
    window.rootViewController = navigationController
  }

  func result() async throws {
    try await withCheckedThrowingContinuation { self.continuation = $0 }
  }
  
}

extension HomeCoordinator: HomeViewControllerDelegate {
  func homeViewControllerDidLogOut(_ viewController: HomeViewController) {
    continuation?.resume(returning: ())
  }

  func homeViewControllerPurchase(_ viewController: HomeViewController) {
    delegate?.homeCoordinatorDidSelectPurchase(self)
  }
}
