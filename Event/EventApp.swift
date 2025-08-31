import SwiftUI
import Navio

@main
struct EventApp: App {
  
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  @AppStorage("appState") var isSignIn = false
  @Navio<AuthRoute> var authNavigator
  
  var body: some Scene {
    WindowGroup {
      if !isSignIn {
        AuthView(viewModel: AuthViewModelImpl(authRepository: AuthRepositoryImpl(googleOAuthService: GoogleOAuthServiceImpl())))
      } else {
        RootView()
      }
    }
  }
}
