import SwiftUI
import UIKit

enum TextBoxTypes {
  case normal
  case secure
}

struct TextBox: View {
  
  var config: TextBoxConfig
  
  @State private var isSecureVisible: Bool = false
  @FocusState.Binding var isFocused: Bool
  
  @State private var internalValidationMessage: String? = nil
  @State private var internalValidationColor: Color? = nil
  
  var body: some View {
    VStack(alignment: .leading, spacing: 4) {
      HStack() {
        if let icon = config.icon {
          Image(systemName: icon)
            .resizable()
            .scaledToFit()
            .frame(width: 18, height: 18)
            .frame(width: 24, alignment: .center)
            .foregroundColor(config.strokeColor)
        }
        
        if config.type == .secure {
          SecureCompatibleTextField(
            text: config.text,
            placeholder: config.placeholder,
            isSecureEntry: !isSecureVisible,
            font: config.textStyle,
            textColor: UIColor(config.foregroundColor)
          )
          .focused($isFocused)
          .onChange(of: config.text.wrappedValue) { _, newValue in
            if config.type == .secure && config.useInSignUp {
              validatePassword(newValue)
            } else if config.type == .secure && config.useInSignIn {
              validateEmail(newValue)
            }
          }
          
          Button {
            isSecureVisible.toggle()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
              isFocused = true
            }
          } label: {
            Image(systemName: isSecureVisible ? "eye.slash" : "eye")
              .foregroundColor(config.strokeColor)
          }
        } else {
          TextField(config.placeholder, text: config.text)
            .font(config.textStyle)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            .foregroundColor(config.foregroundColor)
            .focused($isFocused)
            .onChange(of: config.text.wrappedValue) { _, newValue in
              if config.type == .normal && config.useInSignIn || config.useInSignUp {
                validateEmail(newValue)
              }
            }
        }
      }
      .padding(.horizontal, config.horizontalPadding)
      .padding(.vertical, config.verticalPadding)
      .frame(width: config.width, height: config.height)
      .background(config.backgroundColor)
      .overlay(
        RoundedRectangle(cornerRadius: config.cornerRadius)
          .stroke(
            borderColor(),
            lineWidth: config.strokeWidth
          )
      )
      .clipShape(RoundedRectangle(cornerRadius: config.cornerRadius))
      .shadow(color: isFocused ? borderColor().opacity(0.4) : .clear, radius: isFocused ? 3 : 0, x: 0, y: 0)
      .animation(.easeInOut(duration: 0.25), value: isFocused)
      .animation(.easeInOut(duration: 0.5), value: internalValidationColor)
      
      if shouldShowValidationMessage(), let message = validationMessage() {
        Text(message)
          .font(.caption)
          .foregroundColor(validationColor() ?? .red)
          .padding(.leading, config.icon == nil ? config.horizontalPadding : config.horizontalPadding + 24)
      }
    }
    .onAppear {
      if config.useInSignUp {
        validatePassword(config.text.wrappedValue)
      }
      if config.useInSignIn {
        validateEmail(config.text.wrappedValue)
      }
    }
  }
}


struct TextBoxConfig {
  let placeholder: String
  let icon: String?
  let type: TextBoxTypes
  let useInSignUp: Bool
  let useInSignIn: Bool
  var text: Binding<String>
  var width: CGFloat?
  var height: CGFloat?
  var horizontalPadding: CGFloat
  var verticalPadding: CGFloat
  var font: Style
  var backgroundColor: Color
  var foregroundColor: Color
  var strokeColor: Color
  var strokeWidth: CGFloat
  var cornerRadius: CGFloat
  var validationMessage: String? = nil
  var validationColor: Color? = nil
  var showValidation: Bool? = nil
  
  init(
    placeholder: String,
    icon: String? = nil,
    type: TextBoxTypes,
    useInSignUp: Bool = false,
    useInSignIn: Bool = false,
    text: Binding<String>,
    width: CGFloat? = nil,
    height: CGFloat? = nil,
    horizontalPadding: CGFloat = 12,
    verticalPadding: CGFloat = 8,
    font: Style,
    backgroundColor: Color = Color(.systemBackground),
    foregroundColor: Color = .primary,
    strokeColor: Color = .gray,
    strokeWidth: CGFloat = 1,
    cornerRadius: CGFloat = .radius3,
    validationMessage: String? = nil,
    validationColor: Color? = .red,
    showValidation: Bool? = false
  ) {
    self.placeholder = placeholder
    self.icon = icon
    self.type = type
    self.useInSignUp = useInSignUp
    self.useInSignIn = useInSignIn
    self.text = text
    self.width = width
    self.height = height
    self.horizontalPadding = horizontalPadding
    self.verticalPadding = verticalPadding
    self.font = font
    self.backgroundColor = backgroundColor
    self.foregroundColor = foregroundColor
    self.strokeColor = strokeColor
    self.strokeWidth = strokeWidth
    self.cornerRadius = cornerRadius
    self.validationMessage = validationMessage
    self.validationColor = validationColor
    self.showValidation = showValidation
  }
}

