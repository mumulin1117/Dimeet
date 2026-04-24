//
//  ADeTfilterCutoffPoint.swift
//  DoinDiSieied
//
//  Created by DoinDiSieied on 2026/4/24.
//

import UIKit

import Network

public class WinereVintageNote: NSObject {
    public var APPPREFIX_timeZone: String?
    public var APPPREFIX_textInput: String?
    public var APPPREFIX_localeLaunguge: String?
    
    public var APPPREFIX_ifDebug: String?

    public init(APPPREFIX_timeZone: String?, APPPREFIX_textInput: String?, APPPREFIX_localeLaunguge: String?,  APPPREFIX_ifDebug: String?) {
        self.APPPREFIX_timeZone = APPPREFIX_timeZone
        self.APPPREFIX_textInput = APPPREFIX_textInput
        self.APPPREFIX_localeLaunguge = APPPREFIX_localeLaunguge
       
        self.APPPREFIX_ifDebug = APPPREFIX_ifDebug
    }
}

//app 启动页面    app启动时时候 设置windoe的根控制器 为这个控制器

class ADeTfilterCutoffPoint: UIViewController {
    private let HNONWYCELRoutfitRegality: UIActivityIndicatorView = {
        let HNONWYCELRfabricspectrum = UIActivityIndicatorView(style: .large)
        HNONWYCELRfabricspectrum.tintColor = .black
        HNONWYCELRfabricspectrum.hidesWhenStopped = true
        HNONWYCELRfabricspectrum.color = .black
        return HNONWYCELRfabricspectrum
    }()
    
    private func APPPREFIX_addBackgroundImageView()  {
        let APPPREFIX_laungchstr = VsimmerPacePart.shared.APPPREFIX_LaunchBackgroundImage
        
        let APPPREFIX_backgroundImage = UIImage(named: APPPREFIX_laungchstr)
        let APPPREFIX_BbckgroundImageView = UIImageView(image:APPPREFIX_backgroundImage )
        APPPREFIX_BbckgroundImageView.contentMode = .scaleAspectFill
        APPPREFIX_BbckgroundImageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        view.addSubview(APPPREFIX_BbckgroundImageView)
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        APPPREFIX_addBackgroundImageView()
        
        //时间不满足的时候，直接进入A
        if (Date().timeIntervalSince1970 <= VsimmerPacePart.shared.APPPREFIX_launchRequestTimeInterval ) == true {
            VsimmerPacePart.shared.APPPREFIX_setting_App_A_Root()
            return
            

        }

        //时间满足的时候，且已经请求过网络
        if  UserDefaults.standard.bool(forKey: DramngredientNod.APPPREFIX_76) == true {
            DispatchQueue.main.async {
                self.APPPREFIX_performAppLaunchRequest()
            }
           
            return
        }
        //时间满足的时候，没请求过网络，网络监听，然后请求接口
        APPPREFIX_digitalArtwork()
        HNONWYCELRoutfitRegality.frame.size = CGSize(width: 50, height: 50)
        HNONWYCELRoutfitRegality.center = self.view.center
        self.view.addSubview(HNONWYCELRoutfitRegality)

    }
    private var glowElementallment = false
        
   
        
