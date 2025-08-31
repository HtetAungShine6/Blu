import Foundation

protocol NetworkManagable {
  func request<T: Decodable>(_ router: APIRouter, decodeTo type: T.Type) async throws -> T
}


final class DefaultNetworkManager: NetworkManagable {
  func request<T: Decodable>(_ router: APIRouter, decodeTo type: T.Type) async throws -> T {
    let request = try buildRequest(from: router)
    let (data, response) = try await URLSession.shared.data(for: request)
    
    guard let httpResponse = response as? HTTPURLResponse,
          (200..<300).contains(httpResponse.statusCode) else {
      throw URLError(.badServerResponse)
    }
    print("Data is \(data)")
    do {
      let result = try JSONDecoder().decode(T.self, from: data)
      return result
    } catch {
      print("Error is \(error)")
      throw error
    }
  }
  
  
  private func buildRequest(from router: APIRouter) throws -> URLRequest {
    var components = URLComponents(string: router.baseURL + router.path)!
    if let queryParams = router.queryParams {
      components.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
    }
    
    var request = URLRequest(url: components.url!)
    request.httpMethod = router.method.rawValue
    request.allHTTPHeaderFields = router.headers
    if let body = router.body {
      request.httpBody = try? JSONSerialization.data(withJSONObject: body)
    }
    return request
  }
}
