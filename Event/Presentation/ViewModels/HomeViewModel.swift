import Foundation

@MainActor
protocol HomeViewModel: ObservableObject {
    func signOut(_ method: AuthMethods)
}

final class HomeViewModelImpl: HomeViewModel {
    private let authViewModel: any AuthViewModel
    
    init(authViewModel: any AuthViewModel) {
        self.authViewModel = authViewModel
    }
    
    func signOut(_ method: AuthMethods) {
        switch method {
        case .google:
            authViewModel.signOut(.google)
        case .emailPassword:
            authViewModel.signOut(.emailPassword)
        }
    }
}