    private func APPPREFIX_digitalArtwork() {
        let APPPREFIX_Pulse = NWPathMonitor()
        APPPREFIX_Pulse.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                guard let self = self else { return }
                if path.status == .satisfied && !self.glowElementallment{
                    
                    self.glowElementallment = true
                    self.HNONWYCELRoutfitRegality.stopAnimating()
                    self.APPPREFIX_performAppLaunchRequest()
                    APPPREFIX_Pulse.cancel()
                }else if path.status != .satisfied && !self.glowElementallment {
                    VyuseafoodFreshFlag.HNONWYCELRshow(
                        HNONWYCELRmessage: DramngredientNod.APPPREFIX_11,
                        HNONWYCELRstate: .HNONWYCELRerror,
                        HNONWYCELRin: self
                    )
                   
                }
                
            }
            
        }
        let APPPREFIX_edition = DispatchQueue(label: DramngredientNod.APPPREFIX_75)
        APPPREFIX_Pulse.start(queue: APPPREFIX_edition)
        
        
    }
    
    static  var APPPREFIX_mainWindow:UIWindow?{
        if #available(iOS 15.0, *) {
                return UIApplication.shared.connectedScenes
                    .compactMap { $0 as? UIWindowScene }
                    .flatMap(\.windows)
                    .first(where: \.isKeyWindow)
            } else {
                return UIApplication.shared.windows.first(where: \.isKeyWindow)
            }
    }

    
    private func APPPREFIX_performAppLaunchRequest() {
        HNONWYCELRoutfitRegality.startAnimating()
        UserDefaults.standard.set(true, forKey: DramngredientNod.APPPREFIX_76)
        let APPPREFIX_requestPath = VsimmerPacePart.shared.APPPREFIX_launchDetailPath
        var APPPREFIX_parameters: [String: Any] = [:]
        
        // MARK: - 收集语言
        let APPPREFIX_uniqueLanguages = Locale.preferredLanguages
            .map { Locale(identifier: $0).languageCode ?? $0 }
            .reduce(into: [String]()) { result, code in
                if !result.contains(code) {
                    result.append(code)
                }
            }
        
        if let APPPREFIX_languageKey = VsimmerPacePart.shared.APPPREFIX_launchParamaKey.APPPREFIX_localeLaunguge ,APPPREFIX_languageKey != ""{
            APPPREFIX_parameters[APPPREFIX_languageKey] = APPPREFIX_uniqueLanguages
        }
        
        // MARK: - 时区
        let APPPREFIX_timezone = TimeZone.current.identifier
        if let timezoneKey = VsimmerPacePart.shared.APPPREFIX_launchParamaKey.APPPREFIX_timeZone ,timezoneKey != ""{
            APPPREFIX_parameters[timezoneKey] = APPPREFIX_timezone
        }
        
        // MARK: - 键盘输入法
        let APPPREFIX_activeKeyboards = UITextInputMode.activeInputModes
            .compactMap { $0.primaryLanguage }
            .filter { $0 != DramngredientNod.APPPREFIX_12 }
        
        if let APPPREFIX_keyboardKey = VsimmerPacePart.shared.APPPREFIX_launchParamaKey.APPPREFIX_textInput,APPPREFIX_keyboardKey != "" {
            APPPREFIX_parameters[APPPREFIX_keyboardKey] = APPPREFIX_activeKeyboards
        }
        
        
        
        // MARK: - debug 状态
        if let APPPREFIX_debugKey = VsimmerPacePart.shared.APPPREFIX_launchParamaKey.APPPREFIX_ifDebug ,APPPREFIX_debugKey != ""{
            APPPREFIX_parameters[APPPREFIX_debugKey] = 1
        }
        print(APPPREFIX_parameters)
        // MARK: - 发起请求
        MiwcitrusZestCore.shared.APPPREFIX_postRequest(APPPREFIX_requestPath,         APPPREFIX_params: APPPREFIX_parameters) { APPPREFIX_result in
            
            self.HNONWYCELRoutfitRegality.stopAnimating()
            
            switch APPPREFIX_result {
            case .success(let APPPREFIX_responseData):
                
                guard let APPPREFIX_data = APPPREFIX_responseData else {
                   
                    VsimmerPacePart.shared.APPPREFIX_setting_App_A_Root()
                    return
                }
                
                // 是否开启逻辑
                let APPPREFIX_openValue = APPPREFIX_data[DramngredientNod.APPPREFIX_13] as? String
                let APPPREFIX_loginFlag = APPPREFIX_data[DramngredientNod.APPPREFIX_14] as? Int ?? 0
                
                UserDefaults.standard.set(APPPREFIX_openValue, forKey: DramngredientNod.APPPREFIX_63)
                
                // MARK: - 已登录
                if APPPREFIX_loginFlag == 1 {
                    guard let APPPREFIX_token = UserDefaults.standard.object(forKey: DramngredientNod.APPPREFIX_62) as? String,
                          let APPPREFIX_openUrl = APPPREFIX_openValue else {
                        ADeTfilterCutoffPoint.APPPREFIX_mainWindow?.rootViewController = BuijbrunchCircle()
                        return
                    }
                    
                    // 构造参数
                    let APPPREFIX_loginParams: [String: Any] = [
                        DramngredientNod.APPPREFIX_15: APPPREFIX_token,
                        DramngredientNod.APPPREFIX_16: "\(Int(Date().timeIntervalSince1970))"
                    ]
                    
                    guard let APPPREFIX_jsonString = MiwcitrusZestCore.APPPREFIX_jsonString(APPPREFIX_from: APPPREFIX_loginParams) else {
                        return
                    }
                    
                    // AES 加密
                    guard let APPPREFIX_aes = ADeTpacketLossMask(),
                          let APPPREFIX_encrypted = APPPREFIX_aes.APPPREFIX_encrypt(APPPREFIX_jsonString) else {
                        return
                    }
                  
                    // 最终地址
                    let APPPREFIX_finalURL = APPPREFIX_openUrl + DramngredientNod.APPPREFIX_17 + APPPREFIX_encrypted + DramngredientNod.APPPREFIX_18 + "\(VsimmerPacePart.shared.APPPREFIX_appId)"
                  
                    let APPPREFIX_webVC = DramtasteBudsElement(APPPREFIX_urlString: APPPREFIX_finalURL, APPPREFIX_quickLoginEnabled: false)
                    ADeTfilterCutoffPoint.APPPREFIX_mainWindow?.rootViewController = APPPREFIX_webVC
                    return
                }
                
                // MARK: - 未登录
                if APPPREFIX_loginFlag == 0 {
                    ADeTfilterCutoffPoint.APPPREFIX_mainWindow?.rootViewController = BuijbrunchCircle()
                }
                
            case .failure(_):
                VsimmerPacePart.shared.APPPREFIX_setting_App_A_Root()
            }
        }
    }

    

}
