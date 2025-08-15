import SwiftUI

struct AuthView<ViewModel: AuthViewModel>: View {
  @StateObject private var viewModel: ViewModel
  
  @State private var email: String = ""
  @State private var password: String = ""
  @State private var showValidation: Bool = false
  
  @FocusState private var isEmailFocused: Bool
  @FocusState private var isPasswordFocused: Bool
  
  init(viewModel: @autoclosure @escaping () -> ViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel())
  }
  
  var body: some View {
    VStack(spacing: .spacer7) {
      title
      textBoxesForSignIn
      emailSignInButton
      divider
      googleSignInButton
      signUpNavigator
    }
  }
}

extension AuthView {
  private var title: some View {
    HStack {
      Label("Sign In")
        .font(.h2)
      Spacer()
    }
    .padding(.horizontal, 20)
  }
  
  private var textBoxesForSignIn: some View {
    VStack(spacing: .spacer7) {
      TextBox(config: TextBoxConfig(
        placeholder: "Email Sign In",
        icon: "envelope",
        type: .normal,
        useInSignIn: true,
        text: $email,
        width: 365,
        height: 60,
        font: .body1,
        strokeColor: .textSecondaryDark,
        validationMessage: viewModel.error,
        validationColor: .red,
        showValidation: showValidation
      ), isFocused: $isEmailFocused)
      
      TextBox(config: TextBoxConfig(
        placeholder: "Password Sign In",
        icon: "lock",
        type: .secure,
        text: $password,
        width: 365,
        height: 60,
        font: .body1,
        strokeColor: .textSecondaryDark,
        validationMessage: viewModel.error,
        showValidation: showValidation
      ), isFocused: $isPasswordFocused)
    }
  }
  
  private var emailSignInButton: some View {
    AppButton(config: ButtonConfig(
        type: .primary,
        title: "SIGN IN",
        icon: "arrow.right",
        iconPosition: .right,
        width: 300,
        height: 50,
        backgroundColor: .accent,
        action: {
          let dto = EmailSignInDto(email: email, password: password)
          Task {
            await viewModel.signIn(.emailPassword(dto: dto))
          }
        }))
  }
  
  private var divider: some View {
    HStack(alignment: .center) {
      Label("OR")
        .color(.textSecondaryDark)
    }
  }
  
  private var googleSignInButton: some View {
    AppButton(config: ButtonConfig(
      type: .primary,
      title: "Login with Google",
      fontStyle: .body1,
      icon: "GoogleIconLight",
      iconPosition: .left,
      width: 300,
      height: 50,
      backgroundColor: .textWhite,
      foregroundColor: .textPrimaryDark,
      action: {
        Task {
          await viewModel.signIn(.google)
        }
      }
    ))
  }
  
  private var signUpNavigator: some View {
    HStack(spacing: 0) {
      Label("Don't have an account?")
        .font(.small1)
      AppButton(config: ButtonConfig(
        type: .link,
        title: "Sign Up",
        fontStyle: .small1,
        horizontalPadding: .spacer2,
        foregroundColor: .accent,
        action: {
          print("Sign Up Clicked")
        }
      ))
    }
  }
}


#Preview {
  AuthView(viewModel: AuthViewModelImpl(authRepository: AuthRepositoryImpl(googleOAuthService: GoogleOAuthServiceImpl())))
}
