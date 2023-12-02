import Foundation

public struct Session: CustomStringConvertible {
  public let user: User

  public var description: String {
    return "\(Swift.type(of: self)) user:\(user.username)"
  }
}

public struct User {
  public let id: String = "0"
  public let username: String
}
