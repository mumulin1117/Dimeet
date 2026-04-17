import Foundation

final class DMTSessionStore {
    static let shared = DMTSessionStore()

    var onStateChange: ((Bool) -> Void)?

    private let defaults = UserDefaults.standard
    private let stashKey = "dmt.taste.session"
    private let heritageKey = "towInkLIopHeritageVault"
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()

    private(set) var session: DMTSessionPayload?

    var isSignedIn: Bool {
        session != nil
    }

    private init() {}

    func restoreSession() {
        guard
            let data = defaults.data(forKey: stashKey),
            let payload = try? decoder.decode(DMTSessionPayload.self, from: data)
        else {
            session = nil
            TOWINKLIopVibeRoute.TOWINKLIopSessionToken = nil
            return
        }

        session = payload
        TOWINKLIopVibeRoute.TOWINKLIopSessionToken = payload.token
        if let heritageVault = payload.heritageVault {
            defaults.set(heritageVault, forKey: heritageKey)
        }
    }

    func store(_ payload: DMTSessionPayload) {
        session = payload
        if let data = try? encoder.encode(payload) {
            defaults.set(data, forKey: stashKey)
        }
        TOWINKLIopVibeRoute.TOWINKLIopSessionToken = payload.token
        if let heritageVault = payload.heritageVault {
            defaults.set(heritageVault, forKey: heritageKey)
        }
        onStateChange?(true)
    }

    func clear() {
        session = nil
        defaults.removeObject(forKey: stashKey)
        defaults.removeObject(forKey: heritageKey)
        TOWINKLIopVibeRoute.TOWINKLIopSessionToken = nil
        onStateChange?(false)
    }
}
