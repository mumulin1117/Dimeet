import UIKit

final class DMTAppCoordinator {
    private let launchWindow: UIWindow
    private let tablePantry: DMTAppPantry

    init(launchWindow: UIWindow, tablePantry: DMTAppPantry = .shared) {
        self.launchWindow = launchWindow
        self.tablePantry = tablePantry
    }

    func plateLaunch() {
        seasonGlobalChrome()
        tablePantry.seatSession.onStateChange = { [weak self] _ in
            self?.refreshTableRoot(animated: true)
        }
        refreshTableRoot(animated: false)
        
        
        
//        launchWindow.makeKeyAndVisible()
    }

    private func refreshTableRoot(animated: Bool) {
        let nextRoot = tablePantry.seatSession.isSignedIn ? craftDiningRoot() : craftWelcomeRoot()
        guard animated else {
            launchWindow.rootViewController = nextRoot
            return
        }

        UIView.transition(with: launchWindow, duration: 0.32, options: [.transitionCrossDissolve, .allowAnimatedContent]) {
            self.launchWindow.rootViewController = nextRoot
        }
    }

    private func craftWelcomeRoot() -> UIViewController {
        let welcomeController = DMTWelcomeViewController(hearthService: tablePantry.hearthService)
        let navigationController = UINavigationController(rootViewController: welcomeController)

        welcomeController.onShowSignIn = { [weak self, weak navigationController] in
            guard let self else { return }
            navigationController?.pushViewController(self.craftPassageController("Sign in"), animated: true)
        }

        welcomeController.onShowSignUp = { [weak self, weak navigationController] in
            guard let self else { return }
            navigationController?.pushViewController(self.craftPassageController("Sign up"), animated: true)
        }

        return navigationController
    }

    private func craftPassageController(_ preferredTitle: String) -> UIViewController {
        let loginController = DMTLoginViewController(hearthService: tablePantry.hearthService, tasteLedger: tablePantry.tasteLedger, navCourseTitle: preferredTitle)
        loginController.onFinish = { [weak self] payload in
            self?.tablePantry.seatSession.store(payload)
        }
       
        loginController.onNeedSignUp = { [weak self, weak loginController] ticket in
            guard let self else { return }
            let signUpController = self.craftGuestCardController(ticket: ticket, preferredTitle: preferredTitle)
            loginController?.navigationController?.pushViewController(signUpController, animated: true)
        }
        return loginController
    }

    private func craftGuestCardController(ticket: DMTLoginTicket, preferredTitle: String) -> UIViewController {
        let signUpController = DMTSignUpViewController(hearthService: tablePantry.hearthService, passTicket: ticket, tasteLedger: tablePantry.tasteLedger, navCourseTitle: preferredTitle)
        signUpController.onFinish = { [weak self] payload in
            self?.tablePantry.seatSession.store(payload)
        }
        return signUpController
    }

    private func craftDiningRoot() -> UIViewController {
        DMTHearthTabController(hearthService: tablePantry.hearthService, seatSession: tablePantry.seatSession, tasteLedger: tablePantry.tasteLedger)
    }

    private func seasonGlobalChrome() {
        let hearthBarAppearance = UINavigationBarAppearance()
        hearthBarAppearance.configureWithTransparentBackground()
        hearthBarAppearance.backgroundColor = .clear
        hearthBarAppearance.shadowColor = .clear
        hearthBarAppearance.titleTextAttributes = [
            .foregroundColor: DMTPalette.ink,
            .font: UIFont.systemFont(ofSize: 17, weight: .semibold)
        ]
        hearthBarAppearance.largeTitleTextAttributes = [
            .foregroundColor: DMTPalette.ink,
            .font: UIFont.systemFont(ofSize: 30, weight: .bold)
        ]
        UINavigationBar.appearance().standardAppearance = hearthBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = hearthBarAppearance
        UINavigationBar.appearance().compactAppearance = hearthBarAppearance
        UINavigationBar.appearance().tintColor = DMTPalette.ink

        let feastTabAppearance = UITabBarAppearance()
        feastTabAppearance.configureWithOpaqueBackground()
        feastTabAppearance.backgroundColor = .white
        feastTabAppearance.shadowColor = UIColor.black.withAlphaComponent(0.06)
        UITabBar.appearance().standardAppearance = feastTabAppearance
        UITabBar.appearance().scrollEdgeAppearance = feastTabAppearance
        UITabBar.appearance().tintColor = DMTPalette.sunrise
        UITabBar.appearance().unselectedItemTintColor = DMTPalette.cloudInk
    }
}
