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
  let password: String
  let confirmPasword: String
  let phoneNumber: String
}
