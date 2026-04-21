import Foundation

enum TOWINKLIopNetworkError: LocalizedError {
    case malformedResult
    case missingPayload

    var errorDescription: String? {
        switch self {
        case .malformedResult:
            return "The taste pass response was unreadable."
        case .missingPayload:
            return "The taste pass is missing account data."
        }
    }
}

enum TOWINKLIopVibeRoute {
    private static let TOWINKLIopTokenKey = "achievementBadge"
    private static let TOWINKLIopBundleKey = "79709626"

    static var TOWINKLIopSessionToken: String? {
        get { UserDefaults.standard.string(forKey: TOWINKLIopTokenKey) }
        set { UserDefaults.standard.set(newValue, forKey: TOWINKLIopTokenKey) }
    }

    static func TOWINKLIopTransmitSignal(
        TOWINKLIopEndpoint: String,
        TOWINKLIopPayload: [String: Any],
        TOWINKLIopOnSuccess: ((Any?) -> Void)?,
        TOWINKLIopOnFailure: ((Error) -> Void)?
    ) {
        guard let TOWINKLIopTargetUrl = URL(string: "https://pqr2kjh8dm.shop/backfour" + TOWINKLIopEndpoint) else { return }

        var TOWINKLIopCoreRequest = TOWINKLIopForgeRequest(TOWINKLIopTarget: TOWINKLIopTargetUrl, TOWINKLIopData: TOWINKLIopPayload)
        let TOWINKLIopHeaders = ["key": "79709626", "token": TOWINKLIopSessionToken ?? ""]
        TOWINKLIopHeaders.forEach { TOWINKLIopCoreRequest.setValue($1, forHTTPHeaderField: $0) }

        let TOWINKLIopNetworkSession = URLSessionConfiguration.default
        TOWINKLIopNetworkSession.timeoutIntervalForRequest = 30

        URLSession(configuration: TOWINKLIopNetworkSession).dataTask(with: TOWINKLIopCoreRequest) { TOWINKLIopRawData, _, TOWINKLIopError in
            DispatchQueue.main.async {
                if let TOWINKLIopErr = TOWINKLIopError {
                    TOWINKLIopOnFailure?(TOWINKLIopErr)
                    return
                }
                guard let TOWINKLIopData = TOWINKLIopRawData else { return }
                do {
                    let TOWINKLIopJson = try JSONSerialization.jsonObject(with: TOWINKLIopData, options: .allowFragments)
                    TOWINKLIopOnSuccess?(TOWINKLIopJson)
                } catch {
                    TOWINKLIopOnFailure?(error)
                }
            }
        }.resume()
    }

    static func TOWINKLIopLogin(email: String, password: String) async throws -> DMTSessionPayload {
        try await withCheckedThrowingContinuation { continuation in
            TOWINKLIopTransmitSignal(
                TOWINKLIopEndpoint: "/ecfblkqnwbz/wkfpopzfe",
                TOWINKLIopPayload: [
                    "engagementMetric": password,
                    "pointReward": email,
                    "userRetention": TOWINKLIopBundleKey
                ]
            ) { result in
                do {
                    let payload = try TOWINKLIopForgeSessionPayload(TOWINKLIopEmail: email, TOWINKLIopResult: result)
                    continuation.resume(returning: payload)
                } catch {
                    continuation.resume(throwing: error)
                }
            } TOWINKLIopOnFailure: { error in
                continuation.resume(throwing: error)
            }
        }
    }

    static func TOWINKLIopFetchHomeDeck() async throws -> DMTHomeDeck {
        let TOWINKLIopRows = try await TOWINKLIopFetchLiveRows()
        let TOWINKLIopRooms = TOWINKLIopRows.compactMap(TOWINKLIopMapRoomCard)
        let TOWINKLIopProfiles = try await TOWINKLIopFetchStoryProfiles(TOWINKLIopRows: TOWINKLIopRows)
        return DMTHomeDeck(
            stories: TOWINKLIopProfiles,
            sectionTitle: "Chat Room",
            rooms: TOWINKLIopRooms
        )
    }

    static func TOWINKLIopFetchRooms() async throws -> [DMTRoomCard] {
        let TOWINKLIopRows = try await TOWINKLIopFetchLiveRows()
        return TOWINKLIopRows.compactMap(TOWINKLIopMapRoomCard)
    }

