import Foundation

public class DSummerRadiance: NSObject {
    public var APPPREFIX_timeZone: String?
    public var APPPREFIX_textInput: String?
    public var APPPREFIX_localeLaunguge: String?
    public var APPPREFIX_ifDebug: String?

    public init(
        APPPREFIX_timeZone: String?,
        APPPREFIX_textInput: String?,
        APPPREFIX_localeLaunguge: String?,
        APPPREFIX_ifDebug: String?
    ) {
        self.APPPREFIX_timeZone = APPPREFIX_timeZone
        self.APPPREFIX_textInput = APPPREFIX_textInput
        self.APPPREFIX_localeLaunguge = APPPREFIX_localeLaunguge
        self.APPPREFIX_ifDebug = APPPREFIX_ifDebug
    }
}
