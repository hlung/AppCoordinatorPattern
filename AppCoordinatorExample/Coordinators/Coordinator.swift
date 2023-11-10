import UIKit

protocol Coordinator: AnyObject where ViewController: UIViewController {
  associatedtype ViewController
  associatedtype Output

  var rootViewController: ViewController { get }
  func start() async throws -> Output
}

protocol ParentCoordinator: Coordinator {
  var childCoordinators: [any Coordinator] { get set }
}

extension ParentCoordinator {
  func addChild(_ coordinator: any Coordinator) {
    childCoordinators.append(coordinator)
  }

  func removeChild(_ coordinator: any Coordinator) {
    childCoordinators.removeAll(where: { $0 === coordinator })
  }
}
