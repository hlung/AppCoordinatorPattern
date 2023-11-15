import UIKit

protocol Coordinator: AnyObject where ViewController: UIViewController {
  associatedtype ViewController
  var rootViewController: ViewController { get }
  func start()
}


protocol ParentCoordinator: Coordinator {
  var childCoordinators: [AnyObject] { get set }
}

extension ParentCoordinator {
  func addChild(_ coordinator: AnyObject) {
    childCoordinators.append(coordinator)
  }

  func removeChild(_ coordinator: any AnyObject) {
    childCoordinators.removeAll(where: { $0 === coordinator })
  }
}
