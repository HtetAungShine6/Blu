import SwiftUI

@main
struct EventApp: App {
  
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  @AppStorage("appState") var isSignIn = false
  
  var body: some Scene {
    WindowGroup {
      if !isSignIn {
        //AuthView(authViewModel: AuthViewModelImpl(authRepository: AuthRepositoryImpl(googleOAuthService: GoogleOAuthServiceImpl())))
        OnboardingView()
      } else {
        RootView()
      }
    }
  }
}