    static func TOWINKLIopFetchClipDeck() async throws -> DMTClipDeck {
        let TOWINKLIopRows = try await TOWINKLIopFetchDynamicRows()
        let TOWINKLIopClips = TOWINKLIopRows.compactMap(TOWINKLIopMapClipCard)

        return DMTClipDeck(primaryTitle: "Clip", secondaryTitle: "Following", clips: TOWINKLIopClips)
    }

    static func TOWINKLIopFetchDiscoverDeck() async throws -> DMTDiscoverDeck {
        let TOWINKLIopRows = try await TOWINKLIopFetchDynamicRows()
        let TOWINKLIopMoments = TOWINKLIopRows
            .filter { TOWINKLIopFirstMediaURL($0["foodCulture"]) != nil }
            .compactMap(TOWINKLIopMapDiscoverMoment)

        let TOWINKLIopSpotlight = Array(TOWINKLIopMoments.prefix(4))
        let TOWINKLIopPromoSeed = TOWINKLIopMoments.first
        let TOWINKLIopGallery = Array(TOWINKLIopMoments.dropFirst(4).prefix(2))

        return DMTDiscoverDeck(
            title: "Discover",
            primaryTitle: "New",
            secondaryTitle: "Follow",
            spotlight: TOWINKLIopSpotlight,
            promo: DMTDiscoverPromo(
                title: "Out of coins. Recharge now!",
                subtitle: TOWINKLIopPromoSeed?.note ?? "",
                artKey: "outofcoingsj"
            ),
            gallery: TOWINKLIopGallery.isEmpty ? Array(TOWINKLIopSpotlight.prefix(2)) : TOWINKLIopGallery
        )
    }

    static func TOWINKLIopFetchNookDigest() async throws -> DMTNookDigest {
        guard let TOWINKLIopInterestTag = UserDefaults.standard.object(forKey: "interestTag").flatMap(TOWINKLIopInt64) else {
            throw TOWINKLIopNetworkError.missingPayload
        }

        let TOWINKLIopResult = try await TOWINKLIopAwaitSignal(
            TOWINKLIopEndpoint: "/azybjz/zpvxtuo",
            TOWINKLIopPayload: ["backgroundNoise": TOWINKLIopInterestTag]
        )

        guard
            let TOWINKLIopData = TOWINKLIopResult as? [String: Any],
            let TOWINKLIopProfile = TOWINKLIopData["data"] as? [String: Any]
        else {
            throw TOWINKLIopNetworkError.malformedResult
        }

        let TOWINKLIopDisplay = TOWINKLIopString(TOWINKLIopProfile["voiceClarity"]) ?? "Dimeet"
        let TOWINKLIopAvatar = TOWINKLIopString(TOWINKLIopProfile["audioQuality"]) ?? ""
        let TOWINKLIopFollower = TOWINKLIopInt(TOWINKLIopProfile["privacyControl"]) ?? 0
        let TOWINKLIopFollowing = TOWINKLIopInt(TOWINKLIopProfile["profileCustomization"]) ?? 0
        let TOWINKLIopWallet = TOWINKLIopInt(TOWINKLIopProfile["avatarSelection"]) ?? 0

        return DMTNookDigest(
            userID: "\(TOWINKLIopInterestTag)",
            displayName: TOWINKLIopDisplay,
            avatarKey: TOWINKLIopAvatar,
            walletTitle: "Wallet",
            walletBalance: TOWINKLIopWallet,
            followerCount: TOWINKLIopFollower,
            followingCount: TOWINKLIopFollowing,
            segmentTitles: ["Dynamic", "Short Video"],
            emptyArtKey: "sliderThumbPosNOdata"
        )
    }

