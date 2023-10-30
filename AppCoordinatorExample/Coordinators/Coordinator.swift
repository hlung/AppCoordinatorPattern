import UIKit

protocol Coordinator: AnyObject {
  var window: UIWindow { get } // or rootViewController

  func start()
}
