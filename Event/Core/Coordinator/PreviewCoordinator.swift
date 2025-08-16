import Navio
import SwiftUI

final class PreviewAuthNavigator: NavioCoordinating {
    typealias Route = AuthRoute

    @Published var path = NavigationPath()

    func push(_ route: AuthRoute) {
        print("Preview push:", route)
    }

    func pop() {
        print("Preview pop")
    }

    func popToRoot() {
        print("Preview popToRoot")
    }

    func reset() {
        print("Preview reset")
    }
}
