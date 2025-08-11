import Foundation

protocol AuthRepository {
    func signIn(_ method: AuthMethods) async throws -> String
    func signOut(_ method: AuthMethods)
}

final class AuthRepositoryImpl: AuthRepository {
    private let googleOAuthService: GoogleOAuthService
    
    init(googleOAuthService: GoogleOAuthService) {
        self.googleOAuthService = googleOAuthService
    }
    
    func signIn(_ method: AuthMethods) async throws -> String {
        switch method {
        case .google:
            return try await signInWithGoogle()
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

private extension AuthRepositoryImpl {
    private func signInWithGoogle() async throws -> String {
        let user = try await googleOAuthService.retrieveGoogleUser()
        guard let idToken = user.idToken?.tokenString else {
            throw NSError(domain: "Missing ID Token", code: 3)
        }
        UserDefaults.standard.set(true, forKey: "appState")
        return idToken
    }
    
    private func signInWithEmailPassword() -> String {
        return "Sign in with email password not implemented"
    }
    
    private func signOutWithGoogle() {
        UserDefaults.standard.set(false, forKey: "appState")
        googleOAuthService.clearGoogleSession()
    }
    
    private func signOutWithEmailPassword() {
        print("Sign out with email password not implemented")
    }
}
