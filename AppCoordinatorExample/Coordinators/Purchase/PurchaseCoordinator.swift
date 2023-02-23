import UIKit

/// An example of a coordinator that manages an operation involving a series of UIAlertController.
final class PurchaseCoordinator: Coordinator {

  enum PurchaseResult {
    case cancelled
    case success
  }

  let presenterViewController: UIViewController
  private var continuation: CheckedContinuation<PurchaseResult, Error>?

  init(presenterViewController: UIViewController) {
    print("\(type(of: self)) \(#function)")
    self.presenterViewController = presenterViewController
  }

  func start() {
    presenterViewController.present(purchaseAlertController(), animated: true)
  }

  func result() async throws -> PurchaseResult {
    try await withCheckedThrowingContinuation { self.continuation = $0 }
  }

  deinit {
    print("\(type(of: self)) \(#function)")
  }

  // MARK: - Alert Controllers

  func purchaseAlertController() -> UIAlertController {
    let alert = UIAlertController(title: "Purchase flow",
                                  message: "Do you want to purchase?",
                                  preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Cancel",
                                  style: .cancel,
                                  handler: { _ in
      self.presenterViewController.present(self.purchaseResultAlertController(.cancelled), animated: true)
    }))
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
      self.presenterViewController.present(self.purchaseResultAlertController(.success), animated: true)
    }))
    return alert
  }

  func purchaseResultAlertController(_ result: PurchaseResult) -> UIAlertController {
    let title = result == .success ? "Purchase Success" : "Purchase Cancelled"
    let alert = UIAlertController(title: title,
                                  message: "",
                                  preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
      self.continuation?.resume(returning: result)
    }))
    return alert
  }

}
