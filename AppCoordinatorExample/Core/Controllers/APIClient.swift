import Foundation

class APIClient: AppLaunchDataProvider {

  func getAppLaunchData() async throws -> Data {
    try await Task.sleep(for: .seconds(1))
    return Data()
  }

}
