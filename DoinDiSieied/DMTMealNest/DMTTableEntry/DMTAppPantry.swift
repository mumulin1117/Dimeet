import Foundation

final class DMTAppPantry {
    static let shared = DMTAppPantry()

    let seatSession = DMTSessionStore.shared
    let tasteLedger = DMTTasteProfileStore.shared
    let signalClient = DMTNetworkClient()
    lazy var hearthService = DMTFeastService(client: signalClient)

    private init() {}
}
