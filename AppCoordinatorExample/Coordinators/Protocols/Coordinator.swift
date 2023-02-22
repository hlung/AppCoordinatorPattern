import Foundation

protocol Coordinator: AnyObject {
  associatedtype CoordinatorResult
  func start()
  func result() async throws -> CoordinatorResult
}
