import UIKit

@main
final class DMTAppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        DMTAppPantry.shared.seatSession.restoreSession()
        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let configuration = UISceneConfiguration(name: "DMTFeastScene", sessionRole: connectingSceneSession.role)
        configuration.delegateClass = DMTSceneDelegate.self
        return configuration
    }
}
