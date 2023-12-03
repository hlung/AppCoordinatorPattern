import Foundation

class APIClient: AppLaunchDataProvider {

  func getAppLaunchData() async throws -> Data {
    // Perform various async calls that happens at app launch/login (stuff in Viki Prefetcher):
    // - fetch config cat
    // - fetch latest session info from viki backend
    // - call DeviceController.registerDeviceAndCapabilitiesIfNeeded()
    // - call refreshSubscribedResourceIDs
    // - set up offlineViewingController
    // - set up watchlistController
    // - set up watchMarkersController
    // - set up rentalPlaybackMarkersController

    try await Task.sleep(for: .seconds(2))
    return Data()
  }

}