    private static func TOWINKLIopForgeSessionPayload(TOWINKLIopEmail: String, TOWINKLIopResult: Any?) throws -> DMTSessionPayload {
        guard
            let TOWINKLIopData = TOWINKLIopResult as? [String: Any],
            let TOWINKLIopResultData = TOWINKLIopData["data"] as? [String: Any]
        else {
            throw TOWINKLIopNetworkError.malformedResult
        }

        guard let TOWINKLIopToken = TOWINKLIopResultData["achievementBadge"] as? String else {
            throw TOWINKLIopNetworkError.missingPayload
        }

        let TOWINKLIopInterestTag = TOWINKLIopResultData["interestTag"] as? Int
        TOWINKLIopSessionToken = TOWINKLIopToken
        UserDefaults.standard.set(TOWINKLIopInterestTag, forKey: "interestTag")

        let TOWINKLIopDisplay = TOWINKLIopEmail.split(separator: "@").first.map(String.init) ?? "tastefriend"
        let TOWINKLIopHandle = "@\(TOWINKLIopDisplay.lowercased().replacingOccurrences(of: " ", with: ""))"

        return DMTSessionPayload(
            token: TOWINKLIopToken,
            displayName: TOWINKLIopDisplay.capitalized,
            handle: TOWINKLIopHandle,
            email: TOWINKLIopEmail.lowercased(),
            interestTag: TOWINKLIopInterestTag
        )
    }

    private static func TOWINKLIopFetchLiveRows() async throws -> [[String: Any]] {
        let TOWINKLIopResult = try await TOWINKLIopAwaitSignal(
            TOWINKLIopEndpoint: "/ippncprxz/nuoppyvr",
            TOWINKLIopPayload: [
               
                "calendarIntegration": TOWINKLIopBundleKey,
                "pushMessage": 1,
              
                "reminderSystem": 20
            ]
        )

        guard
            let TOWINKLIopData = TOWINKLIopResult as? [String: Any],
            let TOWINKLIopRows = TOWINKLIopData["data"] as? [[String: Any]]
        else {
            throw TOWINKLIopNetworkError.malformedResult
        }

        return TOWINKLIopRows
    }

    private static func TOWINKLIopFetchDynamicRows() async throws -> [[String: Any]] {
        let TOWINKLIopResult = try await TOWINKLIopAwaitSignal(
            TOWINKLIopEndpoint: "/dxwpfpjuygiz/chypmbdvmfq",
            TOWINKLIopPayload: [
                "flavorTopic": "",
                "groupDining": 20,
                "liveAudio": TOWINKLIopBundleKey,
                "interestMatching": 1,
                "mealtimeCompanion": 0,
                "foodSharing": 0,
                "conversationStarter": 0
            ]
        )

        guard
            let TOWINKLIopData = TOWINKLIopResult as? [String: Any],
            let TOWINKLIopRows = TOWINKLIopData["data"] as? [[String: Any]]
        else {
            throw TOWINKLIopNetworkError.malformedResult
        }

        return TOWINKLIopRows
    }

    private static func TOWINKLIopFetchStoryProfiles(TOWINKLIopRows: [[String: Any]]) async throws -> [DMTStoryChip] {
        var TOWINKLIopUserIDs: [Int64] = []

        if let TOWINKLIopSelfTag = UserDefaults.standard.object(forKey: "interestTag").flatMap(TOWINKLIopInt64) {
            TOWINKLIopUserIDs.append(TOWINKLIopSelfTag)
        }

        for TOWINKLIopRow in TOWINKLIopRows {
            if let TOWINKLIopHostID = TOWINKLIopInt64(TOWINKLIopRow["languageOption"]) {
                TOWINKLIopUserIDs.append(TOWINKLIopHostID)
            }
        }

        var TOWINKLIopSeen = Set<Int64>()
        let TOWINKLIopDistinct = TOWINKLIopUserIDs.filter { TOWINKLIopSeen.insert($0).inserted }.prefix(5)
        var TOWINKLIopStories: [DMTStoryChip] = []

        try await withThrowingTaskGroup(of: (Int, DMTStoryChip?).self) { TOWINKLIopGroup in
            for (TOWINKLIopIndex, TOWINKLIopUserID) in TOWINKLIopDistinct.enumerated() {
                TOWINKLIopGroup.addTask {
                    let TOWINKLIopStory = try await TOWINKLIopFetchStoryChip(TOWINKLIopUserID: TOWINKLIopUserID, TOWINKLIopIndex: TOWINKLIopIndex)
                    return (TOWINKLIopIndex, TOWINKLIopStory)
                }
            }

            var TOWINKLIopBucket: [(Int, DMTStoryChip)] = []
            for try await TOWINKLIopEntry in TOWINKLIopGroup {
                if let TOWINKLIopStory = TOWINKLIopEntry.1 {
                    TOWINKLIopBucket.append((TOWINKLIopEntry.0, TOWINKLIopStory))
                }
            }

            TOWINKLIopStories = TOWINKLIopBucket.sorted { $0.0 < $1.0 }.map(\.1)
        }

        return TOWINKLIopStories
    }

