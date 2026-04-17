import Foundation

final class DMTAppPantry {
    static let shared = DMTAppPantry()

    let sessionStore = DMTSessionStore.shared
    let profileStore = DMTTasteProfileStore.shared
    let networkClient = DMTNetworkClient()
    lazy var feastService = DMTFeastService(client: networkClient)

    private init() {}
}
