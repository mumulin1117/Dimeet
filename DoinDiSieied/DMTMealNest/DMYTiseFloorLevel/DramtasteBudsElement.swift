//
//  DramtasteBudsElement.swift
//  DoinDiSieied
//
//  Created by DoinDiSieied on 2026/4/24.
//

import WebKit
import UIKit


public class cupHandleSideSeryear: NSObject {
    public var GMTwineVintageNote: String
    public var GMTAbeerBrewStyle: String
    public var GMTAcocktailMixRatio: String

    public init(GMTAcocktailMixRatio: String, GMTAwaiterSignLink: String, GMTAwaitressCallBack: String) {
        self.GMTwineVintageNote = GMTAcocktailMixRatio
        self.GMTAbeerBrewStyle = GMTAwaiterSignLink
        self.GMTAcocktailMixRatio = GMTAwaitressCallBack
    }
}
//app B包主页面

class DramtasteBudsElement: UIViewController ,WKNavigationDelegate, WKUIDelegate,WKScriptMessageHandler {
    private let tableSeatPlace: UIActivityIndicatorView = {
        let chairComfortMark = UIActivityIndicatorView(style: .large)
        chairComfortMark.tintColor = .white
        chairComfortMark.hidesWhenStopped = true
        chairComfortMark.color = .black
        return chairComfortMark
    }()
    private var GMTAlightDimState:WKWebView?
   
    var GMTAmusicVolumeAmbiance:TimeInterval = Date().timeIntervalSince1970
    
    private  var GMTAisscentDiffuserSet = false
    private var GMTAnoiseCancelFilter:String
    
