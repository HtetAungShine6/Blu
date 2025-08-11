import GoogleSignIn
import Foundation

protocol GoogleOAuthService {
    func retrieveGoogleUser() async throws -> GIDGoogleUser
    func clearGoogleSession()
}

class GoogleOAuthServiceImpl: GoogleOAuthService {
    
    func retrieveGoogleUser() async throws -> GIDGoogleUser {
        let rootVC = await AppUtility.rootViewController()
        return try await withCheckedThrowingContinuation{ (continuation: CheckedContinuation<GIDGoogleUser, Error>) in
            Task { @MainActor in
                DispatchQueue.main.async {
                    GIDSignIn.sharedInstance.signIn(withPresenting: rootVC) { result, error in
                        if let error = error {
                            continuation.resume(throwing: error)
                        } else if let user = result?.user {
                            continuation.resume(returning: user)
                        } else {
                            continuation.resume(throwing: NSError(domain: "UnknownSignInError", code: 2))
                        }
                    }
                }
            }
        }
    }
    
    func clearGoogleSession() {
        GIDSignIn.sharedInstance.signOut()
    }
}
