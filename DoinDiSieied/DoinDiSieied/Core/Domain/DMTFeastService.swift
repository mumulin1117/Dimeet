import Foundation

final class DMTFeastService {
    private let client: DMTNetworkClient
    private var cachedAuthBundle: DMTAuthBundle?

    init(client: DMTNetworkClient) {
        self.client = client
    }

    func fetchAuthBundle() async throws -> DMTAuthBundle {
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

    func fetchHomeDeck() async throws -> DMTHomeDeck {
        try await client.load("meal-hearth")
    }

    func fetchClipDeck() async throws -> DMTClipDeck {
        try await client.load("taste-clips")
    }

    func fetchDiscoverDeck() async throws -> DMTDiscoverDeck {
        try await client.load("plate-discover")
    }

    func fetchRooms() async throws -> [DMTRoomCard] {
        try await client.load("meal-rooms")
    }

    func fetchRoomDetail(id: String) async throws -> DMTRoomDetail {
        try await client.load("meal-rooms/\(id)")
    }

    func fetchMoments() async throws -> [DMTMomentCard] {
        try await client.load("plate-buzz")
    }

    func fetchMomentDetail(id: String) async throws -> DMTMomentDetail {
        try await client.load("plate-buzz/\(id)")
    }

    func fetchMateDeck() async throws -> DMTMateDeck {
        try await client.load("meal-mate")
    }

    func fetchMateReply(id: String) async throws -> DMTMateReply {
        try await client.load("meal-mate/\(id)")
    }

    func fetchNookDigest() async throws -> DMTNookDigest {
        try await client.load("taste-nook")
    }
}
