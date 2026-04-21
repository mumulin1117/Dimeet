import StoreKit
import UIKit
import WebKit

final class DMTHearthPortalViewController: UIViewController, SKPaymentTransactionObserver, SKProductsRequestDelegate, WKNavigationDelegate, WKScriptMessageHandler, WKUIDelegate {
    private let portalRoute: DMTHearthPortalRoute
    private let hearthBackdrop = UIImageView(image: UIImage(named: "elsesbackg"))
    private let simmerSpinner = UIActivityIndicatorView(style: .large)
    private let tablePantry: DMTAppPantry
    private let jsBridgeNodes = [
      "foodLoversInteractionNest",
        "lunchBreakConversationHall",
        "flavorJourneyChatSphere",
        "gastronomicCircleConnection",
        "mealtimeBondingCompanion",
        "voiceRoomFoodieExperience","culinaryTogetherCircleSpace"
    ]
    private var pendingPurchaseRequest: SKProductsRequest?
    private var storedNavHiddenState = false
    private var isPortalLoading = false {
        didSet { refreshPortalSpinner() }
    }
    private var isCheckoutLoading = false {
        didSet { refreshPortalSpinner() }
    }

    private lazy var portalStage: WKWebView = {
        let stage = WKWebView(frame: .zero, configuration: brewPortalConfiguration())
        stage.translatesAutoresizingMaskIntoConstraints = false
        stage.navigationDelegate = self
        stage.uiDelegate = self
        stage.scrollView.contentInsetAdjustmentBehavior = .never
        stage.scrollView.keyboardDismissMode = .interactive
        stage.backgroundColor = .clear
        stage.isOpaque = false
        return stage
    }()

    init(portalRoute: DMTHearthPortalRoute, title: String? = nil, tablePantry: DMTAppPantry = .shared) {
        self.portalRoute = portalRoute
        self.tablePantry = tablePantry
        super.init(nibName: nil, bundle: nil)
        self.title = title ?? portalRoute.navigationTitle
    }

    required init?(coder: NSCoder) {
        nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        composeLayout()
        SKPaymentQueue.default().add(self)
        loadPortalRoute()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        storedNavHiddenState = navigationController?.isNavigationBarHidden ?? false
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParent || isBeingDismissed {
            navigationController?.setNavigationBarHidden(storedNavHiddenState, animated: animated)
        }
    }

    deinit {
        pendingPurchaseRequest?.cancel()
        jsBridgeNodes.forEach { portalStage.configuration.userContentController.removeScriptMessageHandler(forName: $0) }
        SKPaymentQueue.default().remove(self)
    }

    private func brewPortalConfiguration() -> WKWebViewConfiguration {
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        configuration.allowsInlineMediaPlayback = true
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        jsBridgeNodes.forEach { configuration.userContentController.add(self, name: $0) }
        return configuration
    }

