import SwiftUI
import UIKit

enum TextBoxTypes {
  case normal
  case secure
}

struct TextBox: View {
  var config: TextBoxConfig
  @State private var isSecureVisible: Bool = false
  
  var body: some View {
    HStack {
      if let icon = config.icon {
        Image(systemName: icon)
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
        
        Spacer(minLength: 8)
        
        Button {
          isSecureVisible.toggle()
        } label: {
          Image(systemName: isSecureVisible ? "eye.slash" : "eye")
            .foregroundColor(config.strokeColor)
        }
      } else {
        TextField(config.placeholder, text: config.text)
          .font(config.textStyle)
          .foregroundColor(config.foregroundColor)
      }
    }
    .padding(.horizontal, config.horizontalPadding)
    .padding(.vertical, config.verticalPadding)
    .frame(width: config.width, height: config.height)
    .background(config.backgroundColor)
    .overlay(
      RoundedRectangle(cornerRadius: config.cornerRadius)
        .stroke(config.strokeColor, lineWidth: config.strokeWidth)
    )
    .clipShape(RoundedRectangle(cornerRadius: config.cornerRadius))
  }
}

struct TextBoxConfig {
  enum Style {
    case h1, h2, h3, h4, h5, subtitle1, subtitle2, body1, body2, small1, small2, small3, small4, button1, button2, button3
  }
  
  let placeholder: String
  let icon: String?
  let type: TextBoxTypes
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
  
  init(
    placeholder: String,
    icon: String? = nil,
    type: TextBoxTypes,
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
    cornerRadius: CGFloat = .radius3
  ) {
    self.placeholder = placeholder
    self.icon = icon
    self.type = type
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
  }
}

#Preview {
  @Previewable @State var username = ""
  @Previewable @State var password = ""
  @Previewable @State var sisiMomName = ""
  VStack(spacing: 16) {
    TextBox(config: TextBoxConfig(
      placeholder: "Username",
      icon: "person",
      type: .normal,
      text: $username,
      width: 300,
      height: 60,
      font: .body1,
      strokeColor: .textSecondaryDark
    ))
    
    TextBox(config: TextBoxConfig(
      placeholder: "Password",
      icon: "lock",
      type: .secure,
      text: $password,
      width: 365,
      height: 60,
      font: .body1,
      strokeColor: .textSecondaryDark
    ))
    
    TextBox(config: TextBoxConfig(
      placeholder: "Enter sisi's mom name",
      type: .normal,
      text: $sisiMomName,
      width: 300,
      height: 60,
      font: .body1,
      strokeColor: .textSecondaryDark
    ))
  }
}
