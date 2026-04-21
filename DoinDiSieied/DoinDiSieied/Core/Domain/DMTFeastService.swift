import Foundation

final class DMTFeastService {
    private let client: DMTNetworkClient
    private var cachedAuthBundle: DMTAuthBundle?
    private var cachedRooms: [DMTRoomCard] = []
    private var cachedClips: [DMTClipCard] = []
    private var cachedMoments: [DMTMomentCard] = []

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
        let deck = try await TOWINKLIopVibeRoute.TOWINKLIopFetchHomeDeck()
        cachedRooms = deck.rooms
        return deck
    }

    func fetchClipDeck() async throws -> DMTClipDeck {
        let deck = try await TOWINKLIopVibeRoute.TOWINKLIopFetchClipDeck()
        cachedClips = deck.clips
        return deck
    }

    func fetchDiscoverDeck() async throws -> DMTDiscoverDeck {
        let deck = try await TOWINKLIopVibeRoute.TOWINKLIopFetchDiscoverDeck()
        cachedMoments = deck.spotlight
        return deck
    }

    func fetchRooms() async throws -> [DMTRoomCard] {
        let rooms = try await TOWINKLIopVibeRoute.TOWINKLIopFetchRooms()
        cachedRooms = rooms
        return rooms
    }


    func fetchMoments() async throws -> [DMTMomentCard] {
        try await client.load("plate-buzz")
    }



    func fetchMateDeck() async throws -> DMTMateDeck {
        try await client.load("meal-mate")
    }

    func fetchMateReply(id: String) async throws -> DMTMateReply {
        try await client.load("meal-mate/\(id)")
    }

    func fetchNookDigest() async throws -> DMTNookDigest {
        try await TOWINKLIopVibeRoute.TOWINKLIopFetchNookDigest()
    }
}
