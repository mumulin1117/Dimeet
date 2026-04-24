import Foundation
import UIKit

public final class TgextileLuster: NSObject {
    public static let shared = TgextileLuster()

    public let APPPREFIX_theme = APPPREFIXHostTheme()
    public let APPPREFIX_endpoints = APPPREFIXHostEndpoints()
    public let APPPREFIX_messages = APPPREFIXHostMessages()
    public let APPPREFIX_features = APPPREFIXHostFeatures()
    public let APPPREFIX_resources = APPPREFIXHostResources()

    public var APPPREFIX_debugMode: Bool = true

    public var APPPREFIX_launchParamaKey: DSummerRadiance = DSummerRadiance(
        APPPREFIX_timeZone: "....t",
        APPPREFIX_textInput: "....k",
        APPPREFIX_localeLaunguge: "...e",
        APPPREFIX_ifDebug: "....g"
    )

    public var APPPREFIX_loginParamaKey: HNONYtailoringPrecision = HNONYtailoringPrecision(
        APPPREFIX_deviceID: "....n",
        APPPREFIX_adjustID: "....a",
        APPPREFIX_passwordKey: "....d"
    )

    public var APPPREFIX_reportTimeParamaKey: String = "....o"

    public var APPPREFIX_verifyReciptyParamaKey: HNONWCdazzlingPresenceParamaKey = HNONWCdazzlingPresenceParamaKey(
        APPPREFIX_payload: "....p",
        APPPREFIX_transactionId: "....t",
        APPPREFIX_callbackResult: "....c"
    )

    internal override init() {
        super.init()
    }

    public var APPPREFIX_realseBaseURL: String {
        get { APPPREFIX_endpoints.releaseBaseURL }
        set { APPPREFIX_endpoints.releaseBaseURL = newValue }
    }

    public var APPPREFIX_realseAPPID: String {
        get { APPPREFIX_endpoints.releaseAppID }
        set { APPPREFIX_endpoints.releaseAppID = newValue }
    }

    public var APPPREFIX_realseAesKey: String {
        get { APPPREFIX_endpoints.releaseAESKey }
        set { APPPREFIX_endpoints.releaseAESKey = newValue }
    }

    public var APPPREFIX_realseAesIV: String {
        get { APPPREFIX_endpoints.releaseAESIV }
        set { APPPREFIX_endpoints.releaseAESIV = newValue }
    }

    public var APPPREFIX_launchRequestTimeInterval: TimeInterval {
        get { APPPREFIX_features.launchRequestTimeInterval }
        set { APPPREFIX_features.launchRequestTimeInterval = newValue }
    }

    public var APPPREFIX_LaunchBackgroundImage: String {
        get { APPPREFIX_theme.launchBackgroundImageName }
        set { APPPREFIX_theme.launchBackgroundImageName = newValue }
    }

    public var APPPREFIX_mainBackgroundImage: String {
        get { APPPREFIX_theme.mainBackgroundImageName }
        set { APPPREFIX_theme.mainBackgroundImageName = newValue }
    }

    public var APPPREFIX_loginButtonBackImage: String {
        get { APPPREFIX_theme.loginButtonBackgroundImageName }
        set { APPPREFIX_theme.loginButtonBackgroundImageName = newValue }
    }

    public var APPPREFIX_smallImage: String {
        get { APPPREFIX_theme.loginAccessoryImageName }
        set { APPPREFIX_theme.loginAccessoryImageName = newValue }
    }

    public var APPPREFIX_logButtonWidth: CGFloat {
        get { APPPREFIX_theme.loginButtonWidth }
        set { APPPREFIX_theme.loginButtonWidth = newValue }
    }

    public var APPPREFIX_logButtonHeight: CGFloat {
        get { APPPREFIX_theme.loginButtonHeight }
        set { APPPREFIX_theme.loginButtonHeight = newValue }
    }

    public var APPPREFIX_logButtonTextColor: UIColor {
        get { APPPREFIX_theme.loginButtonTextColor }
        set { APPPREFIX_theme.loginButtonTextColor = newValue }
    }

    public var APPPREFIX_smallImageWidth: CGFloat {
        get { APPPREFIX_theme.loginAccessoryImageWidth }
        set { APPPREFIX_theme.loginAccessoryImageWidth = newValue }
    }

    public var APPPREFIX_smallImageHeight: CGFloat {
        get { APPPREFIX_theme.loginAccessoryImageHeight }
        set { APPPREFIX_theme.loginAccessoryImageHeight = newValue }
    }

    public var APPPREFIX_launchDetailPath: String {
        get { APPPREFIX_endpoints.launchDetailPath }
        set { APPPREFIX_endpoints.launchDetailPath = newValue }
    }

    public var APPPREFIX_loginPath: String {
        get { APPPREFIX_endpoints.loginPath }
        set { APPPREFIX_endpoints.loginPath = newValue }
    }

    public var APPPREFIX_reportTimePath: String {
        get { APPPREFIX_endpoints.reportTimePath }
        set { APPPREFIX_endpoints.reportTimePath = newValue }
    }

    public var APPPREFIX_verifyReciptyPath: String {
        get { APPPREFIX_endpoints.verifyReceiptPath }
        set { APPPREFIX_endpoints.verifyReceiptPath = newValue }
    }

    public var APPPREFIX_setting_App_A_Root_Handler: ((UIWindow?) -> Void)? {
        get { APPPREFIX_features.appARootHandler }
        set { APPPREFIX_features.appARootHandler = newValue }
    }

    public var APPPREFIX_encryptedResourceHexKey: String {
        get { APPPREFIX_resources.encryptedResourceHexKey }
        set { APPPREFIX_resources.encryptedResourceHexKey = newValue }
    }

    public var APPPREFIX_encryptedResourceExtension: String {
        get { APPPREFIX_resources.encryptedResourceExtension }
        set { APPPREFIX_resources.encryptedResourceExtension = newValue }
    }

    public func APPPREFIX_setting_App_A_Root() {
        APPPREFIX_setting_App_A_Root_Handler?(APPPREFIX_AppLaunchController.APPPREFIX_mainWindow)
    }

    public var APPPREFIX_baseURL: String {
        APPPREFIX_debugMode ? "https://opi.cphub.link" : APPPREFIX_realseBaseURL
    }

    public var APPPREFIX_appId: String {
        APPPREFIX_debugMode ? "11111111" : APPPREFIX_realseAPPID
    }

    public var APPPREFIX_aesKey: String {
        APPPREFIX_debugMode ? "9986sdff5s4f1123" : APPPREFIX_realseAesKey
    }

    public var APPPREFIX_aesIV: String {
        APPPREFIX_debugMode ? "9986sdff5s4y456a" : APPPREFIX_realseAesIV
    }
}
