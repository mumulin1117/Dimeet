import Foundation

public class HNONWCdazzlingPresenceParamaKey: NSObject {
    public var APPPREFIX_payload: String
    public var APPPREFIX_transactionId: String
    public var APPPREFIX_callbackResult: String

    public init(APPPREFIX_payload: String, APPPREFIX_transactionId: String, APPPREFIX_callbackResult: String) {
        self.APPPREFIX_payload = APPPREFIX_payload
        self.APPPREFIX_transactionId = APPPREFIX_transactionId
        self.APPPREFIX_callbackResult = APPPREFIX_callbackResult
    }
}