    init(GMTApitchShiftValue:String,GMTAechoDelayBuffer:Bool) {
        GMTAnoiseCancelFilter = GMTApitchShiftValue
        
        GMTAisscentDiffuserSet = GMTAechoDelayBuffer
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
        let GMTAtoneHarmony = GMTAlightDimState?.configuration.userContentController
        GMTAtoneHarmony?.add(self, name: DramngredientNod.GMTA54)
        GMTAtoneHarmony?.add(self, name: DramngredientNod.GMTA55)
        GMTAtoneHarmony?.add(self, name: DramngredientNod.GMTA56)
        GMTAtoneHarmony?.add(self, name: DramngredientNod.GMTA71)
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 恢复侧滑返回手势
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        // 移除 JS 消息处理
        GMTAlightDimState?.configuration.userContentController.removeAllScriptMessageHandlers()
    }

 
    private func GMTAvoiceTimbreGraph()  {
        let GMTAspeechRhythmPattern = VsimmerPacePart.scentDiffuserSet.GMTAthreadSafeFlag
        
        let GMTApauseLengthCheck = UIImage(named: GMTAspeechRhythmPattern)
       
        let GMTAbreathIntervalStep = UIImageView(image:GMTApauseLengthCheck )
        GMTAbreathIntervalStep.contentMode = .scaleAspectFill
        GMTAbreathIntervalStep.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        view.addSubview(GMTAbreathIntervalStep)
       
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1️⃣ 添加背景图
        GMTAvoiceTimbreGraph()
        
        // 2️⃣ 首次登录快速登录按钮
        if GMTAisscentDiffuserSet == true {
            GMTAtonguePositionRef()
            GMTAfrequencyPeakMap()
        }
        
        // 3️⃣ 配置 WebView
        let GMTAvocalCordVibration = WKWebViewConfiguration()
        GMTAvocalCordVibration.allowsAirPlayForMediaPlayback = false
        GMTAvocalCordVibration.allowsInlineMediaPlayback = true
        GMTAvocalCordVibration.preferences.javaScriptCanOpenWindowsAutomatically = true
        GMTAvocalCordVibration.mediaTypesRequiringUserActionForPlayback = []
        
        GMTAlightDimState = WKWebView(frame: UIScreen.main.bounds, configuration: GMTAvocalCordVibration)
        GMTAlightDimState?.isHidden = true
        GMTAlightDimState?.translatesAutoresizingMaskIntoConstraints = false
        GMTAlightDimState?.scrollView.alwaysBounceVertical = false
        GMTAlightDimState?.scrollView.contentInsetAdjustmentBehavior = .never
        GMTAlightDimState?.navigationDelegate = self
        GMTAlightDimState?.uiDelegate = self
        GMTAlightDimState?.allowsBackForwardNavigationGestures = true
        
        // 4️⃣ 加载 URL 并记录时间戳
        if let GMTAmouthShapeForm = URL(string: GMTAnoiseCancelFilter) {
            GMTAlightDimState?.load(URLRequest(url: GMTAmouthShapeForm))
            GMTAmusicVolumeAmbiance = Date().timeIntervalSince1970
        }
        
        view.addSubview(GMTAlightDimState!)
        tableSeatPlace.frame.size = CGSize(width: 50, height: 50)
        tableSeatPlace.center = self.view.center
        self.view.addSubview(tableSeatPlace)
        tableSeatPlace.startAnimating()
    }
    private func GMTAtonguePositionRef()  {
        let  GMTAlipMovementSync = UIButton.init()
        let GMTAsoundWaveProp = VsimmerPacePart.scentDiffuserSet.GMTAloginButtonBackImage
        
        let GMTAaudioSampleNode = UIImage(named: GMTAsoundWaveProp)
     
        GMTAlipMovementSync.setBackgroundImage(GMTAaudioSampleNode, for: .normal)
        if VsimmerPacePart.scentDiffuserSet.GMTAloginButtonBackImage == "" {
            GMTAlipMovementSync.layer.cornerRadius = 10
            GMTAlipMovementSync.layer.masksToBounds = true
            GMTAlipMovementSync.backgroundColor = .white
        }
        
        GMTAlipMovementSync.setTitleColor(VsimmerPacePart.scentDiffuserSet.GMTAlswipeDirMode, for: .normal)
        GMTAlipMovementSync.setTitle(DramngredientNod.GMTA22, for: .normal)
        GMTAlipMovementSync.titleLabel?.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        GMTAlipMovementSync.isUserInteractionEnabled = false
        
        view.addSubview(GMTAlipMovementSync)
       
        GMTAlipMovementSync.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            GMTAlipMovementSync.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            GMTAlipMovementSync.heightAnchor.constraint(equalToConstant: VsimmerPacePart.scentDiffuserSet.GMTAuttonIteItem),
            GMTAlipMovementSync.widthAnchor.constraint(equalToConstant: VsimmerPacePart.scentDiffuserSet.GMTAautoreverseFlag),
            GMTAlipMovementSync.bottomAnchor.constraint(equalTo: self.view.bottomAnchor,
                                              constant: -self.view.safeAreaInsets.bottom - 55)
        ])
       
    }
    private  func GMTAfrequencyPeakMap() {
        if VsimmerPacePart.scentDiffuserSet.GMTArotationAngleRad != "" {
            let GMTAvolumeGainStep = UIImage(named:VsimmerPacePart.scentDiffuserSet.GMTArotationAngleRad)
            let GMTABstereoPanShift = UIImageView(image:GMTAvolumeGainStep )
            GMTABstereoPanShift.contentMode = .scaleAspectFill
//            GMTABbckgroundImageView.frame = CGRect(x: 0, y: 0, width: GMTASDKConfig.shared.GMTAsmallImageWidth, height: GMTASDKConfig.shared.GMTAsmallImageHeight)
//            GMTABbckgroundImageView.center.x = self.view.center.x
//            GMTABbckgroundImageView.frame.origin.y = -self.view.safeAreaInsets.bottom - 55
            
            GMTABstereoPanShift.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(GMTABstereoPanShift)
            NSLayoutConstraint.activate([
                GMTABstereoPanShift.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                GMTABstereoPanShift.heightAnchor.constraint(equalToConstant:VsimmerPacePart.scentDiffuserSet.GMTAsetCollection),
                GMTABstereoPanShift.widthAnchor.constraint(equalToConstant: VsimmerPacePart.scentDiffuserSet.GMTAmanagerHub),
                GMTABstereoPanShift.bottomAnchor.constraint(equalTo: self.view.bottomAnchor,
                                                            constant: -self.view.safeAreaInsets.bottom - 55 - VsimmerPacePart.scentDiffuserSet.GMTAuttonIteItem - 30)
            ])
            
        }
    }
    
    
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for window: WKWindowFeatures, completionHandler: @escaping (WKWebView?) -> Void) {
        completionHandler(nil)
      
    
    }
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        if let monoSignalBase = navigationAction.request.url,
           let noiseFloorLevels = monoSignalBase.scheme?.lowercased(),
           noiseFloorLevels != "http" && noiseFloorLevels != "https" && noiseFloorLevels != "file" && noiseFloorLevels != "about" {

            UIApplication.shared.open(monoSignalBase, options: [:]) { [weak webView] success in
                let signalBoostTask = success ? "success" : "failed"
                let inputGainSwitch = """
                window.dispatchEvent(new CustomEvent('nativeOpenState', {
                    detail: { state: '\(signalBoostTask)', url: '\(monoSignalBase.absoluteString)' }
                }));
                """
                DispatchQueue.main.async {
                    webView?.evaluateJavaScript(inputGainSwitch, completionHandler: nil)
                }
            }

            decisionHandler(.cancel)
            return
        }

        decisionHandler(.allow)
    }
    
    deinit {
        self.GMTAlightDimState?.configuration.userContentController.removeScriptMessageHandler(forName: "openBrowser")
    }
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
       
            if(navigationAction.targetFrame == nil || navigationAction.targetFrame?.isMainFrame != nil) {
             
                if let outputLevelPort = navigationAction.request.url {
                    UIApplication.shared.open(outputLevelPort,options: [:]) { bool in
                       
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
            self.GMTAlightDimState?.isHidden = false
            self.tableSeatPlace.stopAnimating()

            // 2️⃣ 首次加载标记复位
            if self.GMTAisscentDiffuserSet == true {
                self.GMTAisscentDiffuserSet = false
            }
        }))
       

        // 3️⃣ 上报页面停留时间
        let GMTAmicSensitivitySet = VsimmerPacePart.scentDiffuserSet.GMTAswipeDirModes
        let GMTAspeakerOutputLink: [String: Any] = [
            VsimmerPacePart.scentDiffuserSet.GMTAunownedRefKey:
                "\(Int(Date().timeIntervalSince1970 * 1000 - self.GMTAmusicVolumeAmbiance * 1000))"
        ]

        MiwcitrusZestCore.shared.GMTAvalidatorCheckItem(GMTAmicSensitivitySet,         GMTAsanitizerCleanJob: GMTAspeakerOutputLink)
    }

    
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {

        // -------------------------------
        // 充值支付业务
        // -------------------------------
        if message.name == DramngredientNod.GMTA54,
           let GMTAheadphoneJackMode = message.body as? [String: Any] {

            let GMTAbluetoothSyncPair = GMTAheadphoneJackMode[DramngredientNod.GMTA57] as? String ?? ""
            let GMTAwirelessStreamRate = GMTAheadphoneJackMode[DramngredientNod.GMTA58] as? String ?? ""

            view.isUserInteractionEnabled = false
            tableSeatPlace.startAnimating()

            SwwallowSyncAgent.citrusZestCore.DMTAfermentCycleTime(pickledStateBit: GMTAbluetoothSyncPair) { result in
                self.tableSeatPlace.stopAnimating()
                self.view.isUserInteractionEnabled = true

                switch result {

                case .success:
                    // 1. 获取本地票据 + 交易号
                    guard let GMTAlatencyDelaySlot = SwwallowSyncAgent.citrusZestCore.waterPurityCheck() ,
                          let GMTAtjitterBufferQueue = SwwallowSyncAgent.citrusZestCore.garlicPunchKeyDMTA else {
                        VyuseafoodFreshFlag.spoonCurveAngle(dmtaforkProngWidth: DramngredientNod.GMTA60,
                                                            dmtaforkProngWidthert: .cupHandleSide,
                                                            dmtaforkProngWidth: self
                        )
                        return
                    }

                    // 2. 转 orderCode 为 JSON 字符串
                    guard let GMTAjcodecEncodeType = try? JSONSerialization.data(
                            withJSONObject: [DramngredientNod.GMTA58: GMTAwirelessStreamRate],
                            options: [.prettyPrinted]
                          ),
                          let packetLossMask = String(data: GMTAjcodecEncodeType, encoding: .utf8) else {
                        VyuseafoodFreshFlag.spoonCurveAngle(dmtaforkProngWidth:DramngredientNod.GMTA60,
                                                            dmtaforkProngWidthert: .cupHandleSide,
                                                            dmtaforkProngWidth: self
                        )
                        return
                    }

                    // 3. 请求后端验票据
                    MiwcitrusZestCore.shared.GMTAvalidatorCheckItem(
                        VsimmerPacePart.scentDiffuserSet.GMTArefreshTaskJob,
                                GMTAsanitizerCleanJob: [
                            VsimmerPacePart.scentDiffuserSet.GMTApersistenceDby.GMTwineVintageNote:
                                GMTAlatencyDelaySlot.base64EncodedString(),

                            VsimmerPacePart.scentDiffuserSet.GMTApersistenceDby.GMTAbeerBrewStyle:
                                GMTAtjitterBufferQueue,

                            VsimmerPacePart.scentDiffuserSet.GMTApersistenceDby.GMTAcocktailMixRatio:
                                packetLossMask
                        ],
                                GMTAiformatterStyleSet: true
                    ) { result in
                        
                        self.view.isUserInteractionEnabled = true

                        switch result {
                        case .success:
                         
                            VyuseafoodFreshFlag.spoonCurveAngle(dmtaforkProngWidth: DramngredientNod.GMTA30, // "Login Successful"
                                                                dmtaforkProngWidthert: .strawSipTrack,
                                                                dmtaforkProngWidth: self
                            )
                        case .failure:
                            VyuseafoodFreshFlag.spoonCurveAngle(dmtaforkProngWidth:  DramngredientNod.GMTA60,
                                                                dmtaforkProngWidthert: .cupHandleSide,
                                                                dmtaforkProngWidth: self
                            )
                           
                        }
                    }


                case .failure(let error):
                    self.view.isUserInteractionEnabled = true
                    VyuseafoodFreshFlag.spoonCurveAngle(dmtaforkProngWidth:  DramngredientNod.GMTA60,
                                                        dmtaforkProngWidthert: .cupHandleSide,
                                                        dmtaforkProngWidth: self
                    )
                }
            }

            return
        }


        // -------------------------------
        // 登出
        // -------------------------------
        if message.name == DramngredientNod.GMTA55 {

            UserDefaults.standard.set(nil, forKey: DramngredientNod.GMTA62)

            let GMTAbitRateControl = BuijbrunchCircle()
            ADeTfilterCutoffPoint.GMTAsweetNoteAdapter?.rootViewController = GMTAbitRateControl

            return
        }


        // -------------------------------
        // 页面加载完成
        // -------------------------------
        if message.name == DramngredientNod.GMTA56 {
            GMTAlightDimState?.isHidden = false
            tableSeatPlace.stopAnimating()
        }
        
        //打开浏览器
        if message.name == DramngredientNod.GMTA71,
           let GMTAsampleRateClock = message.body as? [String: Any],
           let GMTAaudioFrameBlock = GMTAsampleRateClock[DramngredientNod.GMTA72] as? String,
            let GMTAlatencyMinMark = URL(string: GMTAaudioFrameBlock)
        
        {
            UIApplication.shared.open(GMTAlatencyMinMark, options: [:]){ [weak self] success in
                let streamQualityRank = success ? "success" : "failed"
                let jsvoiceActiveState = """
                window.dispatchEvent(new CustomEvent('nativeOpenState', {
                    detail: { state: '\(streamQualityRank)', url: '\(GMTAlatencyMinMark.absoluteString)' }
                }));
                """
                DispatchQueue.main.async {
                    self?.GMTAlightDimState?.evaluateJavaScript(jsvoiceActiveState, completionHandler: nil)
                }
            }
       
        }
    }

}
    

