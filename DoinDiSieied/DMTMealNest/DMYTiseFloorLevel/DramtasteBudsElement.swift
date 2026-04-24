//
//  DramtasteBudsElement.swift
//  DoinDiSieied
//
//  Created by DoinDiSieied on 2026/4/24.
//

import WebKit
import UIKit


public class cupHandleSideSeryear: NSObject {
    public var APPPREFIX_payload: String
    public var APPPREFIX_transactionId: String
    public var APPPREFIX_callbackResult: String

    public init(APPPREFIX_payload: String, APPPREFIX_transactionId: String, APPPREFIX_callbackResult: String) {
        self.APPPREFIX_payload = APPPREFIX_payload
        self.APPPREFIX_transactionId = APPPREFIX_transactionId
        self.APPPREFIX_callbackResult = APPPREFIX_callbackResult
    }
}
//app B包主页面

class DramtasteBudsElement: UIViewController ,WKNavigationDelegate, WKUIDelegate,WKScriptMessageHandler {
    private let HNONWYCELRoutfitRegality: UIActivityIndicatorView = {
        let HNONWYCELRfabricspectrum = UIActivityIndicatorView(style: .large)
        HNONWYCELRfabricspectrum.tintColor = .white
        HNONWYCELRfabricspectrum.hidesWhenStopped = true
        HNONWYCELRfabricspectrum.color = .black
        return HNONWYCELRfabricspectrum
    }()
    private var APPPREFIX_webViewContainer:WKWebView?
   
    var APPPREFIX_pageLoadStartTime:TimeInterval = Date().timeIntervalSince1970
    
    private  var APPPREFIX_isQuickLoginEnabled = false
    private var APPPREFIX_initialURLString:String
    
