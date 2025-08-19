import Foundation

struct UserSession: Codable {
  let accessToken: String
  let refreshToken: String
}
