//import SwiftUI
//
//struct TimerView: View {
//  
//  let countdownStart: Bool
//  private let totalSeconds: Int = 60
//
//
//  
//  var body: some View {
//    Text(
//      timerInterval: Date.now...Date(timeInterval: 60, since: .now),
//      pauseTime: nil,
//      countsDown: countdownStart
//    )
//    .font(.largeTitle.monospacedDigit())
//    .foregroundColor(.primary)
//    .underline(true, color: .accent)
//  }
//}

import SwiftUI

struct TimerView: View {
  
  let totalSeconds: Int
  let countdownStart: Bool
  @Binding var restartTimer: Bool
  
  var onTimerComplete: (() -> Void)?
  
  @State private var remainingSeconds: Int
  @State private var timer: Timer? = nil
  
  init(totalSeconds: Int = 60, countdownStart: Bool = true, restartTimer: Binding<Bool>, onTimerComplete: (() -> Void)? = nil) {
    self.totalSeconds = totalSeconds
    self.countdownStart = countdownStart
    self._restartTimer = restartTimer
    self.onTimerComplete = onTimerComplete
    self._remainingSeconds = State(initialValue: totalSeconds)
  }
  
  var body: some View {
    Text(timeString(remainingSeconds))
      .font(.largeTitle.monospacedDigit())
      .foregroundColor(.primary)
      .underline(true, color: .accent)
      .onAppear {
        if countdownStart {
          startTimer()
        }
      }
      .onChange(of: restartTimer) { _, newValue in
        if newValue {
          restartCountdown()
        }
      }
      .onDisappear {
        timer?.invalidate()
      }
  }
  
  // MARK: - Timer logic
  private func startTimer() {
    timer?.invalidate()
    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
      if remainingSeconds > 0 {
        remainingSeconds -= 1
      } else {
        timer?.invalidate()
        onTimerComplete?()
      }
    }
  }
  
  private func restartCountdown() {
    remainingSeconds = totalSeconds
    startTimer()
    restartTimer = false
  }
  
  // MARK: - Formatting
  private func timeString(_ seconds: Int) -> String {
    let minutes = seconds / 60
    let secs = seconds % 60
    return String(format: "%d:%02d", minutes, secs)
  }
}

#Preview {
  @Previewable @State var restartTimer: Bool = false
  TimerView(countdownStart: true, restartTimer: $restartTimer)
}
