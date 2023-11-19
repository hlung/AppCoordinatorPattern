import UIKit

protocol Coordinator: AnyObject {
  associatedtype ViewController: UIViewController
  associatedtype Output

  var rootViewController: ViewController { get }
  func start() async throws -> Output
}

protocol ChildCoordinator: AnyObject {
  associatedtype ResultDelegate

  var resultDelegate: ResultDelegate? { get }
  var lifecycleDelegate: CoordinatorLifecycleDelegate? { get }
}

protocol CoordinatorLifecycleDelegate: AnyObject {
  func coordinatorDidFinish(_ coordinator: any Coordinator)
}
