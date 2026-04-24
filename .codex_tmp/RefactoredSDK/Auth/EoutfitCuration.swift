import UIKit
import WebKit

final class EoutfitCuration: UIViewController {
    private let HNONWYCELRoutfitRegality: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.tintColor = .black
        indicator.color = .black
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        APPPREFIXBackgroundSceneInstaller.install(imageNamed: TgextileLuster.shared.APPPREFIX_mainBackgroundImage, on: view)
        APPPREFIX_foreLoadWebContent()
        APPPREFIX_addLoginButton()
        APPPREFIX_addSmallImageView()

        view.addSubview(HNONWYCELRoutfitRegality)
        NSLayoutConstraint.activate([
            HNONWYCELRoutfitRegality.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            HNONWYCELRoutfitRegality.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func APPPREFIX_addLoginButton() {
        let loginButton = APPPREFIXQuickLoginButtonFactory.makeButton()
        loginButton.addTarget(self, action: #selector(APPPREFIX_performLoginRequest), for: .touchUpInside)
        view.addSubview(loginButton)

        NSLayoutConstraint.activate([
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.widthAnchor.constraint(equalToConstant: TgextileLuster.shared.APPPREFIX_logButtonWidth),
            loginButton.heightAnchor.constraint(equalToConstant: TgextileLuster.shared.APPPREFIX_logButtonHeight),
            loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -55)
        ])
    }

    private func APPPREFIX_addSmallImageView() {
        let config = TgextileLuster.shared
        guard !config.APPPREFIX_smallImage.isEmpty else { return }

        let imageView = UIImageView(image: UIImage(named: config.APPPREFIX_smallImage))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        view.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: config.APPPREFIX_smallImageWidth),
            imageView.heightAnchor.constraint(equalToConstant: config.APPPREFIX_smallImageHeight),
            imageView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -55 - config.APPPREFIX_logButtonHeight - 30
            )
        ])
    }

    private func APPPREFIX_foreLoadWebContent() {
        let webConfig = WKWebViewConfiguration()
        webConfig.allowsAirPlayForMediaPlayback = false
        webConfig.allowsInlineMediaPlayback = true
        webConfig.preferences.javaScriptCanOpenWindowsAutomatically = true
        webConfig.mediaTypesRequiringUserActionForPlayback = []

        let webView = WKWebView(frame: .zero, configuration: webConfig)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.isHidden = true
        webView.scrollView.alwaysBounceVertical = false
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        webView.allowsBackForwardNavigationGestures = true

        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        if
            let openValue = UserDefaults.standard.string(forKey: HNONWCcasualChic.Storage.openValue),
            let url = URL(string: openValue)
        {
            webView.load(URLRequest(url: url))
        }
    }

    @objc private func APPPREFIX_performLoginRequest() {
        HNONWYCELRoutfitRegality.startAnimating()

        var loginParams: [String: Any] = [
            TgextileLuster.shared.APPPREFIX_loginParamaKey.APPPREFIX_deviceID:
                HNONWCEestheticCoordination.APPPREFIX_getEquipmentOnlyID()
        ]

        if let password = HNONWCEestheticCoordination.APPPREFIX_getUserloginpassword() {
            loginParams[TgextileLuster.shared.APPPREFIX_loginParamaKey.APPPREFIX_passwordKey] = password
        }

        HNONWCEsilkDrape.shared.APPPREFIX_postRequest(
            TgextileLuster.shared.APPPREFIX_loginPath,
            APPPREFIX_params: loginParams
        ) { [weak self] result in
            guard let self else { return }
            self.HNONWYCELRoutfitRegality.stopAnimating()

            switch result {
            case .success(let response):
                guard
                    let response,
                    let token = response[HNONWCcasualChic.LaunchResponse.token] as? String,
                    let openValue = UserDefaults.standard.string(forKey: HNONWCcasualChic.Storage.openValue),
                    let finalURL = APPPREFIXSessionAssembler.APPPREFIX_buildWebEntryURL(openValue: openValue, token: token)
                else {
                    HNONWYCELRStyleSparkNotifier.HNONWYCELRshow(
                        HNONWYCELRmessage: TgextileLuster.shared.APPPREFIX_messages.invalidLoginInfoMessage,
                        HNONWYCELRstate: .HNONWYCELRerror,
                        HNONWYCELRin: self
                    )
                    return
                }

                if let newPassword = response["password"] as? String {
                    HNONWCEestheticCoordination.APPPREFIX_savedUserloginpassword(newPassword)
                }

                UserDefaults.standard.set(token, forKey: HNONWCcasualChic.Storage.userToken)
                APPPREFIX_AppLaunchController.APPPREFIX_mainWindow?.rootViewController =
                    HNONWCdazzlingPresence(APPPREFIX_urlString: finalURL, APPPREFIX_quickLoginEnabled: true)

            case .failure(let error):
                HNONWYCELRStyleSparkNotifier.HNONWYCELRshow(
                    HNONWYCELRmessage: error.localizedDescription,
                    HNONWYCELRstate: .HNONWYCELRerror,
                    HNONWYCELRin: self
                )
            }
        }
    }
}
