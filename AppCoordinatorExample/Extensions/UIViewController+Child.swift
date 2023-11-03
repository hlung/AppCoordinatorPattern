import UIKit

// Not used
@nonobjc extension UIViewController {
  func add(_ child: UIViewController, frame: CGRect? = nil) {
    addChild(child)

    if let frame = frame {
      child.view.frame = frame
    }

    view.addSubview(child.view)
    child.didMove(toParent: self)
  }

  func remove() {
    willMove(toParent: nil)
    view.removeFromSuperview()
    removeFromParent()
  }

  var topmostViewController: UIViewController {
    if let presentedViewController = self.presentedViewController {
      return presentedViewController.topmostViewController
    }
    else if let navigationController = self as? UINavigationController,
            let topViewController = navigationController.topViewController {
      return topViewController.topmostViewController
    }
    return self
  }
}
