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
    // Here, appending child coordinator is not for lifecycle management reasons. Swift concurrency already handles it.
    // It's to provide the information of what coordinator is running, to handle use cases like ignoring some deeplinks.
    // It's not a use case Viki has right now. We always reset everything to home page and always handle that deeplink.
    // But just in case we need to do it in future.
    childAsyncCoordinators.append(coordinator)
    let output = try await coordinator.start()
    childAsyncCoordinators.removeAll(where: { $0 === coordinator })
    return output
  }
}

