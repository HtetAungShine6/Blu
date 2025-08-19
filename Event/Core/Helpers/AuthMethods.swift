enum AuthMethods {
  case google
  case emailPassword(dto: EmailSignInDto)
}

struct EmailSignInDto: Encodable {
  let email: String
  let password: String
}

struct SignUpDto: Encodable {
  let name: String
  let email: String
}

struct ResendOtpDto: Encodable {
  let name: String
  let email: String
}

struct VerifyOtpDto: Encodable {
  let email: String
  let otp: String
}

struct PasswordSetUpDto: Encodable {
  let password: String
  let email: String
}
