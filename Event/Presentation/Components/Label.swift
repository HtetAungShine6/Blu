import SwiftUI

struct Label: View {
  
  private var text: String
  private var font: Style = .body1
  private var color: Color = AppTheme.AppColor.TextColor.primaryDark
  private var maxLines: Int? = 0
  private var alignment: TextAlignment? = .center
  
  public init(_ text: String) {
    self.text = text
  }
  
  var body: some View {
    Text(text)
      .font(textStyle)
      .foregroundStyle(color)
      .lineLimit(maxLines ?? nil)
      .multilineTextAlignment(alignment ?? .leading)
    
  }
  
  enum Style {
    case h1, h2, h3, h4, h5, subtitle1, subtitle2, body1, body2, small1, small2, small3, small4, button1, button2, button3
  }
  
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



extension Label {
  
  public func font(_ style: Style) -> Label {
    var copy = self
    copy.font = style
    return copy
  }
  
  public func color(_ color: Color) -> Label {
    var copy = self
    copy.color = color
    return copy
  }
  
  public func maxLines(_ maxLines: Int? = 0) -> Label {
    var copy = self
    copy.maxLines = maxLines
    return copy
  }
  
  public func alignment(_ alignment: TextAlignment? = .leading) -> Label {
    var copy = self
    copy.alignment = alignment
    return copy
  }
  
  
}
