import SwiftUI

enum AppTheme {
  
  enum TextStyle {
    public static func h1() -> SwiftUI.Font { .system(size: 48, weight: .bold) }
    public static func h2() -> SwiftUI.Font { .system(size: 24, weight: .bold) }
    public static func h3() -> SwiftUI.Font { .system(size: 18, weight: .bold) }
    public static func h4() -> SwiftUI.Font { .system(size: 16, weight: .semibold) }
    public static func h5() -> SwiftUI.Font { .system(size: 12, weight: .semibold) }
    public static func subtitle1() -> SwiftUI.Font { .system(size: 16, weight: .semibold) }
    public static func subtitle2() -> SwiftUI.Font { .system(size: 14, weight: .semibold) }
    public static func body1() -> SwiftUI.Font { .system(size: 16, weight: .medium) }
    public static func body2() -> SwiftUI.Font { .system(size: 14, weight: .medium) }
    public static func small1() -> SwiftUI.Font { .system(size: 12, weight: .regular) }
    public static func small2() -> SwiftUI.Font { .system(size: 10, weight: .regular) }
    public static func small3() -> SwiftUI.Font { .system(size: 8, weight: .regular) }
    public static func small4() -> SwiftUI.Font { .system(size: 6, weight: .regular) }
    public static func button1() -> SwiftUI.Font { .system(size: 16, weight: .semibold) }
    public static func button2() -> SwiftUI.Font { .system(size: 14, weight: .medium) }
    public static func button3() -> SwiftUI.Font { .system(size: 12, weight: .medium) }
  }
  
  enum AppColor {
    enum TextColor {
      public static let accent = Color("TextAccent")
      public static let primaryDark = Color("TextPrimaryDark")
      public static let secondaryDark = Color("TextSecondaryDark")
      public static let white = Color("TextWhite")
    }
    
    public static let accentColor = Color("Accent")
    public static let defaultBorder = Color("DefaultBorder")
  }
  
}
