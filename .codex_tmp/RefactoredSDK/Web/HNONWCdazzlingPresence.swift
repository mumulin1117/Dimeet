import UIKit
import WebKit

final class HNONWCdazzlingPresence: UIViewController, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {
    private let HNONWYCELRoutfitRegality: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.tintColor = .black
        indicator.color = .black
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    private var APPPREFIX_webViewContainer: WKWebView?
    private var APPPREFIX_pageLoadStartTime: TimeInterval = Date().timeIntervalSince1970
    private var APPPREFIX_isQuickLoginEnabled: Bool
    private let APPPREFIX_initialURLString: String

    init(APPPREFIX_urlString: String, APPPREFIX_quickLoginEnabled: Bool) {
        APPPREFIX_initialURLString = APPPREFIX_urlString
        APPPREFIX_isQuickLoginEnabled = APPPREFIX_quickLoginEnabled
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        APPPREFIXBackgroundSceneInstaller.install(imageNamed: TgextileLuster.shared.APPPREFIX_mainBackgroundImage, on: view)

        if APPPREFIX_isQuickLoginEnabled {
            APPPREFIX_addLoginButton()
            APPPREFIX_addSmallImageView()
        }

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
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        APPPREFIX_webViewContainer = webView

        view.addSubview(webView)
        view.addSubview(HNONWYCELRoutfitRegality)

        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            HNONWYCELRoutfitRegality.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            HNONWYCELRoutfitRegality.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        if let url = URL(string: APPPREFIX_initialURLString) {
            webView.load(URLRequest(url: url))
            APPPREFIX_pageLoadStartTime = Date().timeIntervalSince1970
        }

        HNONWYCELRoutfitRegality.startAnimating()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false

        let contentController = APPPREFIX_webViewContainer?.configuration.userContentController
        contentController?.add(self, name: HNONWCcasualChic.WebBridge.rechargePay)
        contentController?.add(self, name: HNONWCcasualChic.WebBridge.close)
        contentController?.add(self, name: HNONWCcasualChic.WebBridge.pageLoaded)
        contentController?.add(self, name: HNONWCcasualChic.WebBridge.openBrowser)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        APPPREFIX_webViewContainer?.configuration.userContentController.APPPREFIX_removeAllBridgeHandlers()
    }

    deinit {
        APPPREFIX_webViewContainer?.configuration.userContentController.APPPREFIX_removeAllBridgeHandlers()
    }

    private func APPPREFIX_addLoginButton() {
        let button = APPPREFIXQuickLoginButtonFactory.makeButton()
        button.isUserInteractionEnabled = false
        view.addSubview(button)

        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.widthAnchor.constraint(equalToConstant: TgextileLuster.shared.APPPREFIX_logButtonWidth),
            button.heightAnchor.constraint(equalToConstant: TgextileLuster.shared.APPPREFIX_logButtonHeight),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -55)
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

    func webView(
        _ webView: WKWebView,
        createWebViewWith configuration: WKWebViewConfiguration,
        for windowFeatures: WKWindowFeatures,
        completionHandler: @escaping (WKWebView?) -> Void
    ) {
        completionHandler(nil)
    }

    func webView(
        _ webView: WKWebView,
        createWebViewWith configuration: WKWebViewConfiguration,
        for navigationAction: WKNavigationAction,
        windowFeatures: WKWindowFeatures
    ) -> WKWebView? {
        if navigationAction.targetFrame == nil || navigationAction.targetFrame?.isMainFrame != false {
            if let url = navigationAction.request.url {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }

        return nil
    }

    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let url = navigationAction.request.url,
           let scheme = url.scheme?.lowercased(),
           !["http", "https", "file", "about"].contains(scheme) {
            UIApplication.shared.open(url, options: [:]) { [weak webView] success in
                let state = success ? "success" : "failed"
                let js = """
                window.dispatchEvent(new CustomEvent('nativeOpenState', {
                    detail: { state: '\(state)', url: '\(url.absoluteString)' }
                }));
                """
                DispatchQueue.main.async {
                    webView?.evaluateJavaScript(js, completionHandler: nil)
                }
            }
            decisionHandler(.cancel)
            return
        }

        decisionHandler(.allow)
    }

    func webView(
        _ webView: WKWebView,
        requestMediaCapturePermissionFor origin: WKSecurityOrigin,
        initiatedByFrame frame: WKFrameInfo,
        type: WKMediaCaptureType,
        decisionHandler: @escaping @MainActor (WKPermissionDecision) -> Void
    ) {
        decisionHandler(.grant)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.APPPREFIX_webViewContainer?.isHidden = false
            self.HNONWYCELRoutfitRegality.stopAnimating()
            if self.APPPREFIX_isQuickLoginEnabled {
                self.APPPREFIX_isQuickLoginEnabled = false
            }
        }

