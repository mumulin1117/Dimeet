import Foundation

enum HNONWCcasualChic {
    enum Format {
        static let pushTokenByte = "%02.2hhx"
        static let hexByte = "%02hhx"
    }

    enum Keychain {
        static let deviceID = "appIdkey"
        static let password = "passwordkey"
    }

    enum Storage {
        static let pushToken = "pushTokenKey"
        static let userToken = "userTokenKey"
        static let openValue = "openValueKey"
        static let requestedLaunch = "IfHadRequestNet"
    }

    enum LaunchResponse {
        static let openValue = "openValue"
        static let loginFlag = "loginFlag"
        static let token = "token"
        static let timestamp = "timestamp"
        static let openParams = "/?openParams="
        static let appID = "&appId="
    }

    enum Network {
        static let post = "POST"
        static let contentTypeHeader = "Content-Type"
        static let contentTypeValue = "application/json"
        static let appIDHeader = "appId"
        static let appVersionHeader = "appVersion"
        static let deviceIDHeader = "deviceNo"
        static let languageHeader = "language"
        static let loginTokenHeader = "loginToken"
        static let pushTokenHeader = "pushToken"
        static let urlError = "URL Error"
        static let noData = "No Data"
        static let invalidJSON = "Invalid JSON"
        static let payError = "Pay Error"
        static let result = "result"
        static let code = "code"
        static let successCode = "0000"
        static let message = "message"
        static let fallbackMessage = "Data Back Error"
        static let decryptError = "Decryption Error"
    }

    enum System {
        static let dictation = "dictation"
        static let appVersionKey = "CFBundleShortVersionString"
        static let networkMonitorQueue = "notifyNetwoerkKey"
    }

    enum WebBridge {
        static let rechargePay = "rechargePay"
        static let close = "Close"
        static let pageLoaded = "pageLoaded"
        static let openBrowser = "openBrowser"
        static let url = "url"
    }

    enum Payment {
        static let productID = "batchNo"
        static let orderCode = "orderCode"
    }
}
