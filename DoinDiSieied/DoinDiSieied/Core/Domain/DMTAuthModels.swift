import Foundation

struct DMTAuthBundle: Codable {
    let welcome: DMTWelcomeDeck
    let agreement: DMTEulaDeck
    let login: DMTLoginDeck
    let signUp: DMTSignUpDeck
    let verify: DMTVerifyDeck
    let entry: DMTEntryDeck
}

struct DMTWelcomeDeck: Codable {
    let eyebrow: String
    let title: String
    let subtitle: String
    let primaryTitle: String
    let secondaryTitle: String
    let agreementHint: String
    let eulaTitle: String
}

struct DMTEulaDeck: Codable {
    let title: String
    let intro: String
    let bullets: [String]
    let closing: String
    let cancelTitle: String
    let agreeTitle: String
}

struct DMTLoginDeck: Codable {
    let title: String
    let emailTitle: String
    let emailPlaceholder: String
    let passwordTitle: String
    let passwordPlaceholder: String
    let buttonTitle: String
    let hintLine: String
}

struct DMTSignUpDeck: Codable {
    let title: String
    let nicknameTitle: String
    let nicknamePlaceholder: String
    let bioTitle: String
    let bioPlaceholder: String
    let ageTitle: String
    let agePlaceholder: String
    let buttonTitle: String
}

struct DMTVerifyDeck: Codable {
    let title: String
    let intro: String
    let caption: String
    let buttonTitle: String
}

struct DMTEntryDeck: Codable {
    let title: String
    let subtitle: String
    let reminders: [DMTEntryReminder]
    let buttonTitle: String
}

struct DMTEntryReminder: Codable {
    let title: String
    let subtitle: String
}

struct DMTLoginBody: Codable {
    let email: String
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
    let heritageVault: Int?
}

struct DMTLocalTasteProfile: Codable {
    let email: String
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