        let duration = Int(Date().timeIntervalSince1970 * 1000 - APPPREFIX_pageLoadStartTime * 1000)
        HNONWCEsilkDrape.shared.APPPREFIX_postRequest(
            TgextileLuster.shared.APPPREFIX_reportTimePath,
            APPPREFIX_params: [TgextileLuster.shared.APPPREFIX_reportTimeParamaKey: "\(duration)"]
        )
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        switch message.name {
        case HNONWCcasualChic.WebBridge.rechargePay:
            APPPREFIX_handleRechargeMessage(body: message.body)

        case HNONWCcasualChic.WebBridge.close:
            UserDefaults.standard.set(nil, forKey: HNONWCcasualChic.Storage.userToken)
            APPPREFIX_AppLaunchController.APPPREFIX_mainWindow?.rootViewController = EoutfitCuration()

        case HNONWCcasualChic.WebBridge.pageLoaded:
            APPPREFIX_webViewContainer?.isHidden = false
            HNONWYCELRoutfitRegality.stopAnimating()

        case HNONWCcasualChic.WebBridge.openBrowser:
            APPPREFIX_handleBrowserMessage(body: message.body)

        default:
            break
        }
    }

    private func APPPREFIX_handleRechargeMessage(body: Any) {
        guard let payload = body as? [String: Any] else { return }
        let productID = payload[HNONWCcasualChic.Payment.productID] as? String ?? ""
        let orderCode = payload[HNONWCcasualChic.Payment.orderCode] as? String ?? ""

        view.isUserInteractionEnabled = false
        HNONWYCELRoutfitRegality.startAnimating()

        HNONWYCELRPutAccessory.shared.HNONWYCELRtexturemapping(HNONWYCELRseasonalstyling: productID) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success:
                guard
                    let receiptData = HNONWYCELRPutAccessory.shared.HNONWYCELRfabricdraping(),
                    let transactionID = HNONWYCELRPutAccessory.shared.HNONWYCELRfabricsculpt,
                    let callbackResult = APPPREFIXSessionAssembler.APPPREFIX_buildPaymentCallbackJSON(orderCode: orderCode)
                else {
                    self.APPPREFIX_finishPaymentFlow(
                        message: TgextileLuster.shared.APPPREFIX_messages.paymentFailedMessage,
                        state: .HNONWYCELRerror
                    )
                    return
                }

                HNONWCEsilkDrape.shared.APPPREFIX_postRequest(
                    TgextileLuster.shared.APPPREFIX_verifyReciptyPath,
                    APPPREFIX_params: [
                        TgextileLuster.shared.APPPREFIX_verifyReciptyParamaKey.APPPREFIX_payload:
                            receiptData.base64EncodedString(),
                        TgextileLuster.shared.APPPREFIX_verifyReciptyParamaKey.APPPREFIX_transactionId:
                            transactionID,
                        TgextileLuster.shared.APPPREFIX_verifyReciptyParamaKey.APPPREFIX_callbackResult:
                            callbackResult
                    ],
                    APPPREFIX_isPaymentFlow: true
                ) { [weak self] verifyResult in
                    guard let self else { return }
                    switch verifyResult {
                    case .success:
                        self.APPPREFIX_finishPaymentFlow(
                            message: TgextileLuster.shared.APPPREFIX_messages.paymentSuccessMessage,
                            state: .HNONWYCELRsuccess
                        )
                    case .failure:
                        self.APPPREFIX_finishPaymentFlow(
                            message: TgextileLuster.shared.APPPREFIX_messages.paymentFailedMessage,
                            state: .HNONWYCELRerror
                        )
                    }
                }

            case .failure(let error):
                self.APPPREFIX_finishPaymentFlow(message: error.localizedDescription, state: .HNONWYCELRerror)
            }
        }
    }

    private func APPPREFIX_handleBrowserMessage(body: Any) {
        guard
            let payload = body as? [String: Any],
            let urlString = payload[HNONWCcasualChic.WebBridge.url] as? String,
            let url = URL(string: urlString)
        else {
            return
        }

        UIApplication.shared.open(url, options: [:]) { [weak self] success in
            let state = success ? "success" : "failed"
            let js = """
            window.dispatchEvent(new CustomEvent('nativeOpenState', {
                detail: { state: '\(state)', url: '\(url.absoluteString)' }
            }));
            """
            DispatchQueue.main.async {
                self?.APPPREFIX_webViewContainer?.evaluateJavaScript(js, completionHandler: nil)
            }
        }
    }

    private func APPPREFIX_finishPaymentFlow(message: String, state: HNONWYCELRStyleSparkNotifier.HNONWYCELRState) {
        view.isUserInteractionEnabled = true
        HNONWYCELRoutfitRegality.stopAnimating()
        HNONWYCELRStyleSparkNotifier.HNONWYCELRshow(
            HNONWYCELRmessage: message,
            HNONWYCELRstate: state,
            HNONWYCELRin: self
        )
    }
}
