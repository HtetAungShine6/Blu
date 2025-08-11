import Foundation

protocol AuthRepository {
  func signIn(_ method: AuthMethods) async throws
  func signUp(_ dto: SignUpDto) async throws
  func signOut()
}

final class AuthRepositoryImpl: AuthRepository {
  private let googleOAuthService: GoogleOAuthService
  
  init(googleOAuthService: GoogleOAuthService) {
    self.googleOAuthService = googleOAuthService
  }
  
  func signIn(_ method: AuthMethods) async throws {
    switch method {
    case .google:
      try await signInWithGoogle()
    case .emailPassword(let dto):
      try await signInWithEmailPassword(dto: dto)
    }
  }
  
  func signUp(_ dto: SignUpDto) async throws {
    try await registerNewUser(dto: dto)
  }
  
  func signOut() {
    signOutFromAccount()
  }
  
}

// MARK: Helpers
private extension AuthRepositoryImpl {
  private func signInWithGoogle() async throws {
    let user = try await googleOAuthService.retrieveGoogleUser()
    guard let returnedIdToken = user.idToken?.tokenString else {
      throw NSError(domain: "Missing ID Token", code: 3)
    }
    
    // other impl
    UserDefaults.standard.set(true, forKey: "appState")
  }
  
  private func signInWithEmailPassword(dto: EmailSignInDto) async throws {
    print("Sign in with email password not implemented")
  }
  
  private func registerNewUser(dto: SignUpDto) async throws {
    print("Sign Up func not implemented")
  }
  
  private func signOutFromAccount() {
    UserDefaults.standard.set(false, forKey: "appState")
  }
}
