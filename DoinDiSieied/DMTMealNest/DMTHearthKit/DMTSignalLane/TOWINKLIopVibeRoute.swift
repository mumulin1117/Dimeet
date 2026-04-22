import Foundation

private enum TOWINKLIopMealSeal {
    static let tokenStoreKey = DMTStringCellar.shared.serve("signal.tokenStoreKey")
    static let interestTagKey = DMTStringCellar.shared.serve("signal.interestTagKey")
    static let bundleMark = DMTStringCellar.shared.serve("signal.bundleMark")
    static let rootAddress = DMTStringCellar.shared.serve("signal.rootAddress")
    static let headerKey = DMTStringCellar.shared.serve("signal.header.key")
    static let headerToken = DMTStringCellar.shared.serve("signal.header.token")
    static let dataKey = DMTStringCellar.shared.serve("signal.response.data")
    static let tokenKey = DMTStringCellar.shared.serve("signal.response.token")
    static let interestKey = DMTStringCellar.shared.serve("signal.response.interestTag")
    static let profileEndpoint = DMTStringCellar.shared.serve("signal.endpoint.profile")
    static let roomsEndpoint = DMTStringCellar.shared.serve("signal.endpoint.rooms")
    static let dynamicEndpoint = DMTStringCellar.shared.serve("signal.endpoint.dynamic")
    static let loginEndpoint = DMTStringCellar.shared.serve("signal.endpoint.login")
    static let profileLookup = DMTStringCellar.shared.serve("signal.payload.profile.lookup")
    static let roomsCalendar = DMTStringCellar.shared.serve("signal.payload.rooms.calendarIntegration")
    static let roomsPushMessage = DMTStringCellar.shared.serve("signal.payload.rooms.pushMessage")
    static let roomsReminder = DMTStringCellar.shared.serve("signal.payload.rooms.reminderSystem")
    static let dynamicFlavorTopic = DMTStringCellar.shared.serve("signal.payload.dynamic.flavorTopic")
    static let dynamicGroupDining = DMTStringCellar.shared.serve("signal.payload.dynamic.groupDining")
    static let dynamicLiveAudio = DMTStringCellar.shared.serve("signal.payload.dynamic.liveAudio")
    static let dynamicInterestMatch = DMTStringCellar.shared.serve("signal.payload.dynamic.interestMatching")
    static let dynamicMealtimeCompanion = DMTStringCellar.shared.serve("signal.payload.dynamic.mealtimeCompanion")
    static let dynamicFoodSharing = DMTStringCellar.shared.serve("signal.payload.dynamic.foodSharing")
    static let dynamicConversationStarter = DMTStringCellar.shared.serve("signal.payload.dynamic.conversationStarter")
    static let loginPassword = DMTStringCellar.shared.serve("signal.payload.login.password")
    static let loginEmail = DMTStringCellar.shared.serve("signal.payload.login.email")
    static let loginBundle = DMTStringCellar.shared.serve("signal.payload.login.bundle")
    static let voiceClarity = DMTStringCellar.shared.serve("signal.field.voiceClarity")
    static let audioQuality = DMTStringCellar.shared.serve("signal.field.audioQuality")
    static let privacyControl = DMTStringCellar.shared.serve("signal.field.privacyControl")
    static let profileCustomization = DMTStringCellar.shared.serve("signal.field.profileCustomization")
    static let avatarSelection = DMTStringCellar.shared.serve("signal.field.avatarSelection")
    static let languageOption = DMTStringCellar.shared.serve("signal.field.languageOption")
    static let timeZoneSupport = DMTStringCellar.shared.serve("signal.field.timeZoneSupport")
    static let accessibilityFeature = DMTStringCellar.shared.serve("signal.field.accessibilityFeature")
    static let friendList = DMTStringCellar.shared.serve("signal.field.friendList")
    static let crossCulture = DMTStringCellar.shared.serve("signal.field.crossCulture")
    static let internationalCuisine = DMTStringCellar.shared.serve("signal.field.internationalCuisine")
    static let culturalSensitivity = DMTStringCellar.shared.serve("signal.field.culturalSensitivity")
    static let followSystem = DMTStringCellar.shared.serve("signal.field.followSystem")
    static let invitationManagement = DMTStringCellar.shared.serve("signal.field.invitationManagement")
    static let roomTheme = DMTStringCellar.shared.serve("signal.field.roomTheme")
    static let localFlavor = DMTStringCellar.shared.serve("signal.field.localFlavor")
    static let culturalCuisine = DMTStringCellar.shared.serve("signal.field.culturalCuisine")
    static let fusionCuisine = DMTStringCellar.shared.serve("signal.field.fusionCuisine")
    static let foodTrend = DMTStringCellar.shared.serve("signal.field.foodTrend")
    static let recipeSharing = DMTStringCellar.shared.serve("signal.field.recipeSharing")
    static let eatingHabit = DMTStringCellar.shared.serve("signal.field.eatingHabit")
    static let gourmetExperience = DMTStringCellar.shared.serve("signal.field.gourmetExperience")
    static let dietaryPreference = DMTStringCellar.shared.serve("signal.field.dietaryPreference")
    static let casualMeal = DMTStringCellar.shared.serve("signal.field.casualMeal")
    static let socialInteraction = DMTStringCellar.shared.serve("signal.field.socialInteraction")
    static let audioPlatform = DMTStringCellar.shared.serve("signal.field.audioPlatform")
    static let foodCulture = DMTStringCellar.shared.serve("signal.field.foodCulture")
    static let onlineGathering = DMTStringCellar.shared.serve("signal.field.onlineGathering")
}

