import UIKit

protocol PurchaseAsyncCoordinatorDelegate: AnyObject {
  func purchaseAsyncCoorinatorDidPurchase(_ coordinator: PurchaseAsyncCoordinator)
}

/// An example of a coordinator that manages an operation involving a series of UIAlertController.
final class PurchaseAsyncCoordinator: AsyncCoordinator {

  enum ProductType {
    case svod
    case tvod
  }

  enum Output {
    case didPurchaseSVOD // didPurchasePlan
    case didPurchaseTVOD // didPurchaseProduct
    case didRestorePurchase
    case cancelled
  }

  weak var delegate: PurchaseCoordinatorDelegate?

  let rootViewController: UINavigationController
  let productType: ProductType
  private var continuation: CheckedContinuation<Output, Never>?

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

  @MainActor func start() async -> Output {
    switch productType {
    case .svod:
      let vc = PurchaseSVODViewController()
      vc.delegate = self
      self.rootViewController.pushViewController(vc, animated: true)
    case .tvod:
      break // to be implemented
    }

    let output = await withCheckedContinuation { self.continuation = $0 }
    return output
  }

}

extension PurchaseAsyncCoordinator: PurchaseSVODViewControllerDelegate {
  // Buy button
  func purchaseSVODViewControllerDidPurchase(_ viewController: PurchaseSVODViewController) {
    rootViewController.popToRootViewController(animated: true)
    continuation?.resume(returning: .didPurchaseSVOD)
  }

  // Cancel button
  func purchaseSVODViewControllerDidCancel(_ viewController: PurchaseSVODViewController) {
    rootViewController.popToRootViewController(animated: true)
    continuation?.resume(returning: .cancelled)
  }

  // Back button
  func purchaseSVODViewControllerDidDeinit(_ viewController: PurchaseSVODViewController) {
    // navigationController is already at root, no need to pop again
    continuation?.resume(returning: .cancelled)
  }
}
