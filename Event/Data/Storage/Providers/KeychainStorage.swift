import Foundation
import KeychainSwift

final class KeychainStorageProvider: StorageProvider {
  
  static let shared = KeychainStorageProvider()
  private init(){}
  
  private let keychain = KeychainSwift()
  
  func store<T: Codable>(_ value: T, forKey key: String) throws {
    let data = try JSONEncoder().encode(value)
    keychain.set(data, forKey: key)
  }
  
  func read<T: Codable>(_ type: T.Type, forKey key: String) throws -> T? {
    guard let data = keychain.getData(key) else { return nil }
    return try JSONDecoder().decode(type, from: data)
  }
  
  func delete(forKey key: String) throws {
    keychain.delete(key)
  }
}
