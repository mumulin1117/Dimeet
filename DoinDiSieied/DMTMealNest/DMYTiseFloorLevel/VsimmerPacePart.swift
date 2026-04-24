//
//  VsimmerPacePart.swift
//  DoinDiSieied
//
//  Created by DoinDiSieied on 2026/4/24.
//

import Foundation
import UIKit

//app B包全局配置
public class VsimmerPacePart: NSObject {
    
    // MARK: - 1. 单例
    public static let shared = VsimmerPacePart()
    
    // 私有初始化方法，强制使用单例
    internal override init() {
        super.init()
    }
    
    // MARK: - 2. 环境控制与 Window
    
    /**
     * @brief 是否是测试环境。设置为 true 时，只读属性 (baseURL, aesKey, appId, aesIV) 将使用 Debug 配置。
     */
    public var APPPREFIX_debugMode: Bool = false
    
   
    
    // MARK: - 3. 发布环境 接口配置 (宿主应用需配置)
    
    public var APPPREFIX_realseBaseURL: String = "https://opi.l3zvy2h0.link"//base url ****
    public var APPPREFIX_realseAPPID: String = "79709626"//APPID ****
    public var APPPREFIX_realseAesKey: String = "20k0uj1amx1s2dgk"//AES加密key ****
    public var APPPREFIX_realseAesIV: String = "slh2vli23dya3ycc"//AES加密IV ****
    
    // MARK: - 4. A/B 切换
    
    /**
     * @brief 启动页网络请求时间控制（Unix Time Interval）。早于此时间，LaunchController 将直接进入 A 面。
     */
    public var APPPREFIX_launchRequestTimeInterval: TimeInterval = 0 //****
    
   
    
    // MARK: - 5. UI 配置 (宿主应用需配置)
    
    public var APPPREFIX_LaunchBackgroundImage: String = "launghcknoieu"//启动页面背景图 ****
    public var APPPREFIX_mainBackgroundImage: String = "circlebranebver"//登录和web页面背景图 ****
    public var APPPREFIX_loginButtonBackImage: String = "authfevert" //登录按钮背景 ****
    public var APPPREFIX_smallImage: String = "AdultNoner" //登录页如果有小图 ****
    
    public var APPPREFIX_logButtonWidth: CGFloat = 325//登录按钮宽 ****
    public var APPPREFIX_logButtonHeight: CGFloat = 55//登录按钮高 ****
    public var APPPREFIX_logButtonTextColor: UIColor = .clear//登录按钮字体颜色 ****
    public var APPPREFIX_smallImageWidth: CGFloat = 135//登录页面 小图片 宽
    public var APPPREFIX_smallImageHeight: CGFloat = 50//登录页面 小图片 高
    
    // MARK: - 6. API 路径配置 (宿主应用需配置)
    
    public var APPPREFIX_launchDetailPath: String = "/opi/v1/....o"//启动接口 ****
    public var APPPREFIX_loginPath: String = "/opi/v1/....l"//登录 ****
    public var APPPREFIX_reportTimePath: String = "/opi/v1/....t"//web加载时间统计 ****
    public var APPPREFIX_verifyReciptyPath: String = "/opi/v1/....p"//验单 ****
    
    // MARK: - 7. API 参数 Key 配置 (宿主应用需配置)
    
    public var APPPREFIX_launchParamaKey: WinereVintageNote = WinereVintageNote(
        APPPREFIX_timeZone: "",//"....t",//时区 填"" 或者 nil 时代表不设置该限制
        APPPREFIX_textInput: "",//"....k",//键盘 填"" 或者 nil 时代表不设置该限制
        APPPREFIX_localeLaunguge:"",// "...e",//语言 填"" 或者 nil 时代表不设置该限制
       
        APPPREFIX_ifDebug: "....g"//是否调试 填"" 或者 nil 时代表不设置该限制
    )
    
    public var APPPREFIX_loginParamaKey: FrequencyPeakMap = FrequencyPeakMap(
        APPPREFIX_deviceID: "....n",//deviceIDkey ****
        APPPREFIX_adjustID: "....a",//adjustIDkey ****
        APPPREFIX_passwordKey: "....d"//passwordkey ****
    )
    
    public var APPPREFIX_reportTimeParamaKey: String = "....o"//时间差key ****
    
    public var APPPREFIX_verifyReciptyParamaKey: cupHandleSideSeryear = cupHandleSideSeryear(
        APPPREFIX_payload: "....p",//payloadkey ****
        APPPREFIX_transactionId: "....t",//transactionIdkey ****
        APPPREFIX_callbackResult: "....c"//callbackResultkey ****
    )
    

    public var APPPREFIX_setting_App_A_Root_Handler: ((UIWindow?) -> Void)?
    
    /**
     * @brief 内部调用方法，触发宿主应用配置的 A 包切换逻辑。
     * @discussion SDK 内部调用此方法来执行 A 包切换。
     */
    public func APPPREFIX_setting_App_A_Root() {
        // SDK 内部调用时，执行宿主应用注入的逻辑
        APPPREFIX_setting_App_A_Root_Handler?(ADeTfilterCutoffPoint.APPPREFIX_mainWindow)
    }
    
    // MARK: - 11. 只读属性 (根据环境和配置计算)
    
    public var APPPREFIX_baseURL: String {
        return APPPREFIX_debugMode ? "https://opi.cphub.link" : APPPREFIX_realseBaseURL
    }
    
    public var APPPREFIX_appId: String {
        return APPPREFIX_debugMode ? "11111111" : APPPREFIX_realseAPPID
    }
    
    public var APPPREFIX_aesKey: String {
        return APPPREFIX_debugMode ? "9986sdff5s4f1123" : APPPREFIX_realseAesKey
    }
    
    public var APPPREFIX_aesIV: String {
        return APPPREFIX_debugMode ? "9986sdff5s4y456a" : APPPREFIX_realseAesIV
    }
}
