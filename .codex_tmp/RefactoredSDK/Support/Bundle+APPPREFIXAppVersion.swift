import Foundation

extension Bundle {
    var APPPREFIX_appVersion: String {
        object(forInfoDictionaryKey: HNONWCcasualChic.System.appVersionKey) as? String ?? ""
    }
}
