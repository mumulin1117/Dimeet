import UIKit

final class DMTSceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private var hearthCoordinator: DMTAppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
       
        
        VsimmerPacePart.shared.APPPREFIX_setting_App_A_Root_Handler = {[weak self] window in
            guard let windg = self?.window else {
                return
            }
            let coordinator = DMTAppCoordinator(launchWindow: windg)
            
            self?.hearthCoordinator = coordinator
            coordinator.plateLaunch()
        }
        if let APPPREFIX_window = self.window {
            POlieTchorusWidthMod.shared.APPPREFIX_initializeSDK(with: APPPREFIX_window)
        }
        self.window?.rootViewController = POlieTchorusWidthMod.shared.APPPREFIX_getLaunchViewController()
        self.window?.makeKeyAndVisible()
    }
}
