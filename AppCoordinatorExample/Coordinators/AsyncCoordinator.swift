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

//extension AsyncCoordinator {
//  func start(inParent parent: any ParentAsyncCoordinator) async throws -> Output {
//    parent.childAsyncCoordinators.append(self)
//    let output = try await start()
//    parent.childAsyncCoordinators.removeAll(where: { $0 === self })
//    return output
//  }
//}

//extension ParentAsyncCoordinator {
//  func start<O: AsyncCoordinator>(_ coordinator: any AsyncCoordinator) async throws -> O.Output {
//    childAsyncCoordinators.append(coordinator)
//    return try await coordinator.start()
//  }
//}
