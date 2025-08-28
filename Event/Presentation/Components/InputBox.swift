import SwiftUI

enum InputBoxTypes {
  case normal
  case secure
}

enum ValidationTypes {
  case neutral
  case valid
  case invalid
}

struct InputBox: View {
  
  private var placeholder: String
  @Binding private var text: String
  
  private var font: Label.Style = .body1
  private var textColor: Color = AppTheme.AppColor.TextColor.primaryDark
  private var type: InputBoxTypes = .normal
  private var disabled: Bool = false
  private var keyboard: UIKeyboardType = .default
  private var icon: String? = nil
  private var focus: FocusState<Bool>.Binding
  private var validator: ValidationTypes = .neutral
  private var helperText: String? = nil
  
  @State private var isPasswordVisible: Bool = false
  
  public init(_ placeholder: String, text: Binding<String>, focus: FocusState<Bool>.Binding) {
    self.placeholder = placeholder
    self._text = text
    self.focus = focus
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: .spacer1) {
      HStack {
        iconWrapper
        if type == .secure {
          passwordField
        } else {
          textField
        }
      }
      .padding(.horizontal, 10)
      .frame(maxWidth: .infinity, maxHeight: 60)
      .background {
        RoundedRectangle(cornerRadius: .radius3)
          .strokeBorder(borderColor(), lineWidth: 1)
      }
      .animation(.easeInOut(duration: 0.3), value: focus.wrappedValue)
      .focused(focus)
      
      supportingText
    }
  }
}

//MARK: - UI Extensions
extension InputBox {
  private var passwordField: some View {
    HStack {
      SecureCompatibleTextField(text: $text, placeholder: placeholder, isSecureEntry: !isPasswordVisible)
      
      Button {
        isPasswordVisible.toggle()
      } label: {
        Image(systemName: isPasswordVisible ? "eye" : "eye.slash")
          .foregroundColor(.textSecondaryDark)
      }
    }
  }
  
  private var textField: some View {
    TextField(placeholder, text: $text)
      .font(textStyle)
      .foregroundStyle(textColor)
      .keyboardType(keyboard)
  }
  
  private var supportingText: some View {
    Label(helperText ?? "Placeholder")
      .font(.small1)
      .color(helperText == nil ? .clear : borderColor())
      .frame(height: 16, alignment: .leading)
      .frame(maxWidth: .infinity, alignment: .leading)
      .animation(.easeInOut(duration: 0.3), value: helperText)
  }
}


//MARK: - Builder Pattern Functions for InputBox
extension InputBox {
  public func font(_ style: Label.Style) -> InputBox {
    var copy = self
    copy.font = style
    return copy
  }
  
  public func textColor(_ color: Color) -> InputBox {
    var copy = self
    copy.textColor = color
    return copy
  }
  
  public func keyboard(_ type: UIKeyboardType) -> InputBox {
    var copy = self
    copy.keyboard = type
    return copy
  }
  
  public func disabled(_ disabled: Bool = true) -> InputBox {
    var copy = self
    copy.disabled = disabled
    return copy
  }
  
  public func type(_ type: InputBoxTypes) -> InputBox {
    var copy = self
    copy.type = type
    return copy
  }
  
  public func icon(_ icon: String?) -> InputBox {
    var copy = self
    copy.icon = icon
    return copy
  }
  
  public func focus(_ focus: FocusState<Bool>.Binding) -> InputBox {
    var copy = self
    copy.focus = focus
    return copy
  }
  
  public func validator(_ validator: ValidationTypes) -> InputBox {
    var copy = self
    copy.validator = validator
    return copy
  }
  
  public func helperText(_ helperText: String?) -> InputBox {
    var copy = self
    copy.helperText = helperText
    return copy
  }
}


//MARK: - Font Supporter for InputBox
extension InputBox {
  private var textStyle: SwiftUI.Font {
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


//MARK: - Helper Functions
extension InputBox {
  private func icons(named icon: String) -> some View {
    Image(systemName: icon)
      .resizable()
      .scaledToFit()
      .frame(width: 18, height: 18)
      .frame(width: 24, alignment: .center)
      .foregroundColor(.textSecondaryDark)
  }
  
  private var iconWrapper: some View {
    if let icon = icon {
      return AnyView(icons(named: icon))
    } else {
      return AnyView(EmptyView())
    }
  }
  
  private func borderColor() -> Color {
    let color: Color
    switch validator {
    case .neutral: color = focus.wrappedValue ? .accent : .defaultBorder
    case .valid:   color = .green
    case .invalid: color = .red
    }
    return color
  }
}


#Preview {
  @Previewable @FocusState var isUserNameFocused: Bool
  @Previewable @FocusState var isEmailFocused: Bool
  @Previewable @FocusState var isPasswordFocused: Bool
  @Previewable @FocusState var isErrorTextFieldFocused: Bool
  @Previewable @State var userName: String = ""
  @Previewable @State var email: String = ""
  @Previewable @State var password: String = ""
  @Previewable @State var errorTextField: String = ""
  
  func emailHelper() -> String {
    switch validator(for: email) {
    case .valid: return "Valid Email"
    case .invalid: return "Invalid Email"
    default: return ""
    }
  }
  
  func passwordHelper() -> String {
    switch validator(for: password, type: .secure) {
    case .valid: return "Valid Password"
    case .invalid: return "Invalid Password"
    default: return ""
    }
  }
  
  func validator(for field: String, type: InputBoxTypes = .normal) -> ValidationTypes {
    if field.isEmpty {
      return .neutral
    }
    switch type {
    case .normal:
      if field.contains("@") && field.contains(".") {
        return .valid
      } else {
        return .invalid
      }
    case .secure:
      if field.count >= 6 {
        return .valid
      } else {
        return .invalid
      }
    }
  }
  
  
  return VStack(spacing: .spacer2) {
    InputBox("Username", text: $userName, focus: $isUserNameFocused)
      .font(.body1)
      .textColor(.textPrimaryDark)
      .keyboard(.emailAddress)
      .type(.normal)
    
    InputBox("Email", text: $email, focus: $isEmailFocused)
      .font(.body1)
      .textColor(.textPrimaryDark)
      .keyboard(.emailAddress)
      .type(.normal)
      .icon("envelope")
      .validator(validator(for: email))
      .helperText(emailHelper())
    
    InputBox("Password", text: $password, focus: $isPasswordFocused)
      .font(.body1)
      .textColor(.textPrimaryDark)
      .type(.secure)
      .icon("lock")
      .validator(validator(for: password, type: .secure))
      .helperText(passwordHelper())
    
    InputBox("Error Text Field", text: $errorTextField, focus: $isErrorTextFieldFocused)
      .font(.body1)
      .textColor(.textPrimaryDark)
      .keyboard(.emailAddress)
      .type(.normal)
      .icon("envelope")
      .validator(.invalid)
      .helperText("Wrong Format")
  }
}
