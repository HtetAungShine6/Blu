//import SwiftUI
//
//struct OTPVerificationView: View {
//  @State private var otpText: String = ""
//  @State private var otpInputError: TextFieldValidationError?
//  @FocusState private var isKeyboardShowing: Bool
//  @State private var hasFilledOTP: Bool = false
//  @State private var isOTPCorrect: Bool = true
//  @EnvironmentObject var appCoordinator: AppCoordinatorImpl
//  @State private var isLoading: Bool = false
//  var destination: Screen
//  var body: some View {
//    ZStack {
//      VStack(alignment: .center, spacing: .spacer5) {
//        otpInfo
//        refCode
//        otpField
//        if !isOTPCorrect {
//          errorText
//        }
//        resendButton
//      }
//    }
//    .isLoading($isLoading)
//    .navigationBarBackButtonHidden()
//    .applyToolBar(hasBackButton: true, principleTitle: DOCTOR_PROFILE_TOOLBAR_TITLE)
//  }
//}
//
//extension OTPVerificationView {
//  private var otpInfo: some View {
//    Text(OTP_INFO)
//      .bold()
//      .font(.subheadline)
//      .multilineTextAlignment(.center)
//      .frame(maxWidth: UIScreen.main.bounds.width / 0.5)
//      .foregroundStyle(Color.gray)
//  }
//
//  private var refCode: some View {
//    HStack {
//      Text("Ref code: TH3X")
//        .font(.caption)
//    }
//    .padding(.horizontal, .spacer2)
//    .padding(.vertical, .spacer2)
//    .background {
//      RoundedRectangle(cornerRadius: .radius1)
//        .foregroundStyle(Color.gray.opacity(0.3))
//    }
//  }
//
//  private var otpField: some View {
//    HStack(spacing: .spacer5) {
//      ForEach(0 ..< 6, id: \.self) { index in
//        OTPTextBox(index)
//      }
//    }
//    .background(
//      TextField("", text: $otpText.limit(6))
//        .bold()
//        .font(.largeTitle)
//        .frame(width: 1, height: 1)
//        .opacity(0.00001)
//        .blendMode(.screen)
//        .focused($isKeyboardShowing)
//        .keyboardType(.numberPad)
//        .textContentType(.oneTimeCode)
//        .onChange(of: otpText) { _, inputOTP in
//          if inputOTP.count == 6, inputOTP == "555555" {
//            hasFilledOTP = true
//            isOTPCorrect = true
//            isLoading = true
//            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//              isLoading = false
//              appCoordinator.push(destination)
//            }
//          } else if inputOTP.count == 6 {
//            hasFilledOTP = true
//            isOTPCorrect = false
//            otpInputError = .otpInputError
//          }
//        }
//    )
//    .contentShape(Rectangle())
//    .onTapGesture {
//      isKeyboardShowing.toggle()
//    }
//  }
//
//  private var errorText: some View {
//    Text(otpInputError?.rawValue ?? "")
//      .font(.subheadline)
//      .foregroundStyle(Color.red)
//  }
//
//  private var resendButton: some View {
//    TextButton(buttonTitle: RESEND_OTP_BUTTON_TITLE, hasColor: true, isUnderlined: true) {
//      hasFilledOTP = false
//      isOTPCorrect = true
//      otpText = ""
//      isKeyboardShowing = false
//    }
//  }
//
//  @ViewBuilder
//  func OTPTextBox(_ index: Int) -> some View {
//    ZStack {
//      if otpText.count > index {
//        // find char at index
//        let startIndex = otpText.startIndex
//        let charIndex = otpText.index(startIndex, offsetBy: index)
//        let charToString = String(otpText[charIndex])
//        Text(charToString)
//          .bold()
//          .font(.title2)
//      } else {
//        Text(" ")
//      }
//    }
//    .frame(width: 50, height: 60)
//    .background {
//      let focused = (isKeyboardShowing && otpText.count == index)
//      RoundedRectangle(cornerRadius: .radius2, style: .continuous)
//        .stroke(
//          focused ? .primaryTeal : (isOTPCorrect ? .gray.opacity(0.75) : .red.opacity(0.75)),
//          lineWidth: focused ? 3 : (isOTPCorrect ? 0.5 : 1)
//        )
//        .animation(.linear(duration: 0.2), value: focused)
//    }
//  }
//}
