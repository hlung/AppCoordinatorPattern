import UIKit

protocol PurchaseCoordinatorDelegate: AnyObject {
  func purchaseCoordinatorDidPurchase(_ coordinator: PurchaseCoordinator)
  func purchaseCoordinatorDidStop(_ coordinator: PurchaseCoordinator)
}

/// An example of a coordinator that manages an operation involving a series of UIAlertController.
final class PurchaseCoordinator: Coordinator {

  enum ProductType {
    case svod
    case tvod
    // case tvodsvod
    // case restorePurchase
  }

  weak var delegate: PurchaseCoordinatorDelegate?

  let rootViewController: UINavigationController
  let productType: ProductType

  init(navigationController: UINavigationController, productType: ProductType) {
    print("[\(type(of: self))] \(#function)")
    self.productType = productType
    self.rootViewController = navigationController
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    print("[\(type(of: self))] \(#function)")
  }

  func start() {
    switch productType {
    case .svod:
      let vc = PurchaseSVODViewController()
      vc.delegate = self
      self.rootViewController.pushViewController(vc, animated: true)
    case .tvod:
      break // to be implemented
    }
  }

}

extension PurchaseCoordinator: PurchaseSVODViewControllerDelegate {
  func purchaseSVODViewControllerDidPurchase(_ viewController: PurchaseSVODViewController) {
    rootViewController.popToRootViewController(animated: true)
    delegate?.purchaseCoordinatorDidPurchase(self)
  }

  func purchaseSVODViewControllerDidCancel(_ viewController: PurchaseSVODViewController) {
    rootViewController.popToRootViewController(animated: true)
    delegate?.purchaseCoordinatorDidStop(self)
  }

  func purchaseSVODViewControllerDidDeinit(_ viewController: PurchaseSVODViewController) {
    delegate?.purchaseCoordinatorDidStop(self)
  }
}
