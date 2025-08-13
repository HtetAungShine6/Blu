import UIKit

enum HapticType {
  case light
  case medium
  case heavy
  case rigid
  case success
  case warning
  case error
}

enum HapticPlayer {
  static func play(_ type: HapticType) {
    switch type {
    case .light:
      UIImpactFeedbackGenerator(style: .light).impactOccurred()
    case .medium:
      UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    case .heavy:
      UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
    case .rigid:
      UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
    case .success:
      UINotificationFeedbackGenerator().notificationOccurred(.success)
    case .warning:
      UINotificationFeedbackGenerator().notificationOccurred(.warning)
    case .error:
      UINotificationFeedbackGenerator().notificationOccurred(.error)
    }
  }
}