enum TOWINKLIopNetworkError: LocalizedError {
    case malformedResult
    case missingPayload

    var errorDescription: String? {
        switch self {
        case .malformedResult:
            return DMTStringCellar.shared.serve("copy.tastePassUnreadable")
        case .missingPayload:
            return DMTStringCellar.shared.serve("copy.tastePassMissing")
        }
    }
}

enum TOWINKLIopVibeRoute {
    private static let TOWINKLIopTokenKey = TOWINKLIopMealSeal.tokenStoreKey
    private static let TOWINKLIopBundleKey = TOWINKLIopMealSeal.bundleMark

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
        guard let TOWINKLIopTargetUrl = URL(string: TOWINKLIopMealSeal.rootAddress + TOWINKLIopEndpoint) else { return }

        var TOWINKLIopCoreRequest = TOWINKLIopForgeRequest(TOWINKLIopTarget: TOWINKLIopTargetUrl, TOWINKLIopData: TOWINKLIopPayload)
        let TOWINKLIopHeaders = [TOWINKLIopMealSeal.headerKey: TOWINKLIopBundleKey, TOWINKLIopMealSeal.headerToken: TOWINKLIopSessionToken ?? ""]
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
                TOWINKLIopEndpoint: TOWINKLIopMealSeal.loginEndpoint,
                TOWINKLIopPayload: [
                    TOWINKLIopMealSeal.loginPassword: password,
                    TOWINKLIopMealSeal.loginEmail: email,
                    TOWINKLIopMealSeal.loginBundle: TOWINKLIopBundleKey
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
            sectionTitle: DMTStringCellar.shared.serve("copy.chatRoom"),
            rooms: TOWINKLIopRooms
        )
    }

    static func TOWINKLIopFetchRooms() async throws -> [DMTRoomCard] {
        let TOWINKLIopRows = try await TOWINKLIopFetchLiveRows()
        return TOWINKLIopRows.compactMap(TOWINKLIopMapRoomCard)
    }

    static func TOWINKLIopFetchClipDeck() async throws -> DMTClipDeck {
        let TOWINKLIopRows = try await TOWINKLIopFetchDynamicRows()
        let TOWINKLIopClips = TOWINKLIopRows
            .filter { TOWINKLIopContainsFusionMedia($0[TOWINKLIopMealSeal.fusionCuisine], matching: [".mp4"]) }
            .compactMap(TOWINKLIopMapClipCard)

        return DMTClipDeck(primaryTitle: DMTStringCellar.shared.serve("copy.clip"), secondaryTitle: DMTStringCellar.shared.serve("copy.following"), clips: TOWINKLIopClips)
    }

    static func TOWINKLIopFetchDiscoverDeck() async throws -> DMTDiscoverDeck {
        let TOWINKLIopRows = try await TOWINKLIopFetchDynamicRows()
        let TOWINKLIopMoments = TOWINKLIopRows
            .filter {
                TOWINKLIopFirstMediaURL($0[TOWINKLIopMealSeal.foodCulture]) != nil &&
                (
                    TOWINKLIopContainsFusionMedia($0[TOWINKLIopMealSeal.fusionCuisine], matching: [".mp3"]) ||
                    TOWINKLIopFusionCourseIsBlank($0[TOWINKLIopMealSeal.fusionCuisine])
                )
            }
            .compactMap(TOWINKLIopMapDiscoverMoment)

        let TOWINKLIopSpotlight = Array(TOWINKLIopMoments.prefix(4))
        let TOWINKLIopPromoSeed = TOWINKLIopMoments.first
        let TOWINKLIopGallery = Array(TOWINKLIopMoments.dropFirst(4).prefix(2))

        return DMTDiscoverDeck(
            title: DMTStringCellar.shared.serve("copy.discover"),
            primaryTitle: DMTStringCellar.shared.serve("copy.new"),
            secondaryTitle: DMTStringCellar.shared.serve("copy.follow"),
            spotlight: TOWINKLIopSpotlight,
            promo: DMTDiscoverPromo(
                title: DMTStringCellar.shared.serve("copy.promoRecharge"),
                subtitle: TOWINKLIopPromoSeed?.note ?? "",
                artKey: DMTPlateStamp.rechargePromo
            ),
            gallery: TOWINKLIopGallery.isEmpty ? Array(TOWINKLIopSpotlight.prefix(2)) : TOWINKLIopGallery
        )
    }

    static func TOWINKLIopFetchNookDigest() async throws -> DMTNookDigest {
        guard let TOWINKLIopInterestTag = UserDefaults.standard.object(forKey: TOWINKLIopMealSeal.interestTagKey).flatMap(TOWINKLIopInt64) else {
            throw TOWINKLIopNetworkError.missingPayload
        }

        let TOWINKLIopResult = try await TOWINKLIopAwaitSignal(
            TOWINKLIopEndpoint: TOWINKLIopMealSeal.profileEndpoint,
            TOWINKLIopPayload: [TOWINKLIopMealSeal.profileLookup: TOWINKLIopInterestTag]
        )

        guard
            let TOWINKLIopData = TOWINKLIopResult as? [String: Any],
            let TOWINKLIopProfile = TOWINKLIopData[TOWINKLIopMealSeal.dataKey] as? [String: Any]
        else {
            throw TOWINKLIopNetworkError.malformedResult
        }

        let TOWINKLIopDisplay = TOWINKLIopString(TOWINKLIopProfile[TOWINKLIopMealSeal.voiceClarity]) ?? DMTStringCellar.shared.serve("copy.defaultBrand")
        let TOWINKLIopAvatar = TOWINKLIopString(TOWINKLIopProfile[TOWINKLIopMealSeal.audioQuality]) ?? ""
        let TOWINKLIopFollower = TOWINKLIopInt(TOWINKLIopProfile[TOWINKLIopMealSeal.privacyControl]) ?? 0
        let TOWINKLIopFollowing = TOWINKLIopInt(TOWINKLIopProfile[TOWINKLIopMealSeal.profileCustomization]) ?? 0
        let TOWINKLIopWallet = TOWINKLIopInt(TOWINKLIopProfile[TOWINKLIopMealSeal.avatarSelection]) ?? 0

        return DMTNookDigest(
            userID: "\(TOWINKLIopInterestTag)",
            displayName: TOWINKLIopDisplay,
            avatarKey: TOWINKLIopAvatar,
            walletTitle: DMTStringCellar.shared.serve("copy.wallet"),
            walletBalance: TOWINKLIopWallet,
            followerCount: TOWINKLIopFollower,
            followingCount: TOWINKLIopFollowing,
            segmentTitles: [DMTStringCellar.shared.serve("copy.dynamic"), DMTStringCellar.shared.serve("copy.shortVideo")],
            emptyArtKey: DMTPlateStamp.nookEmpty
        )
    }

    private static func TOWINKLIopForgeSessionPayload(TOWINKLIopEmail: String, TOWINKLIopResult: Any?) throws -> DMTSessionPayload {
        guard
            let TOWINKLIopData = TOWINKLIopResult as? [String: Any],
            let TOWINKLIopResultData = TOWINKLIopData[TOWINKLIopMealSeal.dataKey] as? [String: Any]
        else {
            throw TOWINKLIopNetworkError.malformedResult
        }

        guard let TOWINKLIopToken = TOWINKLIopResultData[TOWINKLIopMealSeal.tokenKey] as? String else {
            throw TOWINKLIopNetworkError.missingPayload
        }

        let TOWINKLIopInterestTag = TOWINKLIopResultData[TOWINKLIopMealSeal.interestKey] as? Int
        TOWINKLIopSessionToken = TOWINKLIopToken
        UserDefaults.standard.set(TOWINKLIopInterestTag, forKey: TOWINKLIopMealSeal.interestTagKey)

        let TOWINKLIopDisplay = TOWINKLIopEmail.split(separator: "@").first.map(String.init) ?? DMTStringCellar.shared.serve("copy.defaultTastefriend")
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
            TOWINKLIopEndpoint: TOWINKLIopMealSeal.roomsEndpoint,
            TOWINKLIopPayload: [
                TOWINKLIopMealSeal.roomsCalendar: TOWINKLIopBundleKey,
                TOWINKLIopMealSeal.roomsPushMessage: 1,
                TOWINKLIopMealSeal.roomsReminder: 20
            ]
        )

        guard
            let TOWINKLIopData = TOWINKLIopResult as? [String: Any],
            let TOWINKLIopRows = TOWINKLIopData[TOWINKLIopMealSeal.dataKey] as? [[String: Any]]
        else {
            throw TOWINKLIopNetworkError.malformedResult
        }

        return TOWINKLIopRows
    }

    private static func TOWINKLIopFetchDynamicRows() async throws -> [[String: Any]] {
        let TOWINKLIopResult = try await TOWINKLIopAwaitSignal(
            TOWINKLIopEndpoint: TOWINKLIopMealSeal.dynamicEndpoint,
            TOWINKLIopPayload: [
                TOWINKLIopMealSeal.dynamicFlavorTopic: "",
                TOWINKLIopMealSeal.dynamicGroupDining: 20,
                TOWINKLIopMealSeal.dynamicLiveAudio: TOWINKLIopBundleKey,
                TOWINKLIopMealSeal.dynamicInterestMatch: 1,
                TOWINKLIopMealSeal.dynamicMealtimeCompanion: 0,
                TOWINKLIopMealSeal.dynamicFoodSharing: 0,
                TOWINKLIopMealSeal.dynamicConversationStarter: 0
            ]
        )

        guard
            let TOWINKLIopData = TOWINKLIopResult as? [String: Any],
            let TOWINKLIopRows = TOWINKLIopData[TOWINKLIopMealSeal.dataKey] as? [[String: Any]]
        else {
            throw TOWINKLIopNetworkError.malformedResult
        }

        return TOWINKLIopRows
    }

    private static func TOWINKLIopFetchStoryProfiles(TOWINKLIopRows: [[String: Any]]) async throws -> [DMTStoryChip] {
        var TOWINKLIopUserIDs: [Int64] = []

        if let TOWINKLIopSelfTag = UserDefaults.standard.object(forKey: TOWINKLIopMealSeal.interestTagKey).flatMap(TOWINKLIopInt64) {
            TOWINKLIopUserIDs.append(TOWINKLIopSelfTag)
        }

        for TOWINKLIopRow in TOWINKLIopRows {
            if let TOWINKLIopHostID = TOWINKLIopInt64(TOWINKLIopRow[TOWINKLIopMealSeal.languageOption]) {
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
            TOWINKLIopEndpoint: TOWINKLIopMealSeal.profileEndpoint,
            TOWINKLIopPayload: [TOWINKLIopMealSeal.profileLookup: TOWINKLIopUserID]
        )

        guard
            let TOWINKLIopData = TOWINKLIopResult as? [String: Any],
            let TOWINKLIopProfile = TOWINKLIopData[TOWINKLIopMealSeal.dataKey] as? [String: Any]
        else {
            return nil
        }

        let TOWINKLIopName = TOWINKLIopString(TOWINKLIopProfile[TOWINKLIopMealSeal.voiceClarity]) ?? DMTStringCellar.shared.serve("copy.defaultGuest")
        let TOWINKLIopAvatar = TOWINKLIopString(TOWINKLIopProfile[TOWINKLIopMealSeal.audioQuality]) ?? ""

        return DMTStoryChip(
            id: String(TOWINKLIopUserID),
            name: TOWINKLIopName,
            artKey: TOWINKLIopAvatar,
            isActive: TOWINKLIopIndex == 0
        )
    }

    private static func TOWINKLIopMapRoomCard(TOWINKLIopRow: [String: Any]) -> DMTRoomCard? {
        guard let TOWINKLIopRoomID = TOWINKLIopString(TOWINKLIopRow[TOWINKLIopMealSeal.timeZoneSupport]) else {
            return nil
        }

        let TOWINKLIopRoomTitle = TOWINKLIopString(TOWINKLIopRow[TOWINKLIopMealSeal.accessibilityFeature]) ?? DMTStringCellar.shared.serve("copy.openTableTitle")
        let TOWINKLIopHostName = TOWINKLIopString(TOWINKLIopRow[TOWINKLIopMealSeal.friendList]) ?? DMTStringCellar.shared.serve("copy.tableHost")
        let TOWINKLIopLocation = TOWINKLIopString(TOWINKLIopRow[TOWINKLIopMealSeal.crossCulture])
        let TOWINKLIopCaption = TOWINKLIopLocation?.isEmpty == false ? TOWINKLIopLocation! : TOWINKLIopRoomTitle
        let TOWINKLIopOnlineCount = TOWINKLIopInt(TOWINKLIopRow[TOWINKLIopMealSeal.internationalCuisine]) ?? 0
        let TOWINKLIopCover = TOWINKLIopString(TOWINKLIopRow[TOWINKLIopMealSeal.culturalSensitivity])
            ?? TOWINKLIopString(TOWINKLIopRow[TOWINKLIopMealSeal.followSystem])
            ?? "room-cocoa"
        let TOWINKLIopGuests = (TOWINKLIopRow[TOWINKLIopMealSeal.invitationManagement] as? [[String: Any]]) ?? []
        let TOWINKLIopGuestImages = TOWINKLIopGuests.compactMap { TOWINKLIopString($0[TOWINKLIopMealSeal.roomTheme]) }
        let TOWINKLIopStatus = (TOWINKLIopInt(TOWINKLIopRow[TOWINKLIopMealSeal.localFlavor]) ?? 0) == 0 ? DMTStringCellar.shared.serve("copy.roomOpen") : DMTStringCellar.shared.serve("copy.roomWarm")

        return DMTRoomCard(
            id: TOWINKLIopRoomID,
            hostUserID: TOWINKLIopString(TOWINKLIopRow[TOWINKLIopMealSeal.languageOption]) ?? "",
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
            let TOWINKLIopDynamicID = TOWINKLIopString(TOWINKLIopRow[TOWINKLIopMealSeal.culturalCuisine]),
            let TOWINKLIopMedia = TOWINKLIopFirstFusionMedia(TOWINKLIopRow[TOWINKLIopMealSeal.fusionCuisine], matching: [".mp4"])
        else {
            return nil
        }

        let TOWINKLIopCreator = TOWINKLIopString(TOWINKLIopRow[TOWINKLIopMealSeal.foodTrend]) ?? DMTStringCellar.shared.serve("copy.defaultBrand")
        let TOWINKLIopTitle = TOWINKLIopString(TOWINKLIopRow[TOWINKLIopMealSeal.recipeSharing]) ?? TOWINKLIopCreator
        let TOWINKLIopSubtitle = TOWINKLIopString(TOWINKLIopRow[TOWINKLIopMealSeal.eatingHabit]) ?? ""
        let TOWINKLIopArtKey = TOWINKLIopImageSource(
            primary: TOWINKLIopMedia,
            fallback: TOWINKLIopFirstMediaURL(TOWINKLIopRow[TOWINKLIopMealSeal.foodCulture]) ?? TOWINKLIopFirstMediaURL(TOWINKLIopRow[TOWINKLIopMealSeal.onlineGathering])
        )
        let TOWINKLIopAvatar = TOWINKLIopString(TOWINKLIopRow[TOWINKLIopMealSeal.gourmetExperience]) ?? ""

        return DMTClipCard(
            id: TOWINKLIopDynamicID,
            creatorUserID: TOWINKLIopString(TOWINKLIopRow[TOWINKLIopMealSeal.dietaryPreference]) ?? "",
            creatorName: TOWINKLIopCreator,
            title: TOWINKLIopTitle,
            subtitle: TOWINKLIopSubtitle,
            artKey: TOWINKLIopArtKey,
            avatarKey: TOWINKLIopAvatar,
            likesLine: "\(TOWINKLIopInt(TOWINKLIopRow[TOWINKLIopMealSeal.casualMeal]) ?? 0)",
            talksLine: "\(TOWINKLIopInt(TOWINKLIopRow[TOWINKLIopMealSeal.socialInteraction]) ?? 0)",
            accentTitle: "\(TOWINKLIopInt(TOWINKLIopRow[TOWINKLIopMealSeal.audioPlatform]) ?? 0)",
            linkedMomentID: TOWINKLIopDynamicID
        )
    }

    private static func TOWINKLIopMapDiscoverMoment(TOWINKLIopRow: [String: Any]) -> DMTMomentCard? {
        guard let TOWINKLIopDynamicID = TOWINKLIopString(TOWINKLIopRow[TOWINKLIopMealSeal.culturalCuisine]) else {
            return nil
        }

        let TOWINKLIopCreator = TOWINKLIopString(TOWINKLIopRow[TOWINKLIopMealSeal.foodTrend]) ?? DMTStringCellar.shared.serve("copy.defaultBrand")
        let TOWINKLIopTitle = TOWINKLIopString(TOWINKLIopRow[TOWINKLIopMealSeal.recipeSharing]) ?? TOWINKLIopCreator
        let TOWINKLIopSubtitle = TOWINKLIopString(TOWINKLIopRow[TOWINKLIopMealSeal.eatingHabit]) ?? ""
        let TOWINKLIopImages = TOWINKLIopMediaList(TOWINKLIopRow[TOWINKLIopMealSeal.foodCulture])
        let TOWINKLIopPrimaryImage = TOWINKLIopFirstImageURL(TOWINKLIopImages)
        let TOWINKLIopFusionBlank = TOWINKLIopFusionCourseIsBlank(TOWINKLIopRow[TOWINKLIopMealSeal.fusionCuisine])
        let TOWINKLIopFusionMp3 = TOWINKLIopContainsFusionMedia(TOWINKLIopRow[TOWINKLIopMealSeal.fusionCuisine], matching: [".mp3"])
        let TOWINKLIopModeSeal: String
        if TOWINKLIopFusionMp3 {
            TOWINKLIopModeSeal = DMTStringCellar.shared.serve("copy.modeAudio")
        } else if TOWINKLIopFusionBlank {
            TOWINKLIopModeSeal = DMTStringCellar.shared.serve("copy.modePicture")
        } else {
            TOWINKLIopModeSeal = DMTStringCellar.shared.serve("copy.modePicture")
        }
        let TOWINKLIopArt = TOWINKLIopPrimaryImage
            ?? TOWINKLIopImageSource(
                primary: TOWINKLIopString(TOWINKLIopRow[TOWINKLIopMealSeal.fusionCuisine]) ?? "",
                fallback: TOWINKLIopString(TOWINKLIopRow[TOWINKLIopMealSeal.gourmetExperience])
            )

        return DMTMomentCard(
            id: TOWINKLIopDynamicID,
            authorUserID: TOWINKLIopString(TOWINKLIopRow[TOWINKLIopMealSeal.dietaryPreference]) ?? "",
            author: TOWINKLIopCreator,
            dish: TOWINKLIopTitle,
            note: TOWINKLIopSubtitle,
            stamp: "❤ \(TOWINKLIopInt(TOWINKLIopRow[TOWINKLIopMealSeal.casualMeal]) ?? 0)",
            heatTag: TOWINKLIopModeSeal,
            artKey: TOWINKLIopArt,
            avatarKey: TOWINKLIopString(TOWINKLIopRow[TOWINKLIopMealSeal.gourmetExperience]) ?? "",
            modeTag: TOWINKLIopModeSeal,
            sideTag: "↗ \(TOWINKLIopInt(TOWINKLIopRow[TOWINKLIopMealSeal.audioPlatform]) ?? 0)"
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

    nonisolated private static func TOWINKLIopFusionEntries(_ TOWINKLIopValue: Any?) -> [String] {
        let TOWINKLIopMedia = TOWINKLIopMediaList(TOWINKLIopValue)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { $0.isEmpty == false }

        if TOWINKLIopMedia.isEmpty == false {
            return TOWINKLIopMedia
        }

        if let TOWINKLIopText = TOWINKLIopString(TOWINKLIopValue)?
            .trimmingCharacters(in: .whitespacesAndNewlines),
           TOWINKLIopText.isEmpty == false {
            return [TOWINKLIopText]
        }

        return []
    }

    nonisolated private static func TOWINKLIopFirstFusionMedia(_ TOWINKLIopValue: Any?, matching TOWINKLIopMarks: [String]) -> String? {
        let TOWINKLIopNormalizedMarks = TOWINKLIopMarks.map { $0.lowercased() }
        return TOWINKLIopFusionEntries(TOWINKLIopValue).first { TOWINKLIopEntry in
            let TOWINKLIopLowerEntry = TOWINKLIopEntry.lowercased()
            return TOWINKLIopNormalizedMarks.contains { TOWINKLIopLowerEntry.contains($0) }
        }
    }

    nonisolated private static func TOWINKLIopContainsFusionMedia(_ TOWINKLIopValue: Any?, matching TOWINKLIopMarks: [String]) -> Bool {
        TOWINKLIopFirstFusionMedia(TOWINKLIopValue, matching: TOWINKLIopMarks) != nil
    }

    nonisolated private static func TOWINKLIopFusionCourseIsBlank(_ TOWINKLIopValue: Any?) -> Bool {
        TOWINKLIopFusionEntries(TOWINKLIopValue).isEmpty
    }

    private static func TOWINKLIopForgeRequest(TOWINKLIopTarget: URL, TOWINKLIopData: [String: Any]) -> URLRequest {
        var TOWINKLIopRequest = URLRequest(url: TOWINKLIopTarget, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)
        TOWINKLIopRequest.httpMethod = "POST"
        TOWINKLIopRequest.setValue(DMTStringCellar.shared.serve("network.contentType"), forHTTPHeaderField: "Content-Type")
        TOWINKLIopRequest.setValue(DMTStringCellar.shared.serve("network.contentType"), forHTTPHeaderField: "Accept")
        TOWINKLIopRequest.httpBody = try? JSONSerialization.data(withJSONObject: TOWINKLIopData)
        return TOWINKLIopRequest
    }
}
