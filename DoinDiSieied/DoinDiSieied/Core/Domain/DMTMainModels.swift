import Foundation

struct DMTHomeDeck: Codable {
    let brandTitle: String
    let stories: [DMTStoryChip]
    let mateBanner: DMTMateBanner
    let sectionTitle: String
    let rooms: [DMTRoomCard]
    let createRoomTitle: String
}

struct DMTStoryChip: Codable {
    let id: String
    let name: String
    let artKey: String
    let isActive: Bool
}

struct DMTMateBanner: Codable {
    let title: String
    let subtitle: String
    let artKey: String
    let promptID: String
}

struct DMTRoomCard: Codable {
    let id: String
    let title: String
    let topic: String
    let seatLine: String
    let pace: String
    let memberCount: Int
    let hostName: String
    let caption: String
    let onlineCount: Int
    let artKey: String
    let attendeeKeys: [String]
    let trailingAccent: String?
}

struct DMTRoomDetail: Codable {
    let id: String
    let title: String
    let hostLine: String
    let summary: String
    let currentPlates: [String]
    let tablePrompts: [String]
}

struct DMTClipDeck: Codable {
    let primaryTitle: String
    let secondaryTitle: String
    let clips: [DMTClipCard]
}

struct DMTClipCard: Codable {
    let id: String
    let creatorName: String
    let title: String
    let subtitle: String
    let artKey: String
    let avatarKey: String
    let likesLine: String
    let talksLine: String
    let accentTitle: String
    let linkedMomentID: String
}

struct DMTMomentCard: Codable {
    let id: String
    let author: String
    let dish: String
    let note: String
    let stamp: String
    let heatTag: String
    let artKey: String
    let modeTag: String
    let sideTag: String
}

struct DMTMomentDetail: Codable {
    let id: String
    let author: String
    let dish: String
    let story: String
    let tags: [String]
    let pairings: [String]
}

struct DMTMateDeck: Codable {
    let greeting: String
    let intro: String
    let prompts: [DMTMatePrompt]
}

struct DMTMatePrompt: Codable {
    let id: String
    let title: String
    let subtitle: String
    let seed: String
}

struct DMTMateReply: Codable {
    let id: String
    let title: String
    let lead: String
    let replies: [String]
}

struct DMTDiscoverDeck: Codable {
    let title: String
    let primaryTitle: String
    let secondaryTitle: String
    let spotlight: [DMTMomentCard]
    let promo: DMTDiscoverPromo
    let gallery: [DMTDiscoverGalleryCard]
}

struct DMTDiscoverPromo: Codable {
    let title: String
    let subtitle: String
    let artKey: String
}

struct DMTDiscoverGalleryCard: Codable {
    let id: String
    let artKey: String
}

struct DMTNookDigest: Codable {
    let displayName: String
    let handle: String
    let moodLine: String
    let about: String
    let highlights: [DMTStatChip]
    let actions: [String]
    let walletTitle: String
    let walletBalance: Int
    let followerCount: Int
    let followingCount: Int
    let giftLine: String
    let segmentTitles: [String]
    let emptyTitle: String
    let emptyArtKey: String
}

struct DMTStatChip: Codable {
    let label: String
    let value: String
}
