import UIKit

// Not used right now, but to provide a future vision
protocol ParentCoordinator: AnyObject {
  var childCoordinators: [any Coordinator] { get set }
}

extension ParentCoordinator {
  func start<C: Coordinator>(_ coordinator: C) async throws -> C.Output {
    // Here, appending child coordinator is not for lifecycle management reasons. Swift concurrency already handles it.
    // It's to provide the information of what coordinator is running, to handle use cases like ignoring some deeplinks.
    // It's not a use case Viki has right now. We always reset everything to home page and always handle that deeplink.
    // But just in case we need to do it in future.
    childCoordinators.append(coordinator)
    let output = try await coordinator.start()
    childCoordinators.removeAll(where: { $0 === coordinator })
    return output
  }
}
