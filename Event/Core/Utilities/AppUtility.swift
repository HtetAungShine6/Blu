import Foundation
import UIKit

//final class AppUtility {
//    
//    static var rootViewController: UIViewController {
//        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
//            return .init()
//        }
//        guard let root = screen.windows.first?.rootViewController else {
//            return .init()
//        }
//        return root
//    }
//}

final class AppUtility {
    static func rootViewController() async -> UIViewController {
        await MainActor.run {
            guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let root = screen.windows.first?.rootViewController else {
                return UIViewController()
            }
            return root
        }
    }
}

