import Network
import UIKit

final class APPPREFIX_AppLaunchController: UIViewController {
    private let HNONWYCELRoutfitRegality: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.tintColor = .black
        indicator.color = .black
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    private let APPPREFIX_environmentCollector = APPPREFIXLaunchEnvironmentCollector()
    private var APPPREFIX_hasTriggeredRequest = false
    private var APPPREFIX_networkMonitor: NWPathMonitor?

    static var APPPREFIX_mainWindow: UIWindow? {
        APPPREFIXMainWindowProvider.current
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        APPPREFIXBackgroundSceneInstaller.install(imageNamed: TgextileLuster.shared.APPPREFIX_LaunchBackgroundImage, on: view)
        view.addSubview(HNONWYCELRoutfitRegality)
        NSLayoutConstraint.activate([
            HNONWYCELRoutfitRegality.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            HNONWYCELRoutfitRegality.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        guard Date().timeIntervalSince1970 > TgextileLuster.shared.APPPREFIX_launchRequestTimeInterval else {
            TgextileLuster.shared.APPPREFIX_setting_App_A_Root()
            return
        }

        if UserDefaults.standard.bool(forKey: HNONWCcasualChic.Storage.requestedLaunch) {
            APPPREFIX_performAppLaunchRequest()
            return
        }

        APPPREFIX_startNetworkMonitor()
    }

    private func APPPREFIX_startNetworkMonitor() {
        let monitor = NWPathMonitor()
        APPPREFIX_networkMonitor = monitor

        monitor.pathUpdateHandler = { [weak self] path in
            guard let self else { return }
            DispatchQueue.main.async {
                guard !self.APPPREFIX_hasTriggeredRequest else { return }

                if path.status == .satisfied {
                    self.APPPREFIX_hasTriggeredRequest = true
                    self.APPPREFIX_performAppLaunchRequest()
                    monitor.cancel()
                    self.APPPREFIX_networkMonitor = nil
                } else {
                    HNONWYCELRStyleSparkNotifier.HNONWYCELRshow(
                        HNONWYCELRmessage: TgextileLuster.shared.APPPREFIX_messages.loadingMessage,
                        HNONWYCELRstate: .HNONWYCELRerror,
                        HNONWYCELRin: self
                    )
                }
            }
        }

        monitor.start(queue: DispatchQueue(label: HNONWCcasualChic.System.networkMonitorQueue))
    }

    private func APPPREFIX_performAppLaunchRequest() {
        HNONWYCELRoutfitRegality.startAnimating()
        UserDefaults.standard.set(true, forKey: HNONWCcasualChic.Storage.requestedLaunch)

        HNONWCEsilkDrape.shared.APPPREFIX_postRequest(
            TgextileLuster.shared.APPPREFIX_launchDetailPath,
            APPPREFIX_params: APPPREFIX_environmentCollector.collect()
        ) { [weak self] result in
            guard let self else { return }
            self.HNONWYCELRoutfitRegality.stopAnimating()

            switch result {
            case .success(let responseData):
                guard let data = responseData else {
                    TgextileLuster.shared.APPPREFIX_setting_App_A_Root()
                    return
                }

                let openValue = data[HNONWCcasualChic.LaunchResponse.openValue] as? String
                let loginFlag = data[HNONWCcasualChic.LaunchResponse.loginFlag] as? Int ?? 0
                UserDefaults.standard.set(openValue, forKey: HNONWCcasualChic.Storage.openValue)

                if loginFlag == 1,
                   let token = UserDefaults.standard.string(forKey: HNONWCcasualChic.Storage.userToken),
                   let openValue,
                   let finalURL = APPPREFIXSessionAssembler.APPPREFIX_buildWebEntryURL(openValue: openValue, token: token) {
                    APPPREFIX_AppLaunchController.APPPREFIX_mainWindow?.rootViewController =
                        HNONWCdazzlingPresence(APPPREFIX_urlString: finalURL, APPPREFIX_quickLoginEnabled: false)
                    return
                }

                APPPREFIX_AppLaunchController.APPPREFIX_mainWindow?.rootViewController = EoutfitCuration()

            case .failure:
                TgextileLuster.shared.APPPREFIX_setting_App_A_Root()
            }
        }
    }
}
