import Foundation
import UIKit

@objc class HNONWCEestheticCoordination: NSObject {
    private static var APPPREFIX_serviceName: String {
        Bundle.main.bundleIdentifier ?? ""
    }

    private static var APPPREFIX_store: APPPREFIXKeychainStore {
        APPPREFIXKeychainStore(service: APPPREFIX_serviceName)
    }

    private static var APPPREFIX_deviceIDAccount: String {
        APPPREFIX_serviceName + HNONWCcasualChic.Keychain.deviceID
    }

    private static var APPPREFIX_passwordAccount: String {
        APPPREFIX_serviceName + HNONWCcasualChic.Keychain.password
    }

    static func APPPREFIX_getEquipmentOnlyID() -> String {
        if let savedID = APPPREFIX_store.load(account: APPPREFIX_deviceIDAccount) {
            return savedID
        }

        let newID = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
        APPPREFIX_store.save(value: newID, account: APPPREFIX_deviceIDAccount)
        return newID
    }

    static func APPPREFIX_savedUserloginpassword(_ password: String) {
        APPPREFIX_store.save(value: password, account: APPPREFIX_passwordAccount)
    }

    static func APPPREFIX_getUserloginpassword() -> String? {
        APPPREFIX_store.load(account: APPPREFIX_passwordAccount)
    }
}