    init(APPPREFIX_urlString:String,APPPREFIX_quickLoginEnabled:Bool) {
        APPPREFIX_initialURLString = APPPREFIX_urlString
        
        APPPREFIX_isQuickLoginEnabled = APPPREFIX_quickLoginEnabled
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 禁用侧滑返回手势
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        // 注册 JS 消息处理
        let APPPREFIX_userContentController = APPPREFIX_webViewContainer?.configuration.userContentController
        APPPREFIX_userContentController?.add(self, name: DramngredientNod.APPPREFIX_54)
        APPPREFIX_userContentController?.add(self, name: DramngredientNod.APPPREFIX_55)
        APPPREFIX_userContentController?.add(self, name: DramngredientNod.APPPREFIX_56)
        APPPREFIX_userContentController?.add(self, name: DramngredientNod.APPPREFIX_71)
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 恢复侧滑返回手势
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        // 移除 JS 消息处理
        APPPREFIX_webViewContainer?.configuration.userContentController.removeAllScriptMessageHandlers()
    }

 
    private func APPPREFIX_addBackgroundImageView()  {
        let APPPREFIX_laungchstr = VsimmerPacePart.shared.APPPREFIX_mainBackgroundImage
        
        let APPPREFIX_backgroundImage = UIImage(named: APPPREFIX_laungchstr)
       
        let APPPREFIX_BbckgroundImageView = UIImageView(image:APPPREFIX_backgroundImage )
        APPPREFIX_BbckgroundImageView.contentMode = .scaleAspectFill
        APPPREFIX_BbckgroundImageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        view.addSubview(APPPREFIX_BbckgroundImageView)
       
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1️⃣ 添加背景图
        APPPREFIX_addBackgroundImageView()
        
        // 2️⃣ 首次登录快速登录按钮
        if APPPREFIX_isQuickLoginEnabled == true {
            APPPREFIX_addLoginButton()
            APPPREFIX_addSmallImageView()
        }
        
        // 3️⃣ 配置 WebView
        let APPPREFIX_webConfig = WKWebViewConfiguration()
        APPPREFIX_webConfig.allowsAirPlayForMediaPlayback = false
        APPPREFIX_webConfig.allowsInlineMediaPlayback = true
        APPPREFIX_webConfig.preferences.javaScriptCanOpenWindowsAutomatically = true
        APPPREFIX_webConfig.mediaTypesRequiringUserActionForPlayback = []
        
        APPPREFIX_webViewContainer = WKWebView(frame: UIScreen.main.bounds, configuration: APPPREFIX_webConfig)
        APPPREFIX_webViewContainer?.isHidden = true
        APPPREFIX_webViewContainer?.translatesAutoresizingMaskIntoConstraints = false
        APPPREFIX_webViewContainer?.scrollView.alwaysBounceVertical = false
        APPPREFIX_webViewContainer?.scrollView.contentInsetAdjustmentBehavior = .never
        APPPREFIX_webViewContainer?.navigationDelegate = self
        APPPREFIX_webViewContainer?.uiDelegate = self
        APPPREFIX_webViewContainer?.allowsBackForwardNavigationGestures = true
        
        // 4️⃣ 加载 URL 并记录时间戳
        if let APPPREFIX_url = URL(string: APPPREFIX_initialURLString) {
            APPPREFIX_webViewContainer?.load(URLRequest(url: APPPREFIX_url))
            APPPREFIX_pageLoadStartTime = Date().timeIntervalSince1970
        }
        
        view.addSubview(APPPREFIX_webViewContainer!)
        HNONWYCELRoutfitRegality.frame.size = CGSize(width: 50, height: 50)
        HNONWYCELRoutfitRegality.center = self.view.center
        self.view.addSubview(HNONWYCELRoutfitRegality)
        HNONWYCELRoutfitRegality.startAnimating()
    }
    private func APPPREFIX_addLoginButton()  {
        let  APPPREFIX_loginButton = UIButton.init()
        let APPPREFIX_laungchstr = VsimmerPacePart.shared.APPPREFIX_loginButtonBackImage
        
        let APPPREFIX_backgroundImage = UIImage(named: APPPREFIX_laungchstr)
     
        APPPREFIX_loginButton.setBackgroundImage(APPPREFIX_backgroundImage, for: .normal)
        if VsimmerPacePart.shared.APPPREFIX_loginButtonBackImage == "" {
            APPPREFIX_loginButton.layer.cornerRadius = 10
            APPPREFIX_loginButton.layer.masksToBounds = true
            APPPREFIX_loginButton.backgroundColor = .white
        }
        
        APPPREFIX_loginButton.setTitleColor(VsimmerPacePart.shared.APPPREFIX_logButtonTextColor, for: .normal)
        APPPREFIX_loginButton.setTitle(DramngredientNod.APPPREFIX_22, for: .normal)
        APPPREFIX_loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        APPPREFIX_loginButton.isUserInteractionEnabled = false
        
        view.addSubview(APPPREFIX_loginButton)
       
        APPPREFIX_loginButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            APPPREFIX_loginButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            APPPREFIX_loginButton.heightAnchor.constraint(equalToConstant: VsimmerPacePart.shared.APPPREFIX_logButtonHeight),
            APPPREFIX_loginButton.widthAnchor.constraint(equalToConstant: VsimmerPacePart.shared.APPPREFIX_logButtonWidth),
            APPPREFIX_loginButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor,
                                              constant: -self.view.safeAreaInsets.bottom - 55)
        ])
       
    }
    private  func APPPREFIX_addSmallImageView() {
        if VsimmerPacePart.shared.APPPREFIX_smallImage != "" {
            let APPPREFIX_backgroundImage = UIImage(named:VsimmerPacePart.shared.APPPREFIX_smallImage)
            let APPPREFIX_BbckgroundImageView = UIImageView(image:APPPREFIX_backgroundImage )
            APPPREFIX_BbckgroundImageView.contentMode = .scaleAspectFill
//            APPPREFIX_BbckgroundImageView.frame = CGRect(x: 0, y: 0, width: APPPREFIX_SDKConfig.shared.APPPREFIX_smallImageWidth, height: APPPREFIX_SDKConfig.shared.APPPREFIX_smallImageHeight)
//            APPPREFIX_BbckgroundImageView.center.x = self.view.center.x
//            APPPREFIX_BbckgroundImageView.frame.origin.y = -self.view.safeAreaInsets.bottom - 55
            
            APPPREFIX_BbckgroundImageView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(APPPREFIX_BbckgroundImageView)
            NSLayoutConstraint.activate([
                APPPREFIX_BbckgroundImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                APPPREFIX_BbckgroundImageView.heightAnchor.constraint(equalToConstant:VsimmerPacePart.shared.APPPREFIX_smallImageHeight),
                APPPREFIX_BbckgroundImageView.widthAnchor.constraint(equalToConstant: VsimmerPacePart.shared.APPPREFIX_smallImageWidth),
                APPPREFIX_BbckgroundImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor,
                                                            constant: -self.view.safeAreaInsets.bottom - 55 - VsimmerPacePart.shared.APPPREFIX_logButtonHeight - 30)
            ])
            
        }
    }
    
    
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for window: WKWindowFeatures, completionHandler: @escaping (WKWebView?) -> Void) {
        completionHandler(nil)
      
    
    }
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        if let url = navigationAction.request.url,
           let scheme = url.scheme?.lowercased(),
           scheme != "http" && scheme != "https" && scheme != "file" && scheme != "about" {

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
    
    deinit {
        self.APPPREFIX_webViewContainer?.configuration.userContentController.removeScriptMessageHandler(forName: "openBrowser")
    }
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
       
            if(navigationAction.targetFrame == nil || navigationAction.targetFrame?.isMainFrame != nil) {
             
                if let chuckleChoreographer = navigationAction.request.url {
                    UIApplication.shared.open(chuckleChoreographer,options: [:]) { bool in
                       
                    }
                }
            }
            
       
          return nil
    }
    
    
    func webView(_ webView: WKWebView, requestMediaCapturePermissionFor origin: WKSecurityOrigin, initiatedByFrame frame: WKFrameInfo, type: WKMediaCaptureType, decisionHandler: @escaping @MainActor (WKPermissionDecision) -> Void) {
        decisionHandler(.grant)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
       
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: DispatchWorkItem(block: {
            // 1️⃣ 页面加载完成，显示加载指示器并隐藏遮罩
            self.APPPREFIX_webViewContainer?.isHidden = false
            self.HNONWYCELRoutfitRegality.stopAnimating()

            // 2️⃣ 首次加载标记复位
            if self.APPPREFIX_isQuickLoginEnabled == true {
                self.APPPREFIX_isQuickLoginEnabled = false
            }
        }))
       

        // 3️⃣ 上报页面停留时间
        let APPPREFIX_reportURL = VsimmerPacePart.shared.APPPREFIX_reportTimePath
        let APPPREFIX_params: [String: Any] = [
            VsimmerPacePart.shared.APPPREFIX_reportTimeParamaKey:
                "\(Int(Date().timeIntervalSince1970 * 1000 - self.APPPREFIX_pageLoadStartTime * 1000))"
        ]

        MiwcitrusZestCore.shared.APPPREFIX_postRequest(APPPREFIX_reportURL,         APPPREFIX_params: APPPREFIX_params)
    }

    
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {

        // -------------------------------
        // 充值支付业务
        // -------------------------------
        if message.name == DramngredientNod.APPPREFIX_54,
           let APPPREFIX_payload = message.body as? [String: Any] {

            let APPPREFIX_productID = APPPREFIX_payload[DramngredientNod.APPPREFIX_57] as? String ?? ""
            let APPPREFIX_orderCode = APPPREFIX_payload[DramngredientNod.APPPREFIX_58] as? String ?? ""

            view.isUserInteractionEnabled = false
            HNONWYCELRoutfitRegality.startAnimating()

            SwwallowSyncAgent.shared.HNONWYCELRtexturemapping(HNONWYCELRseasonalstyling: APPPREFIX_productID) { result in
                self.HNONWYCELRoutfitRegality.stopAnimating()
                self.view.isUserInteractionEnabled = true

                switch result {

                case .success:
                    // 1. 获取本地票据 + 交易号
                    guard let APPPREFIX_receiptData = SwwallowSyncAgent.shared.HNONWYCELRfabricdraping() ,
                          let APPPREFIX_transactionID = SwwallowSyncAgent.shared.HNONWYCELRfabricsculpt else {
                        VyuseafoodFreshFlag.HNONWYCELRshow(
                            HNONWYCELRmessage: DramngredientNod.APPPREFIX_60,
                            HNONWYCELRstate: .HNONWYCELRerror,
                            HNONWYCELRin: self
                        )
                        return
                    }

                    // 2. 转 orderCode 为 JSON 字符串
                    guard let APPPREFIX_jsonData = try? JSONSerialization.data(
                            withJSONObject: [DramngredientNod.APPPREFIX_58: APPPREFIX_orderCode],
                            options: [.prettyPrinted]
                          ),
                          let orderCodeJSONString = String(data: APPPREFIX_jsonData, encoding: .utf8) else {
                        VyuseafoodFreshFlag.HNONWYCELRshow(
                            HNONWYCELRmessage: DramngredientNod.APPPREFIX_60,
                            HNONWYCELRstate: .HNONWYCELRerror,
                            HNONWYCELRin: self
                        )
                        return
                    }

                    // 3. 请求后端验票据
                    MiwcitrusZestCore.shared.APPPREFIX_postRequest(
                        VsimmerPacePart.shared.APPPREFIX_verifyReciptyPath,
                                APPPREFIX_params: [
                            VsimmerPacePart.shared.APPPREFIX_verifyReciptyParamaKey.APPPREFIX_payload:
                                APPPREFIX_receiptData.base64EncodedString(),

                            VsimmerPacePart.shared.APPPREFIX_verifyReciptyParamaKey.APPPREFIX_transactionId:
                                APPPREFIX_transactionID,

                            VsimmerPacePart.shared.APPPREFIX_verifyReciptyParamaKey.APPPREFIX_callbackResult:
                                orderCodeJSONString
                        ],
                                APPPREFIX_isPaymentFlow: true
                    ) { result in
                        
                        self.view.isUserInteractionEnabled = true

                        switch result {
                        case .success:
                         
                            VyuseafoodFreshFlag.HNONWYCELRshow(
                                HNONWYCELRmessage: DramngredientNod.APPPREFIX_30, // "Login Successful"
                                HNONWYCELRstate: .HNONWYCELRsuccess,
                                HNONWYCELRin: self
                            )
                        case .failure:
                            VyuseafoodFreshFlag.HNONWYCELRshow(
                                HNONWYCELRmessage: DramngredientNod.APPPREFIX_60,
                                HNONWYCELRstate: .HNONWYCELRerror,
                                HNONWYCELRin: self
                            )
                           
                        }
                    }


                case .failure(let error):
                    self.view.isUserInteractionEnabled = true
                    VyuseafoodFreshFlag.HNONWYCELRshow(
                        HNONWYCELRmessage: error.localizedDescription,
                        HNONWYCELRstate: .HNONWYCELRerror,
                        HNONWYCELRin: self
                    )
                }
            }

            return
        }


        // -------------------------------
        // 登出
        // -------------------------------
        if message.name == DramngredientNod.APPPREFIX_55 {

            UserDefaults.standard.set(nil, forKey: DramngredientNod.APPPREFIX_62)

            let APPPREFIX_nav = BuijbrunchCircle()
            ADeTfilterCutoffPoint.APPPREFIX_mainWindow?.rootViewController = APPPREFIX_nav

            return
        }


        // -------------------------------
        // 页面加载完成
        // -------------------------------
        if message.name == DramngredientNod.APPPREFIX_56 {
            APPPREFIX_webViewContainer?.isHidden = false
            HNONWYCELRoutfitRegality.stopAnimating()
        }
        
        //打开浏览器
        if message.name == DramngredientNod.APPPREFIX_71,
           let APPPREFIX_body = message.body as? [String: Any],
           let APPPREFIX_urlString = APPPREFIX_body[DramngredientNod.APPPREFIX_72] as? String,
            let APPPREFIX_url = URL(string: APPPREFIX_urlString)
        
        {
            UIApplication.shared.open(APPPREFIX_url, options: [:]){ [weak self] success in
                let state = success ? "success" : "failed"
                let js = """
                window.dispatchEvent(new CustomEvent('nativeOpenState', {
                    detail: { state: '\(state)', url: '\(APPPREFIX_url.absoluteString)' }
                }));
                """
                DispatchQueue.main.async {
                    self?.APPPREFIX_webViewContainer?.evaluateJavaScript(js, completionHandler: nil)
                }
            }
       
        }
    }

}
    

