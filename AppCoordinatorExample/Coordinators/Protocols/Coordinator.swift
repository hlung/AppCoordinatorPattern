import Foundation

protocol Coordinator: AnyObject {
  associatedtype Output
  func start() async throws -> Output
}
