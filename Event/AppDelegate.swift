import Foundation
import GoogleSignIn

class AppDelegate: NSObject, UIApplicationDelegate {
    
    //MARK: - Initializing (App Configuration)
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        return true
    }
    
    //MARK: - Handle the URL that application receives at the end of the authentication process
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}
