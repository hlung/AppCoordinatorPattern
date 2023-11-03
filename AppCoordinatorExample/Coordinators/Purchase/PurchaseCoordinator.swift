import UIKit

protocol PurchaseCoordinatorDelegate: AnyObject {
  func purchaseCoordinatorDidPurchase(_ coordinator: PurchaseCoordinator)
  func purchaseCoordinatorDidCancel(_ coordinator: PurchaseCoordinator)
}

/// An example of a coordinator that manages an operation involving a series of UIAlertController.
final class PurchaseCoordinator: Coordinator {

  enum ProductType {
    case svod
    case tvod
  }

  weak var delegate: PurchaseCoordinatorDelegate?

  let rootViewController: UINavigationController
  let productType: ProductType

  init(navigationController: UINavigationController, productType: ProductType) {
    print("\(type(of: self)) \(#function)")
    self.productType = productType
    self.rootViewController = navigationController
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    print("\(type(of: self)) \(#function)")
  }

  func start() {
    switch productType {
    case .svod:
      let vc = PurchaseSVODViewController()
      vc.delegate = self
      self.rootViewController.present(vc, animated: true)
    case .tvod:
      break // to be implemented
    }
  }

  // MARK: - Alert Controllers

  func purchaseConfirmationAlertController() -> UIAlertController {
    let alert = UIAlertController(title: "Purchase confirmation", message: "Do you want to purchase?", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
      self.delegate?.purchaseCoordinatorDidCancel(self)
    }))
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
      self.rootViewController.topmostViewController.present(self.purchaseSuccessAlertController(), animated: true)
    }))
    return alert
  }

  func purchaseSuccessAlertController() -> UIAlertController {
    let alert = UIAlertController(title: "Purchase success", message: "All set!", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
      self.delegate?.purchaseCoordinatorDidPurchase(self)
    }))
    return alert
  }

}

extension PurchaseCoordinator: PurchaseSVODViewControllerDelegate {
  func purchaseSVODViewControllerDidRequestPurchase(_ viewController: PurchaseSVODViewController) {
    rootViewController.topmostViewController.present(purchaseConfirmationAlertController(), animated: true)
  }

  func purchaseSVODViewControllerDidCancel(_ viewController: PurchaseSVODViewController) {
    delegate?.purchaseCoordinatorDidCancel(self)
  }
}