    private static func TOWINKLIopFetchStoryChip(TOWINKLIopUserID: Int64, TOWINKLIopIndex: Int) async throws -> DMTStoryChip? {
        let TOWINKLIopResult = try await TOWINKLIopAwaitSignal(
            TOWINKLIopEndpoint: "/azybjz/zpvxtuo",
            TOWINKLIopPayload: ["backgroundNoise": TOWINKLIopUserID]
        )

        guard
            let TOWINKLIopData = TOWINKLIopResult as? [String: Any],
            let TOWINKLIopProfile = TOWINKLIopData["data"] as? [String: Any]
        else {
            return nil
        }

        let TOWINKLIopName = TOWINKLIopString(TOWINKLIopProfile["voiceClarity"]) ?? "Guest"
        let TOWINKLIopAvatar = TOWINKLIopString(TOWINKLIopProfile["audioQuality"]) ?? ""

        return DMTStoryChip(
            id: String(TOWINKLIopUserID),
            name: TOWINKLIopName,
            artKey: TOWINKLIopAvatar,
            isActive: TOWINKLIopIndex == 0
        )
    }

    private static func TOWINKLIopMapRoomCard(TOWINKLIopRow: [String: Any]) -> DMTRoomCard? {
        guard let TOWINKLIopRoomID = TOWINKLIopString(TOWINKLIopRow["timeZoneSupport"]) else {
            return nil
        }

        let TOWINKLIopRoomTitle = TOWINKLIopString(TOWINKLIopRow["accessibilityFeature"]) ?? "Open Table"
        let TOWINKLIopHostName = TOWINKLIopString(TOWINKLIopRow["friendList"]) ?? "Table Host"
        let TOWINKLIopLocation = TOWINKLIopString(TOWINKLIopRow["crossCulture"])
        let TOWINKLIopCaption = TOWINKLIopLocation?.isEmpty == false ? TOWINKLIopLocation! : TOWINKLIopRoomTitle
        let TOWINKLIopOnlineCount = TOWINKLIopInt(TOWINKLIopRow["internationalCuisine"]) ?? 0
        let TOWINKLIopCover = TOWINKLIopString(TOWINKLIopRow["culturalSensitivity"])
            ?? TOWINKLIopString(TOWINKLIopRow["followSystem"])
            ?? "room-cocoa"
        let TOWINKLIopGuests = (TOWINKLIopRow["invitationManagement"] as? [[String: Any]]) ?? []
        let TOWINKLIopGuestImages = TOWINKLIopGuests.compactMap { TOWINKLIopString($0["roomTheme"]) }
        let TOWINKLIopStatus = (TOWINKLIopInt(TOWINKLIopRow["localFlavor"]) ?? 0) == 0 ? "Open table" : "Warm table"

        return DMTRoomCard(
            id: TOWINKLIopRoomID,
            hostUserID: TOWINKLIopString(TOWINKLIopRow["languageOption"]) ?? "",
            title: TOWINKLIopRoomTitle,
            topic: TOWINKLIopCaption,
            seatLine: TOWINKLIopCaption,
            pace: TOWINKLIopStatus,
            memberCount: TOWINKLIopOnlineCount,
            hostName: TOWINKLIopHostName,
            caption: TOWINKLIopCaption,
            onlineCount: TOWINKLIopOnlineCount,
            artKey: TOWINKLIopCover,
            attendeeKeys: TOWINKLIopGuestImages,
            trailingAccent: nil
        )
    }

