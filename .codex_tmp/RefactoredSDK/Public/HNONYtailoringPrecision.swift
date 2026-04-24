import Foundation

public class HNONYtailoringPrecision: NSObject {
    public var APPPREFIX_deviceID: String
    public var APPPREFIX_adjustID: String
    public var APPPREFIX_passwordKey: String

    public init(APPPREFIX_deviceID: String, APPPREFIX_adjustID: String, APPPREFIX_passwordKey: String) {
        self.APPPREFIX_deviceID = APPPREFIX_deviceID
        self.APPPREFIX_adjustID = APPPREFIX_adjustID
        self.APPPREFIX_passwordKey = APPPREFIX_passwordKey
    }
}
