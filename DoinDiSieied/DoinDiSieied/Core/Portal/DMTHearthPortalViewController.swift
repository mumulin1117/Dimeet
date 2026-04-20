import StoreKit
import UIKit
import WebKit

final class DMTHearthPortalViewController: UIViewController, SKPaymentTransactionObserver, SKProductsRequestDelegate, WKNavigationDelegate, WKScriptMessageHandler, WKUIDelegate {
    private let route: DMTHearthPortalRoute
    private let wallpaper = UIImageView(image: UIImage(named: "elsesbackg"))
    private let spinner = UIActivityIndicatorView(style: .large)
    private let pantry: DMTAppPantry
    private let scriptNodes = [
      "foodLoversInteractionNest",
        "lunchBreakConversationHall",
        "flavorJourneyChatSphere",
        "gastronomicCircleConnection",
        "mealtimeBondingCompanion",
        "voiceRoomFoodieExperience","culinaryTogetherCircleSpace"
    ]
    private var purchaseRequest: SKProductsRequest?
    private var hidesNavigationBar = false
    private var isPageLoading = false {
        didSet { refreshSpinner() }
    }
    private var isPurchaseLoading = false {
        didSet { refreshSpinner() }
    }

    private lazy var webView: WKWebView = {
        let stage = WKWebView(frame: .zero, configuration: makeConfiguration())
        stage.translatesAutoresizingMaskIntoConstraints = false
        stage.navigationDelegate = self
        stage.uiDelegate = self
        stage.scrollView.contentInsetAdjustmentBehavior = .never
        stage.scrollView.keyboardDismissMode = .interactive
        stage.backgroundColor = .clear
        stage.isOpaque = false
        return stage
    }()

    init(route: DMTHearthPortalRoute, title: String? = nil, pantry: DMTAppPantry = .shared) {
        self.route = route
        self.pantry = pantry
        super.init(nibName: nil, bundle: nil)
        self.title = title ?? route.navigationTitle
    }

    required init?(coder: NSCoder) {
        nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        SKPaymentQueue.default().add(self)
        loadRoute()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hidesNavigationBar = navigationController?.isNavigationBarHidden ?? false
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParent || isBeingDismissed {
            navigationController?.setNavigationBarHidden(hidesNavigationBar, animated: animated)
        }
    }

    deinit {
        purchaseRequest?.cancel()
        scriptNodes.forEach { webView.configuration.userContentController.removeScriptMessageHandler(forName: $0) }
        SKPaymentQueue.default().remove(self)
    }

    private func makeConfiguration() -> WKWebViewConfiguration {
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        configuration.allowsInlineMediaPlayback = true
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        scriptNodes.forEach { configuration.userContentController.add(self, name: $0) }
        return configuration
    }

    private func configureLayout() {
        wallpaper.translatesAutoresizingMaskIntoConstraints = false
        wallpaper.contentMode = .scaleToFill

        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = DMTPalette.ink
        spinner.hidesWhenStopped = true

        view.backgroundColor = .white
        view.addSubview(wallpaper)
        view.addSubview(webView)
        view.addSubview(spinner)

        wallpaper.dmtPinEdges(to: view)
        webView.dmtPinEdges(to: view)

        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func loadRoute() {
        guard let url = route.makeURL() else {
            dmtShowNotice(title: "Page Missing", message: "The page address could not be created.")
            return
        }

        isPageLoading = true
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30)
        webView.load(request)
    }

    private func refreshSpinner() {
        let isLoading = isPageLoading || isPurchaseLoading
        if isLoading {
            spinner.startAnimating()
        } else {
            spinner.stopAnimating()
        }
        webView.isUserInteractionEnabled = isPurchaseLoading == false
    }

    private func openEmbeddedRoute(_ rawPath: String) {
        let controller = DMTHearthPortalViewController(route: .webEntry(path: rawPath), pantry: pantry)
        controller.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller, animated: true)
    }

    private func closeStage() {
        if presentingViewController != nil && navigationController?.viewControllers.first == self {
            dismiss(animated: true)
            return
        }
        navigationController?.popViewController(animated: true)
    }

    private func startPurchase(productID: String) {
        guard SKPaymentQueue.canMakePayments() else {
            dmtShowNotice(title: "Purchase Unavailable", message: "Payments are not allowed on this device.")
            return
        }

        isPurchaseLoading = true
        let request = SKProductsRequest(productIdentifiers: [productID])
        request.delegate = self
        purchaseRequest = request
        request.start()
    }

    private func finishPurchaseFlow(errorMessage: String? = nil, completed: Bool = false) {
        isPurchaseLoading = false
        purchaseRequest = nil

        if completed {
            webView.evaluateJavaScript("foodLoversInteractionNest()")
        }

        if let errorMessage {
            dmtShowNotice(title: "Purchase Failed", message: errorMessage)
        }
    }

    private func relaunchAuthRoot() {
        pantry.sessionStore.clear()
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        isPageLoading = true
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        isPageLoading = false
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        isPageLoading = false
        dmtShowNotice(title: "Page Unavailable", message: error.localizedDescription)
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        isPageLoading = false
        dmtShowNotice(title: "Page Unavailable", message: error.localizedDescription)
    }

    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        isPageLoading = false
    }

    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil, let requestURL = navigationAction.request.url {
            isPageLoading = true
            webView.load(URLRequest(url: requestURL))
        }
        return nil
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        switch message.name {
        case "lunchBreakConversationHall":
            guard let productID = message.body as? String, productID.isEmpty == false else { return }
            startPurchase(productID: productID)
        case "flavorJourneyChatSphere":
            guard let rawPath = message.body as? String, rawPath.isEmpty == false else { return }
            openEmbeddedRoute(rawPath)
        case "gastronomicCircleConnection", "voiceRoomFoodieExperience":
            closeStage()
        case "culinaryTogetherCircleSpace":
            relaunchAuthRoot()
        case "towInkLIopSparklingCider":
            break
        default:
            break
        }
    }

    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        guard let product = response.products.first else {
            finishPurchaseFlow(errorMessage: "The selected item is not available.")
            return
        }
        SKPaymentQueue.default().add(SKPayment(product: product))
    }

    func request(_ request: SKRequest, didFailWithError error: Error) {
        finishPurchaseFlow(errorMessage: error.localizedDescription)
    }

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                queue.finishTransaction(transaction)
                finishPurchaseFlow(completed: true)
            case .failed:
                queue.finishTransaction(transaction)
                finishPurchaseFlow(errorMessage: transaction.error?.localizedDescription ?? "The payment could not be completed.")
            case .restored:
                queue.finishTransaction(transaction)
                finishPurchaseFlow(completed: true)
            case .deferred, .purchasing:
                break
            @unknown default:
                queue.finishTransaction(transaction)
                finishPurchaseFlow(errorMessage: "An unknown payment state was received.")
            }
        }
    }
}
