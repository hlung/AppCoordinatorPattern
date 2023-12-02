import Foundation

protocol SessionProvider: AnyObject {
  var session: Session? { get set }
}

protocol AppLaunchDataProvider: AnyObject {
  func getAppLaunchData() async throws -> Data
}
