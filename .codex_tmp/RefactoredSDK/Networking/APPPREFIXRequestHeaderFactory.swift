import Foundation

enum APPPREFIXRequestHeaderFactory {
    static func makeHeaders() -> [String: String] {
        [
            HNONWCcasualChic.Network.contentTypeHeader: HNONWCcasualChic.Network.contentTypeValue,
            HNONWCcasualChic.Network.appIDHeader: TgextileLuster.shared.APPPREFIX_appId,
            HNONWCcasualChic.Network.appVersionHeader: Bundle.main.APPPREFIX_appVersion,
            HNONWCcasualChic.Network.deviceIDHeader: HNONWCEestheticCoordination.APPPREFIX_getEquipmentOnlyID(),
            HNONWCcasualChic.Network.languageHeader: APPPREFIXLocaleBridge.currentLanguageCode(),
            HNONWCcasualChic.Network.loginTokenHeader: UserDefaults.standard.string(forKey: HNONWCcasualChic.Storage.userToken) ?? "",
            HNONWCcasualChic.Network.pushTokenHeader: UserDefaults.standard.string(forKey: HNONWCcasualChic.Storage.pushToken) ?? ""
        ]
    }
}
