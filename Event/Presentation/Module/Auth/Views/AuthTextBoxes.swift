import SwiftUI

struct AuthTextBoxes: View {
  let useInSignIn: Bool
  
  @Binding private var email: String
  @Binding private var password: String
  @Binding private var fullName: String
  @Binding private var confirmPassword: String
  
  @Binding private var validationMessage: String?
  @Binding private var showValidation: Bool
  
  @FocusState.Binding private var isEmailFocused: Bool
  @FocusState.Binding private var isPasswordFocused: Bool
  private var isFullNameFocused: FocusState<Bool>.Binding?
  private var isConfirmPasswordFocused: FocusState<Bool>.Binding?
  
  var body: some View {
    VStack(spacing: .spacer7) {
      if useInSignIn {
        TextBox(config: TextBoxConfig(
          placeholder: "Enter your email",
          icon: "envelope",
          type: .normal,
          useInSignIn: true,
          text: $email,
          width: 365,
          height: 60,
          font: .body1,
          strokeColor: .textSecondaryDark,
          validationMessage: validationMessage,
          validationColor: .red,
          showValidation: showValidation
        ), isFocused: $isEmailFocused)
        
        TextBox(config: TextBoxConfig(
          placeholder: "Enter your password",
          icon: "lock",
          type: .secure,
          text: $password,
          width: 365,
          height: 60,
          font: .body1,
          strokeColor: .textSecondaryDark,
          validationMessage: validationMessage,
          showValidation: showValidation
        ), isFocused: $isPasswordFocused)
      } else {
        if let fullNameFocused = isFullNameFocused {
          TextBox(config: TextBoxConfig(
            placeholder: "Enter your name",
            icon: "person",
            type: .normal,
            text: $fullName,
            width: 365,
            height: 60,
            font: .body1,
            strokeColor: .textSecondaryDark
          ), isFocused: fullNameFocused)
        }
        
        TextBox(config: TextBoxConfig(
          placeholder: "Enter your email",
          icon: "envelope",
          type: .normal,
          useInSignUp: true,
          text: $email,
          width: 365,
          height: 60,
          font: .body1,
          strokeColor: .textSecondaryDark,
          validationMessage: validationMessage,
          validationColor: .red,
          showValidation: showValidation
        ), isFocused: $isEmailFocused)
        
        TextBox(config: TextBoxConfig(
          placeholder: "Enter your password",
          icon: "lock",
          type: .secure,
          useInSignUp: true,
          text: $password,
          width: 365,
          height: 60,
          font: .body1,
          strokeColor: .textSecondaryDark,
          validationMessage: validationMessage,
          showValidation: showValidation
        ), isFocused: $isPasswordFocused)
        
        if let isConfirmPasswordFocused = isConfirmPasswordFocused {
          TextBox(config: TextBoxConfig(
            placeholder: "Enter your password again",
            icon: "lock",
            type: .secure,
            useInSignUp: true,
            text: $confirmPassword,
            width: 365,
            height: 60,
            font: .body1,
            strokeColor: .textSecondaryDark,
            passwordToMatch: password
          ), isFocused: isConfirmPasswordFocused)
        }
      }
    }
  }
}

extension AuthTextBoxes {
  init(
    useInSignIn: Bool,
    email: Binding<String>,
    password: Binding<String>,
    fullName: Binding<String>? = nil,
    confirmPassword: Binding<String>? = nil,
    validationMessage: Binding<String?>,
    showValidation: Binding<Bool>,
    isEmailFocused: FocusState<Bool>.Binding,
    isPasswordFocused: FocusState<Bool>.Binding,
    isFullNameFocused: FocusState<Bool>.Binding? = nil,
    isConfirmPasswordFocused: FocusState<Bool>.Binding? = nil
  ) {
    self.useInSignIn = useInSignIn
    self._email = email
    self._password = password
    self._fullName = fullName ?? .constant("")
    self._confirmPassword = confirmPassword ?? .constant("")
    self._validationMessage = validationMessage
    self._showValidation = showValidation
    self._isEmailFocused = isEmailFocused
    self._isPasswordFocused = isPasswordFocused
    self.isFullNameFocused = isFullNameFocused
    self.isConfirmPasswordFocused = isConfirmPasswordFocused
  }
}
