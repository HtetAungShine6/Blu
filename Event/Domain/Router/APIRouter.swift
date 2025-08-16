import Foundation

protocol APIRouter {
  var baseURL: String { get }
  var method: HTTPMethod { get }
  var path: String { get }
  var queryParams: [String: Any]? { get }
  var headers: [String: String]? { get }
  var body: [String : Any]? { get }
}

extension APIRouter {
  var baseURL: String {
    NetworkConfig.shared.baseURL
  }
}

enum HTTPMethod: String {
  case get = "GET"
  case post = "POST"
  case put = "PUT"
  case patch = "PATCH"
  case delete = "DELETE"
}


