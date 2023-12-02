import Foundation

class APIClient: AppLaunchDataProvider {

  func getAppLaunchData() async throws -> Data {
    try await Task.sleep(nanoseconds: UInt64(1e9))
    return Data()
  }

}
