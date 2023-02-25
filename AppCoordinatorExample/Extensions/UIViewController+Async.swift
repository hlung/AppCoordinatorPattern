import UIKit

extension UIViewController {
  // There's no async version of dismiss(). It's actually marked with NS_SWIFT_DISABLE_ASYNC in the header file.
  // So we need to create one manually.
  func dismissAnimatedAsync() async {
    await withCheckedContinuation { continuation in
      dismiss(animated: true) {
        continuation.resume()
      }
    }
  }
}
