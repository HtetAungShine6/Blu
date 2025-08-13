import SwiftUI

struct Feedback {
  static func light() {
    let impactFeedback = UIImpactFeedbackGenerator(style: .light)
    impactFeedback.impactOccurred()
  }
  
  static func rigid() {
    let impactFeedback = UIImpactFeedbackGenerator(style: .rigid)
    impactFeedback.impactOccurred()
  }
}
