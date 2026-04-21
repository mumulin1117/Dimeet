import UIKit

final class DMTAppCoordinator {
    private let window: UIWindow
    private let pantry: DMTAppPantry

    init(window: UIWindow, pantry: DMTAppPantry = .shared) {
        self.window = window
        self.pantry = pantry
    }

    func start() {
        applyTasteAppearance()
        pantry.sessionStore.onStateChange = { [weak self] _ in
            self?.swapRoot(animated: true)
        }
        swapRoot(animated: false)
        window.makeKeyAndVisible()
    }

    private func swapRoot(animated: Bool) {
        let nextRoot = pantry.sessionStore.isSignedIn ? makeMainRoot() : makeAuthRoot()
        guard animated else {
            window.rootViewController = nextRoot
            return
        }

        UIView.transition(with: window, duration: 0.32, options: [.transitionCrossDissolve, .allowAnimatedContent]) {
            self.window.rootViewController = nextRoot
        }
    }

    private func makeAuthRoot() -> UIViewController {
        let welcomeController = DMTWelcomeViewController(service: pantry.feastService)
        let navigationController = UINavigationController(rootViewController: welcomeController)

        welcomeController.onShowSignIn = { [weak self, weak navigationController] in
            guard let self else { return }
            navigationController?.pushViewController(self.makeLoginController("Sign in"), animated: true)
        }

        welcomeController.onShowSignUp = { [weak self, weak navigationController] in
            guard let self else { return }
            navigationController?.pushViewController(self.makeLoginController("Sign up"), animated: true)
        }

        welcomeController.onShowAgreement = { [weak self, weak navigationController] in
            guard let self else { return }
            let agreementController = self.makeAgreementController()
            navigationController?.present(agreementController, animated: true)
        }

        return navigationController
    }

    private func makeAgreementController() -> UIViewController {
        let agreementController = DMTEulaViewController(service: pantry.feastService)
        agreementController.modalPresentationStyle = .overFullScreen
        return agreementController
    }

    private func makeLoginController(_ preferredTitle: String) -> UIViewController {
        let loginController = DMTLoginViewController(service: pantry.feastService, profileStore: pantry.profileStore, preferredTitle: preferredTitle)
        loginController.onFinish = { [weak self] payload in
            self?.pantry.sessionStore.store(payload)
        }
       
        loginController.onNeedSignUp = { [weak self, weak loginController] ticket in
            guard let self else { return }
            let signUpController = self.makeSignUpController(ticket: ticket, preferredTitle: preferredTitle)
            loginController?.navigationController?.pushViewController(signUpController, animated: true)
        }
        return loginController
    }

    private func makeSignUpController(ticket: DMTLoginTicket, preferredTitle: String) -> UIViewController {
        let signUpController = DMTSignUpViewController(service: pantry.feastService, ticket: ticket, profileStore: pantry.profileStore, preferredTitle: preferredTitle)
        signUpController.onFinish = { [weak self] payload in
            self?.pantry.sessionStore.store(payload)
        }
        return signUpController
    }

    private func makeMainRoot() -> UIViewController {
        DMTHearthTabController(service: pantry.feastService, sessionStore: pantry.sessionStore, profileStore: pantry.profileStore)
    }

    private func applyTasteAppearance() {
        let navigationAppearance = UINavigationBarAppearance()
        navigationAppearance.configureWithTransparentBackground()
        navigationAppearance.backgroundColor = .clear
        navigationAppearance.shadowColor = .clear
        navigationAppearance.titleTextAttributes = [
            .foregroundColor: DMTPalette.ink,
            .font: UIFont.systemFont(ofSize: 17, weight: .semibold)
        ]
        navigationAppearance.largeTitleTextAttributes = [
            .foregroundColor: DMTPalette.ink,
            .font: UIFont.systemFont(ofSize: 30, weight: .bold)
        ]
        UINavigationBar.appearance().standardAppearance = navigationAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationAppearance
        UINavigationBar.appearance().compactAppearance = navigationAppearance
        UINavigationBar.appearance().tintColor = DMTPalette.ink

        let tabAppearance = UITabBarAppearance()
        tabAppearance.configureWithOpaqueBackground()
        tabAppearance.backgroundColor = .white
        tabAppearance.shadowColor = UIColor.black.withAlphaComponent(0.06)
        UITabBar.appearance().standardAppearance = tabAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabAppearance
        UITabBar.appearance().tintColor = DMTPalette.sunrise
        UITabBar.appearance().unselectedItemTintColor = DMTPalette.cloudInk
    }
}
