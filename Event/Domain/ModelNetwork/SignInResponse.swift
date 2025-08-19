import Foundation

struct SignInResponseStatus: Decodable {
  let success: Bool
  let message: SignInResponse
}

struct SignInResponse: Decodable {
  let tokens: Tokens?
  let user: User?
}

struct SignUpResponseStatus: Decodable {
  let success: Bool
  let message: SignUpResponse
}

struct SignUpResponse: Decodable {
  let message: String
}


struct VerifyOtpReponse: Decodable {
  let success: Bool
  let message: String
}

struct SetUpPasswordResponseStatus: Decodable {
  let success: Bool
  let message: SetUpPasswordResponse
}

struct SetUpPasswordResponse: Decodable {
  let message: String
  let user: User
  let tokens: Tokens
}

struct Tokens: Decodable {
    let accessToken: String
    let refreshToken: String
}

struct User: Decodable {
    let _id: String
    let firstName: String
    let email: String
    let isDeleted: Bool
    let providers: [String]
    let authLevel: String
    let otp: String?
    let hashedPassword: String

}
