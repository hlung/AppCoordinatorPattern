import UIKit

protocol HomeCoordinatorDelegate: AnyObject {
  func homeCoordinatorDidSelectPurchase(_ coordinator: HomeCoordinator)
}

/// An example of a coordinator that manages main content of the app.
final class HomeCoordinator: ChildCoordinator {

  var completion: ((HomeCoordinator) -> Void)?
  weak var delegate: HomeCoordinatorDelegate?

  let window: UIWindow
  private lazy var navigationController = UINavigationController()

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
  
}

extension HomeCoordinator: HomeViewControllerDelegate {
  func homeViewControllerDidLogOut(_ viewController: HomeViewController) {
    completion?(self)
  }

  func homeViewControllerPurchase(_ viewController: HomeViewController) {
    delegate?.homeCoordinatorDidSelectPurchase(self)
  }
}
