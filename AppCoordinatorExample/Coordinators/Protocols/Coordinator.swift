import Foundation

protocol Coordinator: AnyObject {
  associatedtype CoordinatorResult
  func start() async throws -> CoordinatorResult
}
