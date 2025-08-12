import SwiftUI

struct AuthView<ViewModel: AuthViewModel>: View {
  @StateObject private var authViewModel: ViewModel
  
  init(authViewModel: @autoclosure @escaping () -> ViewModel) {
    _authViewModel = StateObject(wrappedValue: authViewModel())
  }
  
  var body: some View {
    VStack {
      if authViewModel.isLoading {
        ProgressView("Signing in...")
      }
      
      Button("Google Sign In") {
        Task {
          await authViewModel.signIn(.google)
        }
      }
    }
  }
}



