import UIKit

protocol HomeCoordinatorDelegate: AnyObject {
  func homeCoordinatorDidSelectPurchase(_ coordinator: HomeCoordinator)
  func homeCoordinatorDidLogOut(_ coordinator: HomeCoordinator)
}

/// An example of a coordinator that manages main content of the app.
final class HomeCoordinator: Coordinator {

  weak var delegate: HomeCoordinatorDelegate?
  let rootViewController: UINavigationController

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
  }
  
}

extension HomeCoordinator: HomeViewControllerDelegate {
  func homeViewControllerDidLogOut(_ viewController: HomeViewController) {
    delegate?.homeCoordinatorDidLogOut(self)
  }

  func homeViewControllerPurchase(_ viewController: HomeViewController) {
    delegate?.homeCoordinatorDidSelectPurchase(self)
  }
}
