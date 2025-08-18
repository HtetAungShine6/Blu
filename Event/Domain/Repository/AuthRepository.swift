import Foundation

protocol AuthRepository {
  func signIn(_ method: AuthMethods) async throws
  func signUp(_ dto: SignUpDto) async throws
  func signOut()
}

final class AuthRepositoryImpl: AuthRepository {
  
  private let googleOAuthService: GoogleOAuthService
  private let networkManager: NetworkManagable
  
  init(
    googleOAuthService: GoogleOAuthService,
    networkManager: NetworkManagable = DefaultNetworkManager()
  ) {
    self.googleOAuthService = googleOAuthService
    self.networkManager = networkManager
  }
  
  func DefaultNetworkManagersignIn(_ method: AuthMethods) async throws {
    switch method {
    case .google:
      try await signInWithGoogle()
    case .emailPassword(let dto):
      try await signInWithEmailPassword(dto: dto)
    }
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
  
  private func signInWithEmailPassword(dto: EmailSignInDto) async throws -> SignInResponseStatus {
    do {
      let email = dto.email
      let password = dto.password
      let response = try await networkManager.request(AuthRouter.signIn(email: email, password: password), decodeTo: SignInResponseStatus.self)
      print("respones is \(response)")
      print(response.message.tokens)
      print(response.message.user)
      return response
    } catch(let error) {
      print("Error is \(error.localizedDescription)")
      throw error
    }
  }
  
  private func registerNewUser(dto: SignUpDto) async throws {
    print("Sign Up func not implemented")
  }
  
  private func signOutFromAccount() {
    UserDefaults.standard.set(false, forKey: "appState")
  }
}
