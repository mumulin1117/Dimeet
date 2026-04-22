import UIKit

final class DMTTasteProfileStore {
    static let shared = DMTTasteProfileStore()

    private let defaults = UserDefaults.standard
    private let stashKey = "dmt.taste.profile.deck"
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    private var profiles: [String: DMTLocalTasteProfile] = [:]

    private let fileManager = FileManager.default
    private lazy var artworkFolder: URL = {
        let baseURL = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first ?? fileManager.temporaryDirectory
        let folderURL = baseURL.appendingPathComponent("DMTTastePortraits", isDirectory: true)
        try? fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
        return folderURL
    }()

    private init() {
        restoreProfiles()
    }

    func normalizedEmail(_ email: String) -> String {
        email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }

    func isTestAccount(email: String, password: String) -> Bool {
        normalizedEmail(email) == "test@gmail.com" && password == "123456"
    }

    func profile(for email: String) -> DMTLocalTasteProfile? {
        profiles[normalizedEmail(email)]
    }

    func image(for stamp: String?) -> UIImage? {
        guard let stamp else { return nil }
        let imageURL = artworkFolder.appendingPathComponent(stamp)
        guard let data = try? Data(contentsOf: imageURL) else { return nil }
        return UIImage(data: data)
    }

    func needsRegistration(email: String) -> Bool {
        profile(for: email) == nil
    }

    func canDirectLogin(email: String, password: String) -> Bool {
        if isTestAccount(email: email, password: password) {
            return true
        }

        guard let profile = profile(for: email) else {
            return false
        }

        return profile.password == password
    }

    func hasPasswordMismatch(email: String, password: String) -> Bool {
        guard let profile = profile(for: email) else {
            return false
        }

        return profile.password != password
    }

    @discardableResult
    func ensureTestProfile() -> DMTLocalTasteProfile {
        let email = "test@gmail.com"
        if let cached = profile(for: email) {
            return cached
        }

        let profile = DMTLocalTasteProfile(
            DMTshiemail: email,
            password: "123456",
            nickname: "Taste Scout",
            bio: "Always ready for one more bite and one more story.",
            birthMonth: 5,
            birthYear: 1998,
            birthLine: "May 1998",
            avatarStamp: persistPlaceholderImage(named: "taste-scout-avatar"),
            verifyStamp: persistPlaceholderImage(named: "taste-scout-verify"),
            joinedAt: Date()
        )
        profiles[email] = profile
        persistProfiles()
        return profile
    }

    @discardableResult
    func persistProfile(from draft: DMTSignUpDraft) -> DMTLocalTasteProfile {
        let email = normalizedEmail(draft.ticket.email)
        let avatarStamp = persistImage(draft.avatarImage ?? makePortraitPlaceholder(symbolName: "fork.knife.circle.fill"), named: "avatar-\(email)")
        let verifyStamp = persistImage(draft.verifyImage ?? makePortraitPlaceholder(symbolName: "checkmark.shield.fill"), named: "verify-\(email)")

        let profile = DMTLocalTasteProfile(
            DMTshiemail: email,
            password: draft.ticket.password,
            nickname: draft.nickname,
            bio: draft.bio,
            birthMonth: draft.birthMonth,
            birthYear: draft.birthYear,
            birthLine: draft.birthLine,
            avatarStamp: avatarStamp,
            verifyStamp: verifyStamp,
            joinedAt: Date()
        )

        profiles[email] = profile
        persistProfiles()
        return profile
    }

    private func restoreProfiles() {
        guard
            let data = defaults.data(forKey: stashKey),
            let decoded = try? decoder.decode([String: DMTLocalTasteProfile].self, from: data)
        else {
            profiles = [:]
            return
        }

        profiles = decoded
    }

    private func persistProfiles() {
        guard let data = try? encoder.encode(profiles) else { return }
        defaults.set(data, forKey: stashKey)
    }

    private func persistPlaceholderImage(named name: String) -> String? {
        persistImage(makePortraitPlaceholder(symbolName: "person.crop.circle.fill"), named: name)
    }

    private func persistImage(_ image: UIImage, named name: String) -> String? {
        let safeName = name.replacingOccurrences(of: "@", with: "-").replacingOccurrences(of: ".", with: "-")
        let stamp = "\(safeName).jpg"
        let imageURL = artworkFolder.appendingPathComponent(stamp)
        guard let data = image.jpegData(compressionQuality: 0.88) else { return nil }
        try? data.write(to: imageURL, options: .atomic)
        return stamp
    }

    private func makePortraitPlaceholder(symbolName: String) -> UIImage {
        let size = CGSize(width: 320, height: 320)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            let colors = [DMTPalette.peach.cgColor, DMTPalette.sunrise.cgColor] as CFArray
            let space = CGColorSpaceCreateDeviceRGB()
            let gradient = CGGradient(colorsSpace: space, colors: colors, locations: [0, 1])!
            context.cgContext.drawLinearGradient(gradient, start: .zero, end: CGPoint(x: size.width, y: size.height), options: [])

            let config = UIImage.SymbolConfiguration(pointSize: 132, weight: .regular)
            let symbol = UIImage(systemName: symbolName, withConfiguration: config)?
                .withTintColor(.white.withAlphaComponent(0.92), renderingMode: .alwaysOriginal)
            symbol?.draw(in: CGRect(x: 94, y: 94, width: 132, height: 132))
        }
    }
}
