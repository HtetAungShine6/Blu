import Foundation

protocol AuthRepository {
  func signIn(_ method: AuthMethods) async throws
  func signUp(_ dto: SignUpDto) async throws
  func resendOtp(_ dto: ResendOtpDto) async throws
  func verifyOtp(_ dto: VerifyOtpDto) async throws
  func setUpPassword(_ dto: PasswordSetUpDto) async throws
  func signOut()
}

final class AuthRepositoryImpl: AuthRepository {
  
  private let googleOAuthService: GoogleOAuthService
  private let networkManager: NetworkManagable
  private let secureStorageManager: StorageManager
  private let localStorageManager: StorageManager
  private let secureKeys: SecureKeys = SecureKeys.shared
  
  
  init(
    googleOAuthService: GoogleOAuthService,
    networkManager: NetworkManagable = DefaultNetworkManager(),
    secureStorageManager: StorageManager = StorageManager(provider: KeychainStorageProvider.shared),
    localStorageManager: StorageManager = StorageManager(provider: UserDefaultsStorageProvider.shared)
  ) {
    self.googleOAuthService = googleOAuthService
    self.networkManager = networkManager
    self.secureStorageManager = secureStorageManager
    self.localStorageManager = localStorageManager
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
    do {
      let email = dto.email
      let name = dto.name
      _ = try await networkManager.request(AuthRouter.signUp(email: email, name: name), decodeTo: SignUpResponseStatus.self)
    } catch {
      print("Error is \(error.localizedDescription)")
      throw error
    }
  }
  
  
  func resendOtp(_ dto: ResendOtpDto) async throws {
    do {
      let email = dto.email
      let name = dto.name
      _ = try await networkManager.request(AuthRouter.resendOtp(firstName: name, email: email), decodeTo: SignUpResponseStatus.self)
    } catch {
      print("Error is \(error.localizedDescription)")
      throw error
    }
  }
  
  
  
  func verifyOtp(_ dto: VerifyOtpDto) async throws {
    do {
      let email = dto.email
      let otp = dto.otp
      _ = try await networkManager.request(AuthRouter.verifyEmail(email: email, otp: otp), decodeTo: VerifyOtpReponse.self)
    } catch {
      print("Error is \(error.localizedDescription)")
      throw error
    }
  }
  
  func setUpPassword(_ dto: PasswordSetUpDto) async throws {
    do {
      let email = dto.email
      let password = dto.password
      _ = try await networkManager.request(AuthRouter.setUpPassword(email: email, password: password), decodeTo: SetUpPasswordResponse.self)
    } catch {
      print("Error is \(error.localizedDescription)")
      throw error
    }
  }
  
  
  func signOut() {
    signOutFromAccount()
  }
  
}

// MARK: Helpers
private extension AuthRepositoryImpl {
  
  // MARK: - Google Sign In
  private func signInWithGoogle() async throws {
    let user = try await googleOAuthService.retrieveGoogleUser()
    guard let returnedIdToken = user.idToken?.tokenString else {
      throw NSError(domain: "Missing ID Token", code: 3)
    }
    
    do {
      let response = try await networkManager.request(AuthRouter.googleSignIn(idToken: returnedIdToken, provider: .google),decodeTo: OAuthLogInResponseStauts.self)
      saveTokensAndState(response: response.message)
    } catch {
      print("Error is \(error.localizedDescription)")
      throw error
    }
    
    
    // other impl
    UserDefaults.standard.set(true, forKey: "appState")
  }
  
  
  // MARK: - Email Sign In
  private func signInWithEmailPassword(dto: EmailSignInDto) async throws  {
    do {
      let email = dto.email
      let password = dto.password
      let response = try await networkManager.request(AuthRouter.signIn(email: email, password: password), decodeTo: SignInResponseStatus.self)
      saveTokensAndState(response: response.message)
    } catch(let error) {
      print("Error is \(error.localizedDescription)")
      throw error
    }
  }
  
  private func saveTokensAndState(response: SignInResponse) {
    if let tokens = response.tokens {
      try? secureStorageManager.save(UserSession(accessToken: tokens.accessToken, refreshToken: tokens.refreshToken), forKey: secureKeys.userSessionKey)
      try? localStorageManager.save(true, forKey: secureKeys.appStateKey)
    }
  }
    
  // MARK: -Sign Out
  private func signOutFromAccount() {
    let secureKeys = SecureKeys.shared
    try? localStorageManager.save(false, forKey: secureKeys.appStateKey)
  }
  
  
}
