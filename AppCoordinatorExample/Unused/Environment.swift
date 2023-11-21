import Foundation

var Current = Environment()

struct Environment {
  var loggedInUsername: () -> String? = { UserDefaults.standard.loggedInUsername }
  var clearSavedData: () -> Void = { UserDefaults.standard.clear() }
  var dataLoader = DataLoader()
}

extension Environment {
  static let mock = Environment(
    loggedInUsername: { return nil },
    clearSavedData: {},
    dataLoader: .mock
  )

  private func mockFetchData(completion: (@escaping (Result<String, Error>) -> Void)) {
    completion(.success("ok"))
  }
}

struct DataLoader {
  var fetchData = fetchData(completion:)
}

private func fetchData(completion: (@escaping (Result<String, Error>) -> Void)) {
  DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
    completion(.success("ok"))
  }
}

extension DataLoader {
  static let mock = DataLoader(fetchData: { callback in
    callback(.success("ok"))
  })
}
