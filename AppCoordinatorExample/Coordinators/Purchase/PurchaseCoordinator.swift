import UIKit

/// An example of a coordinator that manages an operation involving a series of UIAlertController.
@MainActor final class PurchaseCoordinator: Coordinator {

  enum PurchaseResult {
    case cancelled
    case success
  }

  let rootViewController: UIViewController
  private var continuation: CheckedContinuation<PurchaseResult, Error>?

  init(rootViewController: UIViewController) {
    print("\(type(of: self)) \(#function)")
    self.rootViewController = rootViewController
  }

  func start() async throws -> PurchaseResult {
    rootViewController.present(purchaseAlertController(), animated: true)

    return try await withCheckedThrowingContinuation { self.continuation = $0 }
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
      self.rootViewController.present(self.purchaseResultAlertController(.cancelled), animated: true)
    }))
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
      Task {
        await self.purchase()
        self.rootViewController.present(self.purchaseResultAlertController(.success), animated: true)
      }
    }))
    return alert
  }

  func purchase() async {
    let alert = UIAlertController(title: "Purchasing ...",
                                  message: "",
                                  preferredStyle: .alert)
    self.rootViewController.present(alert, animated: true)
    try? await Task.sleep(nanoseconds:1_000_000_000) // wait 1 second
    await alert.dismissAnimatedAsync()
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
