import UIKit

protocol AsyncCoordinator: AnyObject where ViewController: UIViewController {
  associatedtype ViewController
  associatedtype Output

  var rootViewController: ViewController { get }
  func start() async throws -> Output
}

protocol ParentAsyncCoordinator: AsyncCoordinator {
  var childAsyncCoordinators: [any AsyncCoordinator] { get set }
}

extension ParentAsyncCoordinator {
  func start<C: AsyncCoordinator>(_ coordinator: C) async throws -> C.Output {
    childAsyncCoordinators.append(coordinator)
    let output = try await coordinator.start()
    childAsyncCoordinators.removeAll(where: { $0 === coordinator })
    return output
  }
}
