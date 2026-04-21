import Foundation

struct DMTHomeDeck: Codable {
    let stories: [DMTStoryChip]
    let sectionTitle: String
    let rooms: [DMTRoomCard]
}

struct DMTStoryChip: Codable {
    let id: String
    let name: String
    let artKey: String
    let isActive: Bool
}

struct DMTRoomCard: Codable {
    let id: String
    let hostUserID: String
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

struct DMTClipDeck: Codable {
    let primaryTitle: String
    let secondaryTitle: String
    let clips: [DMTClipCard]
}

struct DMTClipCard: Codable {
    let id: String
    let creatorUserID: String
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
    let authorUserID: String
    let author: String
    let dish: String
    let note: String
    let stamp: String
    let heatTag: String
    let artKey: String
    let avatarKey: String
    let modeTag: String
    let sideTag: String
}

struct DMTDiscoverDeck: Codable {
    let title: String
    let primaryTitle: String
    let secondaryTitle: String
    let spotlight: [DMTMomentCard]
    let promo: DMTDiscoverPromo
    let gallery: [DMTMomentCard]
}

struct DMTDiscoverPromo: Codable {
    let title: String
    let subtitle: String
    let artKey: String
}

struct DMTNookDigest: Codable {
    let userID: String
    let displayName: String
    let avatarKey: String
    let walletTitle: String
    let walletBalance: Int
    let followerCount: Int
    let followingCount: Int
    let segmentTitles: [String]
    let emptyArtKey: String
}
