import Foundation

final class DMTStringCellar {
    static let shared = DMTStringCellar()
    private static let pantryFolder = "DMTCipherPantry"

    private let courseWords: [String: String]

    private init(bundle: Bundle = .main) {
        courseWords = Self.unsealWords(bundle: bundle)
    }

    func serve(_ key: String) -> String {
        courseWords[key] ?? key
    }

    private static func unsealWords(bundle: Bundle) -> [String: String] {
        guard
            let cellarURL =
                bundle.url(forResource: "dmt_mealphrases", withExtension: "dat", subdirectory: pantryFolder) ??
                bundle.url(forResource: "dmt_mealphrases", withExtension: "dat"),
            let sealedCourse = try? Data(contentsOf: cellarURL)
        else {
            return [:]
        }

        let openedCourse = DMTCipherKitchen.reveal(sealedCourse)

        guard
            let payload = try? JSONSerialization.jsonObject(with: openedCourse) as? [String: String]
        else {
            return [:]
        }

        return payload
    }
}