extension TextBoxConfig {
  enum Style {
    case h1, h2, h3, h4, h5, subtitle1, subtitle2, body1, body2, small1, small2, small3, small4, button1, button2, button3
  }
  var textStyle: Font {
    switch font {
    case .h1: return AppTheme.TextStyle.h1()
    case .h2: return AppTheme.TextStyle.h2()
    case .h3: return AppTheme.TextStyle.h3()
    case .h4: return AppTheme.TextStyle.h4()
    case .h5: return AppTheme.TextStyle.h5()
    case .subtitle1: return AppTheme.TextStyle.subtitle1()
    case .subtitle2: return AppTheme.TextStyle.subtitle2()
    case .body1: return AppTheme.TextStyle.body1()
    case .body2: return AppTheme.TextStyle.body2()
    case .small1: return AppTheme.TextStyle.small1()
    case .small2: return AppTheme.TextStyle.small2()
    case .small3: return AppTheme.TextStyle.small3()
    case .small4: return AppTheme.TextStyle.small4()
    case .button1: return AppTheme.TextStyle.button1()
    case .button2: return AppTheme.TextStyle.button2()
    case .button3: return AppTheme.TextStyle.button3()
    }
  }
}

#Preview {
  @Previewable @State var username = ""
  @Previewable @State var password = ""
  @Previewable @State var sisiMomName = ""
  @Previewable @State var passwordSignUp = ""
  @Previewable @State var passwordSignIn = ""
  @FocusState var isFocused: Bool
  VStack(spacing: .spacer7) {
    TextBox(config: TextBoxConfig(
      placeholder: "Username",
      icon: "person",
      type: .normal,
      text: $username,
      width: 300,
      height: 60,
      font: .body1,
      strokeColor: .textSecondaryDark
    ), isFocused: $isFocused)
    
    TextBox(config: TextBoxConfig(
      placeholder: "Password",
      icon: "lock",
      type: .secure,
      text: $password,
      width: 365,
      height: 60,
      font: .body1,
      strokeColor: .textSecondaryDark
    ), isFocused: $isFocused)
    
    TextBox(config: TextBoxConfig(
      placeholder: "Password Sign In",
      icon: "lock",
      type: .secure,
      text: $passwordSignIn,
      width: 365,
      height: 60,
      font: .body1,
      strokeColor: .textSecondaryDark,
      validationMessage: "Wrong password",
      validationColor: .red
    ), isFocused: $isFocused)
    
    TextBox(config: TextBoxConfig(
      placeholder: "Email Sign In",
      icon: "envelope",
      type: .normal,
      text: $passwordSignIn,
      width: 365,
      height: 60,
      font: .body1,
      strokeColor: .textSecondaryDark,
      validationMessage: "Wrong email",
      validationColor: .red,
      showValidation: true
    ), isFocused: $isFocused)
    
    TextBox(config: TextBoxConfig(
      placeholder: "Email Sign In 2",
      icon: "envelope",
      type: .normal,
      useInSignIn: true,
      text: $passwordSignIn,
      width: 365,
      height: 60,
      font: .body1,
      strokeColor: .textSecondaryDark
    ), isFocused: $isFocused)
    
    TextBox(config: TextBoxConfig(
      placeholder: "Password Sign Up",
      icon: "lock",
      type: .secure,
      useInSignUp: true,
      text: $passwordSignUp,
      width: 365,
      height: 60,
      font: .body1,
      strokeColor: .textSecondaryDark
    ), isFocused: $isFocused)
    
    TextBox(config: TextBoxConfig(
      placeholder: "Enter sisi's mom name",
      type: .normal,
      text: $sisiMomName,
      width: 300,
      height: 60,
      font: .body1,
      strokeColor: .textSecondaryDark
    ), isFocused: $isFocused)
  }
}

extension TextBox {
  
  //MARK: - Email Validation
  private func validateEmail(_ email: String) {
    if email.isEmpty {
      internalValidationMessage = nil
      internalValidationColor = nil
    } else if isValidEmail(email) {
      internalValidationMessage = "Valid email"
      internalValidationColor = .green
    } else {
      internalValidationMessage = "Invalid email format"
      internalValidationColor = .red
    }
  }
  
  private func isValidEmail(_ email: String) -> Bool {
    let pattern = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
    return email.range(of: pattern, options: .regularExpression) != nil
  }
  
  //MARK: - Password Validation
  private func validatePassword(_ password: String) {
    if password.isEmpty {
      internalValidationMessage = nil
      internalValidationColor = nil
    } else if isStrongPassword(password) {
      internalValidationMessage = "Strong password"
      internalValidationColor = .green
    } else {
      internalValidationMessage = "Password is weak"
      internalValidationColor = .red
    }
  }
  
  private func isStrongPassword(_ password: String) -> Bool {
    let pattern = #"^(?=.*[A-Z])(?=.*[a-z])(?=.*\d).{8,}$"#
    return password.range(of: pattern, options: .regularExpression) != nil
  }
  
  //MARK: - Validation Message Setup (Color, String)
  private func validationMessage() -> String? {
    if config.useInSignUp || config.useInSignIn {
      return internalValidationMessage
    } else {
      return config.validationMessage
    }
  }
  
  private func validationColor() -> Color? {
    if config.useInSignUp || config.useInSignIn {
      return internalValidationColor
    } else {
      return config.validationColor
    }
  }
  
  private func shouldShowValidationMessage() -> Bool {
    if config.useInSignUp || config.useInSignIn {
      return internalValidationMessage != nil
    } else {
      return (config.showValidation ?? false) && config.validationMessage != nil
    }
  }
  
  private func borderColor() -> Color {
    if isFocused {
      if config.useInSignUp || config.useInSignIn {
        return internalValidationColor ?? .accent
      } else if config.showValidation ?? false {
        return config.validationColor ?? .accent
      }
      return .accent
    } else {
      if config.useInSignUp || config.useInSignIn {
        return internalValidationColor ?? config.strokeColor
      } else if config.showValidation ?? false {
        return config.validationColor ?? config.strokeColor
      }
      return config.strokeColor
    }
  }
}
