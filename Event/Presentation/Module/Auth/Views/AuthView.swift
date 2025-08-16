import SwiftUI
import Navio

struct AuthView<ViewModel: AuthViewModel>: View {
  
  @StateObject private var viewModel: ViewModel
  @Navio<AuthRoute> private var authNavigator
  
  init(viewModel: @autoclosure @escaping () -> ViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel())
  }
  
  var body: some View {
    NavioView(authNavigator) {
      SignInView(viewModel: viewModel, navigator: authNavigator)
    } route: { route in
      switch route {
      case .signUp:
        SignUpView(viewModel: viewModel, navigator: authNavigator)
      }
    }
  }
}
