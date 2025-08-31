import Foundation

protocol StorageProvider {
  func store<T: Codable>(_ value: T, forKey key: String) throws
  func read<T: Codable>(_ type: T.Type, forKey key: String) throws -> T?
  func delete(forKey key: String) throws
}


final class StorageManager {
  
  private let provider: StorageProvider
  
  init(provider: StorageProvider) {
    self.provider = provider
  }
  
  func save<T: Codable>(_ value: T, forKey key: String) throws {
    try provider.store(value, forKey: key)
  }
  
  func get<T: Codable>(_ type: T.Type, forKey key: String) throws -> T? {
    try provider.read(type, forKey: key)
  }
  
  func remove(forKey key: String) throws {
    try provider.delete(forKey: key)
  }
  
}
