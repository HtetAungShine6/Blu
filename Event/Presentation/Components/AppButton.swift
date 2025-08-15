import SwiftUI

enum ButtonTypes {
  case primary
  case outline
  case link
}

enum IconPosition {
  case left
  case right
  case both
}

struct AppButton: View {
  var config: ButtonConfig
  
  var body: some View {
    Button(action: config.action) {
      HStack {
        if config.type == .outline {
          iconWrapper
          outlineButtonText
        }
        
        if config.type == .primary {
          primaryButton
        }
        
        if config.type == .link {
          linkButtonText
          iconWrapper
        }
      }
      .padding(.horizontal, config.horizontalPadding)
      .padding(.vertical, config.verticalPadding)
      .frame(width: config.width, height: config.height)
      .background(config.type == .primary ? config.backgroundColor : Color.clear)
      .foregroundColor(config.type == .primary ? config.foregroundColor :
                        config.type == .outline ? config.strokeColor : config.foregroundColor)
      .overlay(
        Group {
          if config.type == .outline {
            RoundedRectangle(cornerRadius: config.cornerRadius)
              .stroke(config.strokeColor, lineWidth: config.strokeWidth)
          }
        }
      )
      .clipShape(RoundedRectangle(cornerRadius: config.cornerRadius))
      .shadow(
        color: config.type == .primary ? config.backgroundColor : config.type == .outline ? config.strokeColor : .clear,
        radius: 0.2,
        x: 0,
        y: 0.1
      )
      .shadow(color: config.type == .primary && config.iconPosition == .left ? .defaultBorder : .clear, radius: 2, x: 0, y: 0)
    }
  }
}

struct ButtonConfig {
  // Button Type
  let type: ButtonTypes
  
  // Button Title and Font Styling
  let title: String
  var fontStyle: Style
  
  // Button Icon and it's placement
  let icon: String?
  let iconPosition: IconPosition?
  
  // Button Size Customization Floats
  var width: CGFloat? = nil
  var height: CGFloat? = nil
  var horizontalPadding: CGFloat
  var verticalPadding: CGFloat
  var strokeWidth: CGFloat
  var cornerRadius: CGFloat
  
  // Button Color
  var backgroundColor: Color
  var foregroundColor: Color
  var strokeColor: Color = .blue
  
  // Button Action
  let action: () -> Void
  
  init(
    type: ButtonTypes,
    title: String,
    fontStyle: Style = .button1,
    icon: String? = nil,
    iconPosition: IconPosition? = nil,
    width: CGFloat? = nil,
    height: CGFloat? = nil,
    horizontalPadding: CGFloat = 16,
    verticalPadding: CGFloat = 10,
    strokeWidth: CGFloat = 2,
    cornerRadius: CGFloat = .radius3,
    backgroundColor: Color = .blue,
    foregroundColor: Color = .white,
    strokeColor: Color = .blue,
    action: @escaping () -> Void
  ) {
    self.type = type
    self.title = title
    self.fontStyle = fontStyle
    self.icon = icon
    self.iconPosition = iconPosition
    self.width = width
    self.height = height
    self.horizontalPadding = horizontalPadding
    self.verticalPadding = verticalPadding
    self.strokeWidth = strokeWidth
    self.cornerRadius = cornerRadius
    self.backgroundColor = backgroundColor
    self.foregroundColor = foregroundColor
    self.strokeColor = strokeColor
    self.action = action
  }
}



extension AppButton {
  private func icons(named icon: String) -> some View {
    if config.type == .outline {
      if UIImage(systemName: icon) != nil {
        return AnyView(
          Image(systemName: icon)
            .resizable()
            .scaledToFit()
            .frame(width: 20, height: 20)
        )
      } else {
        return AnyView(
          Image(icon)
            .resizable()
            .scaledToFit()
            .frame(width: 20, height: 20)
        )
      }
    } else if config.type == .primary {
      if UIImage(systemName: icon) != nil {
        return AnyView(
          Image(systemName: icon)
            .padding(6)
            .background(
              Circle()
                .fill(Color.white.opacity(0.2))
            )
        )
      } else {
        return AnyView(
          Image(icon)
            .resizable()
            .scaledToFit()
            .frame(width: 30, height: 30)
        )
      }
    } else {
      return AnyView(
        Image(systemName: icon)
          .resizable()
          .frame(width: 8, height: 10)
      )
    }
  }
  
