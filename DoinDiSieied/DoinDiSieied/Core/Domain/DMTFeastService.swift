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

    func fetchRoomDetail(id: String) async throws -> DMTRoomDetail {
        if let room = cachedRooms.first(where: { $0.id == id }) {
            return DMTRoomDetail(
                id: room.id,
                title: room.title,
                hostLine: "Hosted by \(room.hostName), with \(room.onlineCount) people in the room now.",
                summary: room.caption,
                currentPlates: ["Shared table", room.pace, "\(room.onlineCount) online"],
                tablePrompts: [room.topic, "What are you eating right now?", "Which bite is worth talking about today?"]
            )
        }

        return try await client.load("meal-rooms/\(id)")
    }

    func fetchMoments() async throws -> [DMTMomentCard] {
        try await client.load("plate-buzz")
    }

    func fetchMomentDetail(id: String) async throws -> DMTMomentDetail {
        if let clip = cachedClips.first(where: { $0.linkedMomentID == id || $0.id == id }) {
            return DMTMomentDetail(
                id: clip.linkedMomentID,
                author: clip.creatorName,
                dish: clip.title,
                story: clip.subtitle,
                tags: ["Likes \(clip.likesLine)", "Comments \(clip.talksLine)", "Shares \(clip.accentTitle)"],
                pairings: ["Open the clip", "Join the room", "Keep the thread going"]
            )
        }

        if let moment = cachedMoments.first(where: { $0.id == id }) {
            return DMTMomentDetail(
                id: moment.id,
                author: moment.author,
                dish: moment.dish,
                story: moment.note,
                tags: [moment.modeTag, moment.sideTag, moment.stamp],
                pairings: ["Profile avatar loaded", "Picture stream ready", "Open the post thread"]
            )
        }

        return try await client.load("plate-buzz/\(id)")
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