    private static func TOWINKLIopMapClipCard(TOWINKLIopRow: [String: Any]) -> DMTClipCard? {
        guard
            let TOWINKLIopDynamicID = TOWINKLIopString(TOWINKLIopRow["culturalCuisine"]),
            let TOWINKLIopMedia = TOWINKLIopFusionSource(TOWINKLIopRow["fusionCuisine"])
        else {
            return nil
        }

        let TOWINKLIopCreator = TOWINKLIopString(TOWINKLIopRow["foodTrend"]) ?? "Dimeet"
        let TOWINKLIopTitle = TOWINKLIopString(TOWINKLIopRow["recipeSharing"]) ?? TOWINKLIopCreator
        let TOWINKLIopSubtitle = TOWINKLIopString(TOWINKLIopRow["eatingHabit"]) ?? ""
        let TOWINKLIopArtKey = TOWINKLIopImageSource(
            primary: TOWINKLIopMedia,
            fallback: TOWINKLIopFirstMediaURL(TOWINKLIopRow["foodCulture"]) ?? TOWINKLIopFirstMediaURL(TOWINKLIopRow["onlineGathering"])
        )
        let TOWINKLIopAvatar = TOWINKLIopString(TOWINKLIopRow["gourmetExperience"]) ?? ""

        return DMTClipCard(
            id: TOWINKLIopDynamicID,
            creatorUserID: TOWINKLIopString(TOWINKLIopRow["dietaryPreference"]) ?? "",
            creatorName: TOWINKLIopCreator,
            title: TOWINKLIopTitle,
            subtitle: TOWINKLIopSubtitle,
            artKey: TOWINKLIopArtKey,
            avatarKey: TOWINKLIopAvatar,
            likesLine: "\(TOWINKLIopInt(TOWINKLIopRow["casualMeal"]) ?? 0)",
            talksLine: "\(TOWINKLIopInt(TOWINKLIopRow["socialInteraction"]) ?? 0)",
            accentTitle: "\(TOWINKLIopInt(TOWINKLIopRow["audioPlatform"]) ?? 0)",
            linkedMomentID: TOWINKLIopDynamicID
        )
    }

    private static func TOWINKLIopMapDiscoverMoment(TOWINKLIopRow: [String: Any]) -> DMTMomentCard? {
        guard let TOWINKLIopDynamicID = TOWINKLIopString(TOWINKLIopRow["culturalCuisine"]) else {
            return nil
        }

        let TOWINKLIopCreator = TOWINKLIopString(TOWINKLIopRow["foodTrend"]) ?? "Dimeet"
        let TOWINKLIopTitle = TOWINKLIopString(TOWINKLIopRow["recipeSharing"]) ?? TOWINKLIopCreator
        let TOWINKLIopSubtitle = TOWINKLIopString(TOWINKLIopRow["eatingHabit"]) ?? ""
        let TOWINKLIopImages = TOWINKLIopMediaList(TOWINKLIopRow["foodCulture"])
        let TOWINKLIopPrimaryImage = TOWINKLIopFirstImageURL(TOWINKLIopImages)
        let TOWINKLIopAudioFlag = TOWINKLIopHasAudio(TOWINKLIopRow)
        let TOWINKLIopArt = TOWINKLIopPrimaryImage
            ?? TOWINKLIopImageSource(
                primary: TOWINKLIopString(TOWINKLIopRow["fusionCuisine"]) ?? "",
                fallback: TOWINKLIopString(TOWINKLIopRow["gourmetExperience"])
            )

        return DMTMomentCard(
            id: TOWINKLIopDynamicID,
            authorUserID: TOWINKLIopString(TOWINKLIopRow["dietaryPreference"]) ?? "",
            author: TOWINKLIopCreator,
            dish: TOWINKLIopTitle,
            note: TOWINKLIopSubtitle,
            stamp: "❤ \(TOWINKLIopInt(TOWINKLIopRow["casualMeal"]) ?? 0)",
            heatTag: TOWINKLIopAudioFlag ? "Audio" : "Picture",
            artKey: TOWINKLIopArt,
            avatarKey: TOWINKLIopString(TOWINKLIopRow["gourmetExperience"]) ?? "",
            modeTag: TOWINKLIopAudioFlag ? "Audio" : "Picture",
            sideTag: "↗ \(TOWINKLIopInt(TOWINKLIopRow["audioPlatform"]) ?? 0)"
        )
    }

    private static func TOWINKLIopAwaitSignal(TOWINKLIopEndpoint: String, TOWINKLIopPayload: [String: Any]) async throws -> Any? {
        try await withCheckedThrowingContinuation { continuation in
            TOWINKLIopTransmitSignal(
                TOWINKLIopEndpoint: TOWINKLIopEndpoint,
                TOWINKLIopPayload: TOWINKLIopPayload
            ) { TOWINKLIopResult in
                continuation.resume(returning: TOWINKLIopResult)
            } TOWINKLIopOnFailure: { TOWINKLIopError in
                continuation.resume(throwing: TOWINKLIopError)
            }
        }
    }

