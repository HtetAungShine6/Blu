import SwiftUI

struct OTPVerificationView<ViewModel: AuthViewModel>: View {
  
  @StateObject private var viewModel: ViewModel
  @FocusState private var isFocused: Bool
  @State private var otp = Array(repeating: "", count: 4)
  @State private var shouldRestartTimer: Bool = false
  @State private var isTimerActive: Bool = true
  private var email: String = ""
  private let totalSeconds: Int = 300
  
  init(viewModel: @autoclosure @escaping () -> ViewModel, email: String) {
    _viewModel = StateObject(wrappedValue: viewModel())
    self.email = email
  }
  
  var body: some View {
    VStack(spacing: .spacer10) {
      title
      OTPBoxes(otp: $otp, isFocused: $isFocused)
      TimerView(
        totalSeconds: totalSeconds,
        countdownStart: true,
        restartTimer: $shouldRestartTimer
      ) {
        isTimerActive = false
      }
      otpVerificationButton
    }
  }
}

extension OTPVerificationView {
  private var title: some View {
    VStack(alignment: .leading, spacing: .spacer0) {
      HStack {
        Label("OTP Verification")
          .font(.h2)
        Spacer()
      }
      subtitle
    }
    .padding(.horizontal, 20)
  }
  
  private var subtitle: some View {
    Label("Please enter the 4 digits otp that we have sent to \(email)")
      .font(.subtitle2)
      .maxLines(2)
      .alignment(.leading)
  }
  
  private var otpVerificationButton: some View {
    AppButton(config: ButtonConfig(
      type: .primary,
      isDisabled: false,
      title: isTimerActive ? "VERIFY" : "RESEND",
      fontStyle: .button1,
      icon: "arrow.right",
      iconPosition: .right,
      width: 275,
      height: 50,
      backgroundColor: .accent,
      foregroundColor: .white,
      action: {
        // implementation of OTP confirmation
        
        performOTP()
      }
    ))
  }
  
  private func performOTP() {
    if isTimerActive {
      verifyOTP()
    } else {
      resendOTP()
    }
  }
  
  private func verifyOTP() {
    print("Verified OTP with \(otp)")
  }
  
  private func resendOTP() {
    otp = Array(repeating: "", count: 4)
    shouldRestartTimer = true
    isTimerActive = true
  }
}


#Preview {
  OTPVerificationView(viewModel: AuthViewModelImpl(authRepository: AuthRepositoryImpl(googleOAuthService: GoogleOAuthServiceImpl())), email: "kokoshine@gmail.com")
}
