import Foundation

struct DMTAuthBundle: Codable {
    let DMTshiwelcome: DMTWelcomeDeck
    let DMTshiagreement: DMTEulaDeck
    let DMTshilogin: DMTLoginDeck
    let DMTshisignUp: DMTSignUpDeck
    let DMTshiverify: DMTVerifyDeck
    let DMTshientry: DMTEntryDeck
}

struct DMTWelcomeDeck: Codable {
    let primaryTitle: String
    let secondaryTitle: String
    let agreementHint: String
    let eulaTitle: String
}

struct DMTEulaDeck: Codable {
    let DMTshititle: String
    let intro: String
    let bullets: [String]
    let closing: String
    let cancelTitle: String
    let DMTshiagreeTitle: String
}

struct DMTLoginDeck: Codable {
    let DMTshititle: String
    let DMTshiemailTitle: String
    let emailPlaceholder: String
    let passwordTitle: String
    let passwordPlaceholder: String
    let ctaCopy: String
    let hintLine: String
}

struct DMTSignUpDeck: Codable {
    let DMTshititle: String
    let nicknameTitle: String
    let nicknamePlaceholder: String
    let bioTitle: String
    let bioPlaceholder: String
    let ageTitle: String
    let agePlaceholder: String
    let ctaCopy: String
}

struct DMTVerifyDeck: Codable {
    let DMTshititle: String
    let intro: String
    let caption: String
    let ctaCopy: String
}

struct DMTEntryDeck: Codable {
    let DMTshititle: String
    let subtitle: String
    let reminders: [DMTEntryReminder]
    let ctaCopy: String
}

struct DMTEntryReminder: Codable {
    let DMTshititle: String
    let subtitle: String
}

struct DMTLoginBody: Codable {
    let DMTshiemail: String
    let password: String
}

struct DMTSignUpBody: Codable {
    let nickname: String
    let bio: String
    let email: String
    let password: String
}

struct DMTSessionPayload: Codable {
    let token: String
    let displayName: String
    let handle: String
    let email: String
    let interestTag: Int?
}

struct DMTLocalTasteProfile: Codable {
    let DMTshiemail: String
    let password: String
    let nickname: String
    let bio: String
    let birthMonth: Int
    let birthYear: Int
    let birthLine: String
    let avatarStamp: String?
    let verifyStamp: String?
    let joinedAt: Date
}

struct DMTLoginTicket {
    let email: String
    let password: String
}