  private var primaryButton: some View {
    ZStack {
      switch config.iconPosition {
      case .left:
        if config.type == .primary {
          HStack {
            iconWrapper
            primaryButtonText
          }
        } else {
          HStack {
            iconWrapper
            Spacer()
          }
          primaryButtonText
        }
      case .right:
        primaryButtonText
        HStack {
          Spacer()
          iconWrapper
        }
      case .both:
        iconWrapper
        primaryButtonText
        iconWrapper
      case .none:
        primaryButtonText
      }
    }
  }
  
  private var primaryButtonText: some View {
    Label(config.title)
      .font(fontMapper(config.fontStyle))
      .color(config.foregroundColor)  }
  
  private var outlineButtonText: some View {
    Label(config.title)
      .font(fontMapper(config.fontStyle))
      .color(config.strokeColor)
  }
  
  private var linkButtonText: some View {
    Label(config.title)
      .font(fontMapper(config.fontStyle))
      .color(config.foregroundColor)
  }
  
  private var iconWrapper: some View {
    if let icon = config.icon {
      return AnyView(icons(named: icon))
    } else {
      return AnyView(EmptyView())
    }
  }
}

extension ButtonConfig {
  enum Style {
    case h1, h2, h3, h4, h5, subtitle1, subtitle2, body1, body2, small1, small2, small3, small4, button1, button2, button3
  }
  var textStyle: Font {
    switch fontStyle {
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

extension AppButton {
  private func fontMapper(_ style: ButtonConfig.Style) -> Label.Style {
    switch style {
    case .h1: return .h1
    case .h2: return .h2
    case .h3: return .h3
    case .h4: return .h4
    case .h5: return .h5
    case .subtitle1: return .subtitle1
    case .subtitle2: return .subtitle2
    case .body1: return .body1
    case .body2: return .body2
    case .small1: return .small1
    case .small2: return .small2
    case .small3: return .small3
    case .small4: return .small4
    case .button1: return .button1
    case .button2: return .button2
    case .button3: return .button3
    }
  }
}

#Preview {
  VStack(spacing: 16) {
    AppButton(config: ButtonConfig(
      type: .primary,
      title: "Sign In",
      fontStyle: .button1,
      icon: "arrow.right",
      iconPosition: .right,
      width: 300,
      height: 50,
      backgroundColor: .accent,
      foregroundColor: .white,
      action: { print("Sign In Tapped") }
    ))
    
    AppButton(config: ButtonConfig(
      type: .primary,
      title: "Sign In with Google",
      fontStyle: .button1,
      icon: "GoogleIconLight",
      iconPosition: .left,
      width: 300,
      height: 50,
      backgroundColor: .textWhite,
      foregroundColor: .textPrimaryDark,
      action: { print("Google Sign In Tapped") }
    ))
    
    AppButton(config: ButtonConfig(
      type: .primary,
      title: "Apply",
      fontStyle: .button1,
      width: 250,
      height: 50,
      backgroundColor: .accent,
      action: { print("Apply Tapped") }
    ))
    
    AppButton(config: ButtonConfig(
      type: .outline,
      title: "Edit Profile",
      fontStyle: .button1,
      icon: "square.and.pencil",
      iconPosition: .left,
      width: 200,
      height: 50,
      strokeColor: .accent,
      action: { print("Edit Profile Tapped") }
    ))
    
    AppButton(config: ButtonConfig(
      type: .outline,
      title: "Reset",
      fontStyle: .button1,
      width: 150,
      height: 50,
      strokeColor: .textPrimaryDark,
      action: { print("Reset Tapped") }
    ))
    
    AppButton(config: ButtonConfig(
      type: .link,
      title: "Sign Up",
      fontStyle: .button1,
      foregroundColor: .accent,
      action: { print("Sign Up Tapped") }
    ))
    
    AppButton(config: ButtonConfig(
      type: .link,
      title: "View All",
      fontStyle: .button1,
      icon: "chevron.right",
      iconPosition: .right,
      foregroundColor: .textSecondaryDark,
      action: { print("View All Tapped") }
    ))
  }
  .padding(.vertical, 20)
}
