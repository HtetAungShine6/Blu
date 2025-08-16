import Foundation

enum SSOProvider {
  case google
}


enum AuthRouter: APIRouter {
  case signIn(email: String, password: String)
  case signUp(email: String, name: String)
  case verifyEmail(email: String, otp: String)
  case resendOtp(email: String)
  case setUpPassword(email: String, password: String)
  case googleSignIn(idToken: String, provider: SSOProvider)
  
  
  
  var method: HTTPMethod {
    switch self {
    case .signIn:
      return .post
    case .signUp:
      return .post
    case .verifyEmail:
      return .post
    case .resendOtp:
      return .post
    case .setUpPassword:
      return .post
    case .googleSignIn:
      return .post
    }
  }
  
  var path: String {
    switch self {
    case .signIn:
      return "auth/login"
    case .signUp:
      return "auth/signup"
    case .verifyEmail:
      return "auth/verify-email"
    case .resendOtp:
      return "auth/resend-otp"
    case .setUpPassword:
      return "auth/set-up-password"
    case .googleSignIn:
      return "auth/oauth-login"
    }
  }
  
  var queryParams: [String : Any]? {
    switch self {
    default:
      return nil
    }
  }
  
  var headers: [String : String]? {
    [
      "Content-Type": "application/json",
    ]
  }
  
  var body: [String: Any]? {
    switch self {
    case .signIn(let email, let password):
      return ["email": email, "password": password]
    case .signUp(let email, let name):
      return ["email": email, "name": name]
    case .verifyEmail(let email, let otp):
      return ["email": email, "otp": otp]
    case .resendOtp:
      return nil
    case .setUpPassword(let email, let password):
      return ["email": email, "password": password]
    case .googleSignIn(let idToken, let provider):
      return ["idToken": idToken, "provider": "\(provider)"]
    }
  }
  
}