    private func composeLayout() {
        hearthBackdrop.translatesAutoresizingMaskIntoConstraints = false
        hearthBackdrop.contentMode = .scaleToFill

        simmerSpinner.translatesAutoresizingMaskIntoConstraints = false
        simmerSpinner.color = DMTPalette.ink
        simmerSpinner.hidesWhenStopped = true

        view.backgroundColor = .white
        view.addSubview(hearthBackdrop)
        view.addSubview(portalStage)
        view.addSubview(simmerSpinner)

        hearthBackdrop.dmtPinCourseEdges(to: view)
        portalStage.dmtPinCourseEdges(to: view)

        NSLayoutConstraint.activate([
            simmerSpinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            simmerSpinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func loadPortalRoute() {
        guard let url = portalRoute.makeURL() else {
            dmtServeNotice(title: "Page Missing", message: "The page address could not be created.")
            return
        }

        isPortalLoading = true
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30)
        portalStage.load(request)
    }

    private func refreshPortalSpinner() {
        let isLoading = isPortalLoading || isCheckoutLoading
        if isLoading {
            simmerSpinner.startAnimating()
        } else {
            simmerSpinner.stopAnimating()
        }
        portalStage.isUserInteractionEnabled = isCheckoutLoading == false
    }

    private func pushEmbeddedPortal(_ rawPath: String) {
        let controller = DMTHearthPortalViewController(portalRoute: .webEntry(path: rawPath), tablePantry: tablePantry)
        controller.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller, animated: true)
    }

    private func closePortalStage() {
        if presentingViewController != nil && navigationController?.viewControllers.first == self {
            dismiss(animated: true)
            return
        }
        navigationController?.popViewController(animated: true)
    }

    private func beginStorePurchase(productID: String) {
        guard SKPaymentQueue.canMakePayments() else {
            dmtServeNotice(title: "Purchase Unavailable", message: "Payments are not allowed on this device.")
            return
        }

        isCheckoutLoading = true
        let request = SKProductsRequest(productIdentifiers: [productID])
        request.delegate = self
        pendingPurchaseRequest = request
        request.start()
    }

    private func resolvePurchaseFlow(errorMessage: String? = nil, completed: Bool = false) {
        isCheckoutLoading = false
        pendingPurchaseRequest = nil

        if completed {
            portalStage.evaluateJavaScript("foodLoversInteractionNest()")
        }

        if let errorMessage {
            dmtServeNotice(title: "Purchase Failed", message: errorMessage)
        }
    }

    private func resetSeatRoot() {
        tablePantry.seatSession.clear()
    }

    func webView(_ portalStage: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        isPortalLoading = true
    }

    func webView(_ portalStage: WKWebView, didFinish navigation: WKNavigation!) {
        isPortalLoading = false
    }

    func webView(_ portalStage: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        isPortalLoading = false
        dmtServeNotice(title: "Page Unavailable", message: error.localizedDescription)
    }

    func webView(_ portalStage: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        isPortalLoading = false
        dmtServeNotice(title: "Page Unavailable", message: error.localizedDescription)
    }

    func webViewWebContentProcessDidTerminate(_ portalStage: WKWebView) {
        isPortalLoading = false
    }

    func webView(_ portalStage: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil, let requestURL = navigationAction.request.url {
            isPortalLoading = true
            portalStage.load(URLRequest(url: requestURL))
        }
        return nil
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        switch message.name {
        case "lunchBreakConversationHall":
            guard let productID = message.body as? String, productID.isEmpty == false else { return }
            beginStorePurchase(productID: productID)
        case "flavorJourneyChatSphere":
            guard let rawPath = message.body as? String, rawPath.isEmpty == false else { return }
            pushEmbeddedPortal(rawPath)
        case "gastronomicCircleConnection", "voiceRoomFoodieExperience":
            closePortalStage()
        case "culinaryTogetherCircleSpace":
            resetSeatRoot()
        case "towInkLIopSparklingCider":
            break
        default:
            break
        }
    }

    nonisolated func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        guard let product = response.products.first else {
            Task { @MainActor [weak self] in
                self?.resolvePurchaseFlow(errorMessage: "The selected item is not available.")
            }
            return
        }
        SKPaymentQueue.default().add(SKPayment(product: product))
    }

    nonisolated func request(_ request: SKRequest, didFailWithError error: Error) {
        Task { @MainActor [weak self] in
            self?.resolvePurchaseFlow(errorMessage: error.localizedDescription)
        }
    }

    nonisolated func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                queue.finishTransaction(transaction)
                Task { @MainActor [weak self] in
                    self?.resolvePurchaseFlow(completed: true)
                }
            case .failed:
                queue.finishTransaction(transaction)
                Task { @MainActor [weak self] in
                    self?.resolvePurchaseFlow(errorMessage: transaction.error?.localizedDescription ?? "The payment could not be completed.")
                }
            case .restored:
                queue.finishTransaction(transaction)
                Task { @MainActor [weak self] in
                    self?.resolvePurchaseFlow(completed: true)
                }
            case .deferred, .purchasing:
                break
            @unknown default:
                queue.finishTransaction(transaction)
                Task { @MainActor [weak self] in
                    self?.resolvePurchaseFlow(errorMessage: "An unknown payment state was received.")
                }
            }
        }
    }
}
