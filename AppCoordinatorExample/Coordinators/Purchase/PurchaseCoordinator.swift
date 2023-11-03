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
      self.rootViewController.present(vc, animated: true)
    case .tvod:
      break
    }
  }

  // MARK: - Alert Controllers

  func purchaseAlertController() -> UIAlertController {
    let alert = UIAlertController(title: "Purchase flow 1", message: "Do you want to purchase?", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
      self.delegate?.purchaseCoordinatorDidCancel(self)
    }))
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
      self.rootViewController.present(self.confirmationAlertController(), animated: true)
    }))
    return alert
  }

  func confirmationAlertController() -> UIAlertController {
    let alert = UIAlertController(title: "Purchase flow 2", message: "Do you really really really want to purchase?", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
      self.delegate?.purchaseCoordinatorDidCancel(self)
    }))
    alert.addAction(UIAlertAction(title: "Yes!", style: .default, handler: { _ in
      self.rootViewController.present(self.purchasedAlertController(), animated: true)
    }))
    return alert
  }

  func purchasedAlertController() -> UIAlertController {
    let alert = UIAlertController(title: "Purchase flow 3", message: "All set!", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
      self.delegate?.purchaseCoordinatorDidPurchase(self)
    }))
    return alert
  }

}
