import Foundation


struct SecureKeys {
  
  static let shared = SecureKeys()
  
  private init(){}
  
  let userSessionKey = "UserSession"
  let appStateKey = "AppState"

  
}

