import Foundation

protocol SessionProvider: AnyObject {
  var session: Session? { get set }
  func loadSavedSession()
}

protocol AppLaunchDataProvider: AnyObject {
  func getAppLaunchData() async throws -> Data
}
