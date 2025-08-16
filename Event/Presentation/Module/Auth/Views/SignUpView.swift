import SwiftUI
import Navio

struct SignUpView<ViewModel: AuthViewModel>: View {
  
  @StateObject private var viewModel: ViewModel
  @FocusState private var isFullNameFoucsed: Bool
  @FocusState private var isEmailFocused: Bool
  @FocusState private var isPasswordFocused: Bool
  @FocusState private var isConfirmPasswordFocused: Bool
  @State private var fullName: String = ""
  @State private var email: String = ""
  @State private var password: String = ""
  @State private var isDisabled: Bool = false
  @State private var confirmPassword: String = ""
  @State private var showValidation: Bool = false
  
  let navigator: AuthNavigator
  
  init(viewModel: @autoclosure @escaping () -> ViewModel, navigator: AuthNavigator) {
    _viewModel = StateObject(wrappedValue: viewModel())
    self.navigator = navigator
  }
  
  var body: some View {
    ZStack {
      Color.clear
        .contentShape(Rectangle())
        .onTapGesture {
          isFullNameFoucsed = false
          isEmailFocused = false
          isPasswordFocused = false
          isConfirmPasswordFocused = false
        }
      VStack(spacing: .spacer7) {
        title
        textBoxesForSignUp
        emailSignUpButton
        divider
        googleSignInButton
        signInNavigator
      }
    }
  }
}

extension SignUpView {
  private var title: some View {
    AuthLabel(title: "SIGN UP")
  }
  
  private var textBoxesForSignUp: some View {
    AuthTextBoxes(config: AuthTextBoxesConfig(
      isEmailFocused: $isEmailFocused,
      isPasswordFocused: $isPasswordFocused,
      isFullNameFocused: $isFullNameFoucsed,
      isConfirmPasswordFocused: $isConfirmPasswordFocused,
      useInSignIn: false,
      email: $email,
      password: $password,
      fullName: $fullName,
      confirmPassword: $confirmPassword,
      validationMessage: viewModel.error,
      showValidation: showValidation
    ))
    .onChange(of: viewModel.error) { _, newErrorValue in
      showValidation = newErrorValue != nil && !newErrorValue!.isEmpty
    }
  }
  
  private var emailSignUpButton: some View {
    EmailAuthButton(
      useInSignIn: false,
      isDisabled: isDisabled,
      action: {
        // API call here
      })
  }
  
  private var divider: some View {
    HStack(alignment: .center) {
      Label("OR")
        .color(.textSecondaryDark)
    }
    .padding(.vertical, .spacer4)
  }
  
  private var googleSignInButton: some View {
    GoogleAuthButton(
      action: {
        Task {
          await viewModel.signIn(.google)
        }
      })
  }
  
  private var signInNavigator: some View {
    AuthNavigatorButton(
      useInSignIn: false,
      action: {
        navigator.pop()
      })
  }
}

#Preview {
  SignUpView(viewModel: AuthViewModelImpl(authRepository: AuthRepositoryImpl(googleOAuthService: GoogleOAuthServiceImpl())), navigator: PreviewAuthNavigator())
}
