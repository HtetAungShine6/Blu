import SwiftUI

enum ButtonTypes {
  case primary
  case secondary
  case tertiary
}

struct ButtonConfig {
  let title: String
  let icon: String?
  let type: ButtonTypes
  let action: () -> Void
  var width: CGFloat? = nil
  var height: CGFloat? = nil
  var horizontalPadding: CGFloat = 16
  var verticalPadding: CGFloat = 10
  var fontSize: CGFloat = 16
  var backgroundColor: Color = .blue
  var foregroundColor: Color = .white
  var strokeColor: Color = .blue
  var strokeWidth: CGFloat = 2
  var cornerRadius: CGFloat = 20
  
  init(
    title: String,
    icon: String? = nil,
    type: ButtonTypes,
    width: CGFloat? = nil,
    height: CGFloat? = nil,
    horizontalPadding: CGFloat = 16,
    verticalPadding: CGFloat = 10,
    fontSize: CGFloat = 16,
    backgroundColor: Color = .blue,
    foregroundColor: Color = .white,
    strokeColor: Color = .blue,
    strokeWidth: CGFloat = 2,
    cornerRadius: CGFloat = 20,
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

struct AppButton: View {
  var config: ButtonConfig
  
  var body: some View {
    Button(action: config.action) {
      HStack {
        if config.type == .secondary, let icon = config.icon {
          Image(systemName: icon)
        }
        Text(config.title)
          .font(.system(size: config.fontSize, weight: .semibold))
        if config.type == .primary, let icon = config.icon {
          Image(systemName: icon)
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

#Preview {
  VStack(spacing: 16) {
    AppButton(config: DefaultButtonConfig(
      title: "Sign In",
      icon: "arrow.right",
      type: .primary,
      width: 200,
      height: 50,
      backgroundColor: .blue,
      foregroundColor: .white
    ) {
      print("Primary tapped")
    })
    
    AppButton(config: DefaultButtonConfig(
      title: "Edit",
      icon: "square.and.pencil",
      type: .secondary,
      width: 200,
      height: 50,
      strokeColor: .red
    ) {
      print("Secondary tapped")
    })
    
    AppButton(config: DefaultButtonConfig(
      title: "Tertiary",
      type: .tertiary,
      foregroundColor: .green
    ) {
      print("Tertiary tapped")
    })
  }
  .padding()
}
