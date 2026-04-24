import Foundation

enum APPPREFIXLocaleBridge {
    static func currentLanguageCode() -> String {
        if #available(iOS 16.0, *) {
            return Locale.current.language.languageCode?.identifier ?? ""
        }

        return Locale.current.languageCode ?? ""
    }

    static func preferredLanguageCode(for identifier: String) -> String {
        let locale = Locale(identifier: identifier)
        if #available(iOS 16.0, *) {
            return locale.language.languageCode?.identifier ?? identifier
        }

        return locale.languageCode ?? identifier
    }
}
