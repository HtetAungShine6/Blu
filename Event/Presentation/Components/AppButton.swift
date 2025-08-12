import SwiftUI

enum ButtonTypes {
  case primary
  case secondary
  case tertiary
}

struct AppButton: View {
  var config: ButtonConfig
  
  var body: some View {
    Button(action: config.action) {
      HStack {
        if config.type == .secondary {
          if let icon = config.icon {
            Image(systemName: icon)
          }
          Text(config.title)
            .font(config.textStyle)
        }
        
        if config.type == .primary {
          Spacer()
          Text(config.title)
            .font(config.textStyle)
          Spacer()
          if let icon = config.icon {
            Image(systemName: icon)
              .padding(6)
              .background(
                Circle()
                  .fill(Color.white.opacity(0.2))
              )
          }
        }
        
        if config.type == .tertiary {
          Text(config.title)
            .font(config.textStyle)
          if let icon = config.icon {
            Image(systemName: icon)
          }
        }
      }
      .padding(.horizontal, config.horizontalPadding)
      .padding(.vertical, config.verticalPadding)
      .frame(width: config.width, height: config.height)
      .background(config.type == .primary ? config.backgroundColor : Color.clear)
      .foregroundColor(config.type == .primary ? config.foregroundColor :
                        config.type == .secondary ? config.strokeColor : config.foregroundColor)
      .overlay(
        Group {
          if config.type == .secondary {
            RoundedRectangle(cornerRadius: config.cornerRadius)
              .stroke(config.strokeColor, lineWidth: config.strokeWidth)
          }
        }
      )
      .clipShape(RoundedRectangle(cornerRadius: config.cornerRadius))
    }
  }
}




struct ButtonConfig {
  enum Style {
    case h1, h2, h3, h4, h5, subtitle1, subtitle2, body1, body2, small1, small2, small3, small4, button1, button2, button3
  }
  
  let title: String
  let icon: String?
  let type: ButtonTypes
  let action: () -> Void
  var width: CGFloat? = nil
  var height: CGFloat? = nil
  var horizontalPadding: CGFloat
  var verticalPadding: CGFloat
  var fontSize: Style
  var backgroundColor: Color = .blue
  var foregroundColor: Color = .white
  var strokeColor: Color = .blue
  var strokeWidth: CGFloat
  var cornerRadius: CGFloat
  
  var textStyle: Font {
    switch fontSize {
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
    title: String,
    icon: String? = nil,
    type: ButtonTypes,
    width: CGFloat? = nil,
    height: CGFloat? = nil,
    horizontalPadding: CGFloat = 16,
    verticalPadding: CGFloat = 10,
    fontSize: Style,
    backgroundColor: Color = .blue,
    foregroundColor: Color = .white,
    strokeColor: Color = .blue,
    strokeWidth: CGFloat = 2,
    cornerRadius: CGFloat = .radius3,
    action: @escaping () -> Void
  ) {
    self.title = title
    self.icon = icon
    self.type = type
    self.width = width
    self.height = height
    self.horizontalPadding = horizontalPadding
    self.verticalPadding = verticalPadding
    self.fontSize = fontSize
    self.backgroundColor = backgroundColor
    self.foregroundColor = foregroundColor
    self.strokeColor = strokeColor
    self.strokeWidth = strokeWidth
    self.cornerRadius = cornerRadius
    self.action = action
  }
}

#Preview {
  VStack {
    AppButton(config: ButtonConfig(
      title: "Sign In",
      icon: "arrow.right",
      type: .primary,
      width: 300,
      height: 50,
      fontSize: .button1,
      backgroundColor: .accent,
      action: {
        print("Sign In Tapped")
      }))
    
    AppButton(config: ButtonConfig(
      title: "Apply",
      type: .primary,
      width: 250,
      height: 50,
      fontSize: .button1,
      backgroundColor: .accent,
      action: {
        print("Apply Tapped")
      }))
    
    AppButton(config: ButtonConfig(
      title: "Edit Profile",
      icon: "square.and.pencil",
      type: .secondary,
      width: 200,
      height: 50,
      fontSize: .button1,
      strokeColor: .accent,
      action: {
        print("Edit Profile Tapped")
      }))
    
    AppButton(config: ButtonConfig(
      title: "Reset",
      type: .secondary,
      width: 150,
      height: 50,
      fontSize: .button1,
      strokeColor: .textPrimaryDark,
      action: {
        print("Reset Tapped")
      }))
    
    AppButton(config: ButtonConfig(
      title: "Sign Up",
      type: .tertiary,
      fontSize: .button1,
      foregroundColor: .accent,
      action: {
        print("Sign up Tapped")
      }))
    
    AppButton(config: ButtonConfig(
      title: "View All",
      icon: "chevron.right",
      type: .tertiary,
      fontSize: .button1,
      foregroundColor: .textSecondaryDark,
      action: {
        print("Sign up Tapped")
      }))
  }
}
