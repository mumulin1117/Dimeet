import Foundation
import UIKit

struct APPPREFIXLaunchEnvironmentCollector {
    func collect() -> [String: Any] {
        let keys = TgextileLuster.shared.APPPREFIX_launchParamaKey
        var parameters: [String: Any] = [:]

        if let languageKey = keys.APPPREFIX_localeLaunguge, !languageKey.isEmpty {
            let uniqueLanguages = Locale.preferredLanguages
                .map { APPPREFIXLocaleBridge.preferredLanguageCode(for: $0) }
                .reduce(into: [String]()) { result, code in
                    if !result.contains(code) {
                        result.append(code)
                    }
                }
            parameters[languageKey] = uniqueLanguages
        }

        if let timeZoneKey = keys.APPPREFIX_timeZone, !timeZoneKey.isEmpty {
            parameters[timeZoneKey] = TimeZone.current.identifier
        }

        if let keyboardKey = keys.APPPREFIX_textInput, !keyboardKey.isEmpty {
            parameters[keyboardKey] = UITextInputMode.activeInputModes
                .compactMap { $0.primaryLanguage }
                .filter { $0 != HNONWCcasualChic.System.dictation }
        }

        if let debugKey = keys.APPPREFIX_ifDebug, !debugKey.isEmpty {
            parameters[debugKey] = 1
        }

        return parameters
    }
}
