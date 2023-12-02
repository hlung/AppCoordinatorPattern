import UIKit

protocol PurchaseAsyncCoordinatorDelegate: AnyObject {
  func purchaseAsyncCoorinatorDidPurchase(_ coordinator: PurchaseAsyncCoordinator)
}

/// An example of a coordinator that manages an operation involving a series of UIAlertController.
final class PurchaseAsyncCoordinator: Coordinator {

  enum ProductType {
    case svod
    case tvod
    // case tvodsvod
    // case restorePurchase
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
      // Task does not retain vc
      let output = await withCheckedContinuation {
        let vc = PurchaseSVODViewController()
        vc.delegate = self
        self.rootViewController.pushViewController(vc, animated: true)
        self.continuation = $0
      }
      return output

      // Task retains vc
      // May create a bug if you rely on vc deinit to return output
//      let vc = PurchaseSVODViewController()
//      vc.delegate = self
//      self.rootViewController.pushViewController(vc, animated: true)
//      let output = await withCheckedContinuation { self.continuation = $0 }
//      return output

    case .tvod:
      // to be implemented
      return .didPurchaseTVOD
    }
  }

//  func start() -> Output {
//    return .cancelled
//  }
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
