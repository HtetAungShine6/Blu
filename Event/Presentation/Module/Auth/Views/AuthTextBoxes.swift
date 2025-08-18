import SwiftUI

struct AuthTextBoxesConfig {
  @FocusState.Binding var isEmailFocused: Bool
  @FocusState.Binding var isPasswordFocused: Bool
  var isFullNameFocused: FocusState<Bool>.Binding? = nil
  var isConfirmPasswordFocused: FocusState<Bool>.Binding? = nil
  let useInSignIn: Bool
  @Binding var email: String
  @Binding var password: String
  var fullName: Binding<String> = .constant("")
  var confirmPassword: Binding<String> = .constant("")
  var validationMessage: String? = nil
  var showValidation: Bool = false
}

struct AuthTextBoxes: View {
  
  var config: AuthTextBoxesConfig
  
  var body: some View {
    VStack(spacing: .spacer9) {
      if config.useInSignIn {
        TextBox(config: TextBoxConfig(
          isFocused: config.$isEmailFocused,
          placeholder: "Enter your email",
          icon: "envelope",
          type: .normal,
          useInSignIn: true,
          text: config.$email,
          height: 60,
          font: .body1,
          strokeColor: .textSecondaryDark,
          validationMessage: config.validationMessage,
          validationColor: .red,
          showValidation: config.showValidation
        ))
        
        TextBox(config: TextBoxConfig(
          isFocused: config.$isPasswordFocused,
          placeholder: "Enter your password",
          icon: "lock",
          type: .secure,
          text: config.$password,
          height: 60,
          font: .body1,
          strokeColor: .textSecondaryDark,
          validationMessage: config.validationMessage,
          showValidation: config.showValidation
        ))
      } else {
        if let fullNameFocused = config.isFullNameFocused {
          TextBox(config: TextBoxConfig(
            isFocused: fullNameFocused,
            placeholder: "Enter your name",
            icon: "person",
            type: .normal,
            text: config.fullName,
            height: 60,
            font: .body1,
            strokeColor: .textSecondaryDark
          ))
        }
        
        TextBox(config: TextBoxConfig(
          isFocused: config.$isEmailFocused,
          placeholder: "Enter your email",
          icon: "envelope",
          type: .normal,
          useInSignUp: true,
          text: config.$email,
          height: 60,
          font: .body1,
          strokeColor: .textSecondaryDark,
          validationMessage: config.validationMessage,
          validationColor: .red,
          showValidation: config.showValidation
        ))
        
        TextBox(config: TextBoxConfig(
          isFocused: config.$isPasswordFocused,
          placeholder: "Enter your password",
          icon: "lock",
          type: .secure,
          useInSignUp: true,
          text: config.$password,
          height: 60,
          font: .body1,
          strokeColor: .textSecondaryDark,
          validationMessage: config.validationMessage,
          showValidation: config.showValidation
        ))
        
        if let isConfirmPasswordFocused = config.isConfirmPasswordFocused {
          TextBox(config: TextBoxConfig(
            isFocused: isConfirmPasswordFocused,
            placeholder: "Confirm your password",
            icon: "checkmark.shield",
            type: .secure,
            useInSignUp: true,
            text: config.confirmPassword,
            height: 60,
            font: .body1,
            strokeColor: .textSecondaryDark,
            passwordToMatch: config.password
          ))
        }
      }
    }
    .padding(.horizontal, 20)
  }
}
