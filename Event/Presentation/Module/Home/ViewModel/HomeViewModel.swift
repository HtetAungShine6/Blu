import Foundation

@MainActor
protocol HomeViewModel: ObservableObject {
  func signOut()
}

final class HomeViewModelImpl: HomeViewModel {
  private let authViewModel: any AuthViewModel
  
  init(authViewModel: any AuthViewModel) {
    self.authViewModel = authViewModel
  }
  
  func signOut() {
    authViewModel.signOut()
  }
  
}
