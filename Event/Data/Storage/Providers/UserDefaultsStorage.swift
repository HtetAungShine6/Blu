import Foundation

final class UserDefaultsStorageProvider: StorageProvider {
  
  static let shared = UserDefaultsStorageProvider()
  
  private init(){}
  
  private let defaults = UserDefaults.standard
  
  func store<T>(_ value: T, forKey key: String) throws where T : Codable {
    let encoder = JSONEncoder()
    let data = try encoder.encode(value)
    defaults.set(data, forKey: key)
  }
  
  func read<T>(_ type: T.Type, forKey key: String) throws -> T? where T : Codable {
    guard let data = defaults.data(forKey: key) else { return nil }
    let decoder = JSONDecoder()
    return try decoder.decode(type, from: data)
  }
  
  func delete(forKey key: String) throws {
    defaults.removeObject(forKey: key)
  }
}

