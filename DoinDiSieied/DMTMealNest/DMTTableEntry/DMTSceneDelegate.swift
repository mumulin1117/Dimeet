import UIKit

final class DMTSceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private var hearthCoordinator: DMTAppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        let coordinator = DMTAppCoordinator(launchWindow: window)
        self.window = window
        hearthCoordinator = coordinator
        coordinator.plateLaunch()
    }
}
