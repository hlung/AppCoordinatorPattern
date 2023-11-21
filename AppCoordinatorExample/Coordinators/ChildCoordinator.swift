import Foundation

protocol ChildCoordinator: AnyObject {
  associatedtype ResultDelegate

  var resultDelegate: ResultDelegate? { get }
  var lifecycleDelegate: CoordinatorLifecycleDelegate? { get }
}

protocol CoordinatorLifecycleDelegate: AnyObject {
  func coordinatorDidFinish(_ coordinator: any Coordinator)
}
