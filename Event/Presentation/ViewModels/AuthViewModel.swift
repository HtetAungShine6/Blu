import Foundation

@MainActor
protocol AuthViewModel: ObservableObject {
    var isLoading: Bool { get }
    var error: String { get }
    func signIn(_ method: AuthMethods) async
    func signOut(_ method: AuthMethods)
}


final class AuthViewModelImpl: AuthViewModel {
    @Published var isLoading: Bool = false
    @Published var error: String = ""
    
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func signIn(_ method: AuthMethods) async {
        switch method {
        case .google:
            return await signInWithGoogle()
        case .emailPassword:
            return signInWithEmailPassword()
        }
    }
    
    func signOut(_ method: AuthMethods) {
        switch method {
        case .google:
            return signOutWithGoogle()
        case .emailPassword:
            return signOutWithEmailPassword()
        }
    }
}


private extension AuthViewModelImpl {
    private func signInWithGoogle() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let idToken = try await authRepository.signIn(.google)
            print("ID Token: \(idToken)")
        } catch {
            self.error = error.localizedDescription
        }
    }
    
    private func signInWithEmailPassword() {
        authRepository.signOut(.emailPassword)
    }
    
    private func signOutWithGoogle() {
        authRepository.signOut(.google)
    }
    
    private func signOutWithEmailPassword() {
        authRepository.signOut(.emailPassword)
    }
}
