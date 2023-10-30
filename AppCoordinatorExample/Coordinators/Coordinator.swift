import UIKit

protocol Coordinator: AnyObject {
  var window: UIWindow { get } // This can be rootViewController. But for this demo purpose, it's easier to just use window.

  func start()
}
