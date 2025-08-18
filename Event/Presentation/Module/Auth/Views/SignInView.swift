import SwiftUI

struct SignInView<ViewModel: AuthViewModel>: View {
  

  @ObservedObject private var viewModel: ViewModel
  @State private var email: String = ""
  @State private var password: String = ""
  @State private var showValidation: Bool = false
  @State private var isDiabled: Bool = false
  @FocusState private var isEmailFocused: Bool
  @FocusState private var isPasswordFocused: Bool
  
  let navigator: AuthNavigator
  
  init(viewModel: @autoclosure @escaping () -> ViewModel, navigator: AuthNavigator) {
    _viewModel = ObservedObject(wrappedValue: viewModel())
    self.navigator = navigator
  }
  
  var body: some View {
    ZStack {
      Color.clear
        .contentShape(Rectangle())
        .onTapGesture {
          isEmailFocused = false
          isPasswordFocused = false
        }
      
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
}



extension SignInView {
  private var title: some View {
    AuthLabel(title: "SIGN IN")
  }
  
  private var textBoxesForSignIn: some View {
    AuthTextBoxes(config: AuthTextBoxesConfig(
      isEmailFocused: $isEmailFocused,
      isPasswordFocused: $isPasswordFocused,
      useInSignIn: true,
      email: $viewModel.signInemail,
      password: $viewModel.signInPassword,
      validationMessage: viewModel.error,
      showValidation: showValidation
    ))
    .onChange(of: viewModel.error) { _, newErrorValue in
      showValidation = newErrorValue != nil && !newErrorValue!.isEmpty
    }
  }
  
  private var emailSignInButton: some View {
    EmailAuthButton(
      useInSignIn: true,
      isDisabled: isDiabled,
      action: {
        let dto = EmailSignInDto(email: viewModel.signInemail, password: viewModel.signInPassword)
        Task {
          await viewModel.signIn(.emailPassword(dto: dto))
        }
      }
    )
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
      }
    )
  }
  
  private var signUpNavigator: some View {
    AuthNavigatorButton(
      useInSignIn: true,
      action: {
        navigator.push(.signUp)
      }
    )
  }
}


#Preview {
  SignInView(viewModel: AuthViewModelImpl(authRepository: AuthRepositoryImpl(googleOAuthService: GoogleOAuthServiceImpl())), navigator: PreviewAuthNavigator())
}
