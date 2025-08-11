import Foundation

@MainActor
protocol AuthViewModel: ObservableObject {
  var isLoading: Bool { get }
  var error: String { get }
  func signIn(_ method: AuthMethods) async
  func signUp(_ dto: SignUpDto) async
  func signOut()
  var signInemail: String { get set }
  var signInPassword: String { get set }
  var email: String { get set }
  var fullName: String { get set }
  var password: String { get set }
  var confirmPassword: String { get set }
  var phoneNumber: String { get set }
}


final class AuthViewModelImpl: AuthViewModel {
  
  @Published var signInemail: String = ""
  @Published var signInPassword: String = ""
  @Published var email: String = ""
  @Published var fullName: String = ""
  @Published var password: String = ""
  @Published var confirmPassword: String = ""
  @Published var phoneNumber: String = ""
  @Published var isLoading: Bool = false
  @Published var error: String = ""
  
  
  private let authRepository: AuthRepository
  
  init(authRepository: AuthRepository) {
    self.authRepository = authRepository
  }
  
  func signIn(_ method: AuthMethods) async {
    switch method {
    case .google:
      await signInWithGoogle()
    case .emailPassword(let dto):
      await signInWithEmailPassword(dto: dto)
    }
  }
  
  
  func signOut() {
    
  }
  
  func signUp(_ dto: SignUpDto) async {
    await registerNewUser(dto: dto)
  }
  
}


private extension AuthViewModelImpl {
  private func signInWithGoogle() async {
    isLoading = true
    defer { isLoading = false }
    do {
      let idToken = try await authRepository.signIn(.google)
    } catch {
      self.error = error.localizedDescription
    }
  }
  
  private func signInWithEmailPassword(dto: EmailSignInDto) async {
    isLoading = true
    defer { isLoading = false }
    do {
      try await authRepository.signIn(.emailPassword(dto: EmailSignInDto(email: signInemail, password: signInPassword)))
    } catch {
      self.error = error.localizedDescription
    }
  }
  
  private func registerNewUser(dto: SignUpDto) async {
    isLoading = true
    defer { isLoading = false }
    do {
      try await authRepository.signUp(SignUpDto(name: fullName, email: email, password: password, confirmPasword: confirmPassword, phoneNumber: phoneNumber))
    } catch {
      self.error = error.localizedDescription
    }
  }
  
}
