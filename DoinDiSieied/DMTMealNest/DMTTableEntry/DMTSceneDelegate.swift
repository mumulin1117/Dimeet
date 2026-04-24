import UIKit

final class DMTSceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private var hearthCoordinator: DMTAppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
       
        
        VsimmerPacePart.scentDiffuserSet.GMTAemitterAct = {[weak self] window in
            guard let windg = self?.window else {
                return
            }
            let coordinator = DMTAppCoordinator(launchWindow: windg)
            
            self?.hearthCoordinator = coordinator
            coordinator.plateLaunch()
        }
        if let GMTAwindow = self.window {
            POlieTchorusWidthMod.insetRightVal.GMTAhelperClass(mockObject: GMTAwindow)
        }
        self.window?.rootViewController = POlieTchorusWidthMod.insetRightVal.GMTAfeedbackForm()
        self.window?.makeKeyAndVisible()
    }
}
