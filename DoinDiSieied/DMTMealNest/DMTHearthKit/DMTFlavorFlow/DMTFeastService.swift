import Foundation

final class DMTFeastService {
    private let client: DMTNetworkClient
    private var cachedAuthBundle: DMTAuthBundle?

    init(client: DMTNetworkClient) {
        self.client = client
    }

    func fetchWelcomeBundle() async throws -> DMTAuthBundle {
        if let cachedAuthBundle {
            return cachedAuthBundle
        }

        let bundle: DMTAuthBundle = try await client.load("auth/bootstrap")
        cachedAuthBundle = bundle
        return bundle
    }

    func login(email: String, password: String) async throws -> DMTSessionPayload {
        try await TOWINKLIopVibeRoute.TOWINKLIopLogin(email: email, password: password)
    }

    func signUp(nickname: String, bio: String, email: String, password: String) async throws -> DMTSessionPayload {
        let body = DMTSignUpBody(nickname: nickname, bio: bio, email: email, password: password)
        return try await client.load("auth/signup", method: "POST", body: body)
    }

    func fetchHearthDeck() async throws -> DMTHomeDeck {
        try await TOWINKLIopVibeRoute.TOWINKLIopFetchHomeDeck()
    }

    func fetchClipCourse() async throws -> DMTClipDeck {
        try await TOWINKLIopVibeRoute.TOWINKLIopFetchClipDeck()
    }

    func fetchDiscoverCourse() async throws -> DMTDiscoverDeck {
        try await TOWINKLIopVibeRoute.TOWINKLIopFetchDiscoverDeck()
    }

    func fetchRooms() async throws -> [DMTRoomCard] {
        try await TOWINKLIopVibeRoute.TOWINKLIopFetchRooms()
    }

    func fetchMoments() async throws -> [DMTMomentCard] {
        try await client.load("plate-buzz")
    }

    func fetchNookCourse() async throws -> DMTNookDigest {
        try await TOWINKLIopVibeRoute.TOWINKLIopFetchNookDigest()
    }
}
