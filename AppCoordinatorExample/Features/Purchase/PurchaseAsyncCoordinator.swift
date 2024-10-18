import UIKit

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

  // This needs to be weak/unowned. Otherwise, if rootViewController retains this coordinator
  // there will be a retain cycle.
  unowned let rootViewController: UIViewController
  let productType: ProductType
  private var continuation: CheckedContinuation<Output, Never>?

  init(rootViewController: UIViewController, productType: ProductType) {
    print("[\(type(of: self))] \(#function)")
    self.productType = productType
    self.rootViewController = rootViewController
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
      // Task does not retain vc because vc is in withCheckedContinuation scope
      let output = await withCheckedContinuation {
        let vc = PurchaseSVODViewController()
        vc.delegate = self
        self.rootViewController.present(vc, animated: true)
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

}

extension PurchaseAsyncCoordinator: PurchaseSVODViewControllerDelegate {
  // Buy button
  func purchaseSVODViewControllerDidPurchase(_ viewController: PurchaseSVODViewController) {
    viewController.dismiss(animated: true)
    continuation?.resume(returning: .didPurchaseSVOD)
    continuation = nil
  }

  // Cancel button
  func purchaseSVODViewControllerDidCancel(_ viewController: PurchaseSVODViewController) {
    viewController.dismiss(animated: true)
    continuation?.resume(returning: .cancelled)
    continuation = nil
  }

  // Back button
  func purchaseSVODViewControllerDidDeinit(_ viewController: PurchaseSVODViewController) {
    // navigationController is already at root, no need to pop again
    continuation?.resume(returning: .cancelled)
    continuation = nil
  }
}