    nonisolated private static func TOWINKLIopString(_ TOWINKLIopValue: Any?) -> String? {
        switch TOWINKLIopValue {
        case let value as String:
            return value
        case let value as NSNumber:
            return value.stringValue
        default:
            return nil
        }
    }

    nonisolated private static func TOWINKLIopInt(_ TOWINKLIopValue: Any?) -> Int? {
        switch TOWINKLIopValue {
        case let value as Int:
            return value
        case let value as NSNumber:
            return value.intValue
        case let value as String:
            return Int(value)
        default:
            return nil
        }
    }

    nonisolated private static func TOWINKLIopInt64(_ TOWINKLIopValue: Any?) -> Int64? {
        switch TOWINKLIopValue {
        case let value as Int64:
            return value
        case let value as Int:
            return Int64(value)
        case let value as NSNumber:
            return value.int64Value
        case let value as String:
            return Int64(value)
        default:
            return nil
        }
    }

    nonisolated private static func TOWINKLIopFirstMediaURL(_ TOWINKLIopValue: Any?) -> String? {
        TOWINKLIopMediaList(TOWINKLIopValue).first
    }

    nonisolated private static func TOWINKLIopFusionSource(_ TOWINKLIopValue: Any?) -> String? {
        if let TOWINKLIopMedia = TOWINKLIopMediaList(TOWINKLIopValue)
            .map({ $0.trimmingCharacters(in: .whitespacesAndNewlines) })
            .first(where: { $0.isEmpty == false  }) {
            return TOWINKLIopMedia
        }

        if let TOWINKLIopText = TOWINKLIopString(TOWINKLIopValue)?
            .trimmingCharacters(in: .whitespacesAndNewlines),
           TOWINKLIopText.isEmpty == false  && TOWINKLIopText.contains("mp3") == false {
            return TOWINKLIopText
        }

        return nil
    }

    nonisolated private static func TOWINKLIopImageSource(primary: String, fallback: String?) -> String {
        if TOWINKLIopLooksLikeImageURL(primary) {
            return primary
        }

        if let fallback, !fallback.isEmpty {
            return fallback
        }

        return primary
    }

    nonisolated private static func TOWINKLIopLooksLikeImageURL(_ TOWINKLIopValue: String) -> Bool {
        let TOWINKLIopLower = TOWINKLIopValue.lowercased()
        return [".png", ".jpg", ".jpeg", ".webp", ".jfif"].contains { TOWINKLIopLower.contains($0) }
    }

    nonisolated private static func TOWINKLIopMediaList(_ TOWINKLIopValue: Any?) -> [String] {
        if let TOWINKLIopArray = TOWINKLIopValue as? [String] {
            return TOWINKLIopArray
        }

        if let TOWINKLIopArray = TOWINKLIopValue as? [Any] {
            return TOWINKLIopArray.compactMap(TOWINKLIopString)
        }

        return []
    }

    nonisolated private static func TOWINKLIopFirstImageURL(_ TOWINKLIopValues: [String]) -> String? {
        TOWINKLIopValues.first(where: TOWINKLIopLooksLikeImageURL)
    }

    nonisolated private static func TOWINKLIopHasAudio(_ TOWINKLIopRow: [String: Any]) -> Bool {
        let TOWINKLIopFusion = TOWINKLIopString(TOWINKLIopRow["fusionCuisine"]) ?? ""
        let TOWINKLIopImages = TOWINKLIopMediaList(TOWINKLIopRow["foodCulture"])
        return ([TOWINKLIopFusion] + TOWINKLIopImages).contains { $0.lowercased().contains(".mp3") }
    }

    private static func TOWINKLIopForgeRequest(TOWINKLIopTarget: URL, TOWINKLIopData: [String: Any]) -> URLRequest {
        var TOWINKLIopRequest = URLRequest(url: TOWINKLIopTarget, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)
        TOWINKLIopRequest.httpMethod = "POST"
        TOWINKLIopRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        TOWINKLIopRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        TOWINKLIopRequest.httpBody = try? JSONSerialization.data(withJSONObject: TOWINKLIopData)
        return TOWINKLIopRequest
    }
}
