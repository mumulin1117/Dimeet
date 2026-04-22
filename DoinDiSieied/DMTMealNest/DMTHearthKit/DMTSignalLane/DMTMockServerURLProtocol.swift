import Foundation

final class DMTMockServerURLProtocol: URLProtocol {
    private var brewTask: Task<Void, Never>?

    override class func canInit(with request: URLRequest) -> Bool {
        request.url?.host == DMTStringCellar.shared.serve("mock.host")
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        brewTask = Task {
            do {
                try await Task.sleep(nanoseconds: 220_000_000)
                let payload = try DMTMockKitchen.payload(for: request)
                guard !Task.isCancelled else { return }

                let response = HTTPURLResponse(
                    url: request.url ?? URL(string: DMTStringCellar.shared.serve("mock.rootURL"))!,
                    statusCode: 200,
                    httpVersion: nil,
                    headerFields: ["Content-Type": DMTStringCellar.shared.serve("network.contentType")]
                )!

                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                client?.urlProtocol(self, didLoad: payload)
                client?.urlProtocolDidFinishLoading(self)
            } catch let serverError as DMTMockKitchen.ErrorSignal {
                guard !Task.isCancelled else { return }

                let response = HTTPURLResponse(
                    url: request.url ?? URL(string: DMTStringCellar.shared.serve("mock.rootURL"))!,
                    statusCode: serverError.code,
                    httpVersion: nil,
                    headerFields: ["Content-Type": DMTStringCellar.shared.serve("network.contentType")]
                )!

                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                client?.urlProtocol(self, didLoad: Data("{\"message\":\"\(serverError.message)\"}".utf8))
                client?.urlProtocolDidFinishLoading(self)
            } catch {
                guard !Task.isCancelled else { return }
                client?.urlProtocol(self, didFailWithError: error)
            }
        }
    }

    override func stopLoading() {
        brewTask?.cancel()
    }
}

private enum DMTMockKitchen {
    struct ErrorSignal: Swift.Error {
        let code: Int
        let message: String
    }

    private static let encoder = JSONEncoder()
    private static let decoder = JSONDecoder()

    static func payload(for request: URLRequest) throws -> Data {
        let method = request.httpMethod ?? "GET"
        let path = request.url?.path ?? ""

        switch (method, path) {
        case ("GET", "/auth/bootstrap"):
            return try encode(authBundle)
//        case ("GET", "/meal-hearth"):
//            return try encode(homeDeck)
//        case ("GET", "/taste-clips"):
//            return try encode(clipDeck)
//        case ("GET", "/plate-discover"):
//            return try encode(discoverDeck)
        case ("POST", "/auth/login"):
            let body = try decode(DMTLoginBody.self, from: request.httpBody)
            return try encode(sessionPayload(email: body.DMTshiemail, name: body.DMTshiemail.split(separator: "@").first.map(String.init) ?? DMTStringCellar.shared.serve("copy.defaultGuest")))
        case ("POST", "/auth/signup"):
            let body = try decode(DMTSignUpBody.self, from: request.httpBody)
            return try encode(sessionPayload(email: body.email, name: body.nickname.isEmpty ? DMTStringCellar.shared.serve("copy.defaultTastefriend") : body.nickname))
//        case ("GET", "/meal-rooms"):
//            return try encode(roomCards)
//        case ("GET", "/plate-buzz"):
//            return try encode(momentCards)
//        case ("GET", "/meal-mate"):
//            return try encode(mateDeck)
//        case ("GET", "/taste-nook"):
//            return try encode(nookDigest)
        default:
//            if method == "GET", path.hasPrefix("/meal-rooms/") {
//                let roomID = String(path.dropFirst("/meal-rooms/".count))
//                guard let detail = roomDetails[roomID] else {
//                    throw ErrorSignal(code: 404, message: "Room not found")
//                }
//                return try encode(detail)
//            }
//
//            if method == "GET", path.hasPrefix("/plate-buzz/") {
//                let momentID = String(path.dropFirst("/plate-buzz/".count))
//                guard let detail = momentDetails[momentID] else {
//                    throw ErrorSignal(code: 404, message: "Moment not found")
//                }
//                return try encode(detail)
//            }
//
//            if method == "GET", path.hasPrefix("/meal-mate/") {
//                let promptID = String(path.dropFirst("/meal-mate/".count))
//                guard let reply = mateReplies[promptID] else {
//                    throw ErrorSignal(code: 404, message: "Prompt not found")
//                }
//                return try encode(reply)
//            }

            throw ErrorSignal(code: 404, message: DMTStringCellar.shared.serve("mock.plateMissing"))
        }
    }

    private static func encode<Value: Encodable>(_ value: Value) throws -> Data {
        try encoder.encode(value)
    }

    private static func decode<Value: Decodable>(_ type: Value.Type, from data: Data?) throws -> Value {
        guard let data else {
            throw ErrorSignal(code: 400, message: DMTStringCellar.shared.serve("mock.missingBody"))
        }
        return try decoder.decode(type, from: data)
    }

    private static func sessionPayload(email: String, name: String) -> DMTSessionPayload {
        let cleaned = name.lowercased().replacingOccurrences(of: " ", with: "")
        return DMTSessionPayload(token: "dmt-\(cleaned)-table", displayName: name.capitalized, handle: "@\(cleaned)", email: email.lowercased(), interestTag: 54894011)
    }

    private static let authBundle = DMTAuthBundle(
        DMTshiwelcome: DMTWelcomeDeck(
            primaryTitle: DMTStringCellar.shared.serve("auth.welcome.primaryTitle"),
            secondaryTitle: DMTStringCellar.shared.serve("auth.welcome.secondaryTitle"),
            agreementHint: DMTStringCellar.shared.serve("auth.welcome.agreementHint"),
            eulaTitle: DMTStringCellar.shared.serve("auth.welcome.eulaTitle")
        ),
        DMTshiagreement: DMTEulaDeck(
            DMTshititle: DMTStringCellar.shared.serve("auth.agreement.title"),
            intro: DMTStringCellar.shared.serve("auth.agreement.intro"),
            bullets: [
                DMTStringCellar.shared.serve("auth.agreement.bullet1"),
                DMTStringCellar.shared.serve("auth.agreement.bullet2"),
                DMTStringCellar.shared.serve("auth.agreement.bullet3"),
                DMTStringCellar.shared.serve("auth.agreement.bullet4")
            ],
            closing: DMTStringCellar.shared.serve("auth.agreement.closing"),
            cancelTitle: DMTStringCellar.shared.serve("auth.agreement.cancelTitle"),
            DMTshiagreeTitle: DMTStringCellar.shared.serve("auth.agreement.agreeTitle")
        ),
        DMTshilogin: DMTLoginDeck(
            DMTshititle: DMTStringCellar.shared.serve("auth.login.title"),
            DMTshiemailTitle: DMTStringCellar.shared.serve("auth.login.emailTitle"),
            emailPlaceholder: DMTStringCellar.shared.serve("auth.login.emailPlaceholder"),
            passwordTitle: DMTStringCellar.shared.serve("auth.login.passwordTitle"),
            passwordPlaceholder: DMTStringCellar.shared.serve("auth.login.passwordPlaceholder"),
            ctaCopy: DMTStringCellar.shared.serve("auth.login.cta"),
            hintLine: DMTStringCellar.shared.serve("auth.login.hintLine")
        ),
        DMTshisignUp: DMTSignUpDeck(
            DMTshititle: DMTStringCellar.shared.serve("auth.signUp.title"),
            nicknameTitle: DMTStringCellar.shared.serve("auth.signUp.nicknameTitle"),
            nicknamePlaceholder: DMTStringCellar.shared.serve("auth.signUp.nicknamePlaceholder"),
            bioTitle: DMTStringCellar.shared.serve("auth.signUp.bioTitle"),
            bioPlaceholder: DMTStringCellar.shared.serve("auth.signUp.bioPlaceholder"),
            ageTitle: DMTStringCellar.shared.serve("auth.signUp.ageTitle"),
            agePlaceholder: DMTStringCellar.shared.serve("auth.signUp.agePlaceholder"),
            ctaCopy: DMTStringCellar.shared.serve("auth.signUp.cta")
        ),
        DMTshiverify: DMTVerifyDeck(
            DMTshititle: DMTStringCellar.shared.serve("auth.verify.title"),
            intro: DMTStringCellar.shared.serve("auth.verify.intro"),
            caption: DMTStringCellar.shared.serve("auth.verify.caption"),
            ctaCopy: DMTStringCellar.shared.serve("auth.verify.cta")
        ),
        DMTshientry: DMTEntryDeck(
            DMTshititle: DMTStringCellar.shared.serve("auth.entry.title"),
            subtitle: DMTStringCellar.shared.serve("auth.entry.subtitle"),
            reminders: [
                DMTEntryReminder(DMTshititle: DMTStringCellar.shared.serve("auth.entry.reminder1.title"), subtitle: DMTStringCellar.shared.serve("auth.entry.reminder1.subtitle")),
                DMTEntryReminder(DMTshititle: DMTStringCellar.shared.serve("auth.entry.reminder2.title"), subtitle: DMTStringCellar.shared.serve("auth.entry.reminder2.subtitle")),
                DMTEntryReminder(DMTshititle: DMTStringCellar.shared.serve("auth.entry.reminder3.title"), subtitle: DMTStringCellar.shared.serve("auth.entry.reminder3.subtitle")),
                DMTEntryReminder(DMTshititle: DMTStringCellar.shared.serve("auth.entry.reminder4.title"), subtitle: DMTStringCellar.shared.serve("auth.entry.reminder4.subtitle")),
                DMTEntryReminder(DMTshititle: DMTStringCellar.shared.serve("auth.entry.reminder5.title"), subtitle: DMTStringCellar.shared.serve("auth.entry.reminder5.subtitle"))
            ],
            ctaCopy: DMTStringCellar.shared.serve("auth.entry.cta")
        )
    )

    private static let homeDeck = DMTHomeDeck(
        stories: [
            DMTStoryChip(id: "story-vasquez", name: "Vasquez", artKey: "story-vasquez", isActive: true),
            DMTStoryChip(id: "story-mccoya", name: "McCoya", artKey: "story-mccoya", isActive: false),
            DMTStoryChip(id: "story-ruiz", name: "Ruiz", artKey: "story-ruiz", isActive: false),
            DMTStoryChip(id: "story-matheus", name: "Matheus", artKey: "story-matheus", isActive: false),
            DMTStoryChip(id: "story-bernard", name: "Bernard", artKey: "story-bernard", isActive: false)
        ],
        sectionTitle: DMTStringCellar.shared.serve("copy.chatRoom"),
        rooms: [
            DMTRoomCard(
                id: "sunrise-broth",
                hostUserID: "story-host-evelyn",
                title: "Cocoa Corner",
                topic: "Flavor stories that stay warm and easy.",
                seatLine: "Cooking My Way Through Flavors and Cultures...",
                pace: "Soft start",
                memberCount: 320,
                hostName: "Evelyn Drake",
                caption: "Cooking My Way Through Flavors and Cultures...",
                onlineCount: 320,
                artKey: "room-cocoa",
                attendeeKeys: ["story-vasquez", "story-mccoya", "story-bernard"],
                trailingAccent: nil
            ),
            DMTRoomCard(
                id: "noodle-noon",
                hostUserID: "story-host-heartbreaker",
                title: "Bite Breakers",
                topic: "Playful meal talk with quick join energy.",
                seatLine: "Pick your role and speak your part.",
                pace: "Busy lunch",
                memberCount: 320,
                hostName: "Heart breaker",
                caption: "Pick your role and speak your part.",
                onlineCount: 320,
                artKey: "room-bitebreak",
                attendeeKeys: ["story-ruiz", "story-matheus", "story-mccoya"],
                trailingAccent: "Create Room"
            ),
            DMTRoomCard(
                id: "midnight-toast",
                hostUserID: "story-host-nora",
                title: "After Bite",
                topic: "Night tables for one more snack and one more story.",
                seatLine: "Midnight cravings with people still awake.",
                pace: "Night owl",
                memberCount: 146,
                hostName: "Nora Hale",
                caption: "Midnight cravings with people still awake.",
                onlineCount: 146,
                artKey: "room-midnight",
                attendeeKeys: ["story-vasquez", "story-ruiz", "story-matheus"],
                trailingAccent: nil
            )
        ]
    )

    private static let roomCards = homeDeck.rooms

//    private static let roomDetails = [
//        "sunrise-broth": DMTRoomDetail(
//            id: "sunrise-broth",
//            title: "Cocoa Corner",
//            hostLine: "Hosted by Evelyn Drake, who always brings one more flavor story to the table.",
//            summary: "A warm room for people who like comfort bites, quick check-ins, and a little playful commentary while they eat.",
//            currentPlates: ["Scallion pancake", "Soy milk", "Egg porridge"],
//            tablePrompts: ["What breakfast makes you feel grounded?", "Which aroma means home to you?", "What tiny ritual starts your day right?"]
//        ),
//        "noodle-noon": DMTRoomDetail(
//            id: "noodle-noon",
//            title: "Bite Breakers",
//            hostLine: "Hosted by Heart breaker, who keeps the room playful and fast-moving.",
//            summary: "A brighter room for people who want a casual speaking slot, a quick bite, and a lively reaction loop while they eat.",
//            currentPlates: ["Sesame noodles", "Cold brew", "Pickled cucumbers"],
//            tablePrompts: ["What desk lunch do you secretly love?", "Which topping upgrades any noodle bowl?", "What is your perfect ten-minute meal?"]
//        ),
//        "midnight-toast": DMTRoomDetail(
//            id: "midnight-toast",
//            title: "After Bite",
//            hostLine: "Hosted by Nora Hale, maker of late snacks and longer conversations.",
//            summary: "For night owls who want company while fixing one last bite before sleep and sharing random comfort cravings.",
//            currentPlates: ["Honey toast", "Miso butter corn", "Sparkling yuzu"],
//            tablePrompts: ["What late bite feels impossible to resist?", "Which tablePantry combo should not work but does?", "What snack belongs in every night drawer?"]
//        )
//    ]

//    private static let momentCards = [
//        DMTMomentCard(id: "pepper-sizzle", authorUserID: "moment-user-evelyn", author: "Evelyn Drake", dish: "After all, tomorrow is a...", note: "A night plate with camera-first energy.", stamp: "12m ago", heatTag: "Video", artKey: "moment-evelyn", avatarKey: "story-vasquez", modeTag: "Video", sideTag: "Live"),
//        DMTMomentCard(id: "berry-waffle", authorUserID: "moment-user-evelyn", author: "Evelyn Drake", dish: "Where Every Meal Tells...", note: "An audio-led bite story for people staying late.", stamp: "34m ago", heatTag: "Audio", artKey: "moment-denim", avatarKey: "story-vasquez", modeTag: "Audio", sideTag: "Live"),
//        DMTMomentCard(id: "curry-cloud", authorUserID: "moment-user-florence", author: "Florence Sutton", dish: "Exploring the World...", note: "A quick dish clip from a soft outdoor table.", stamp: "58m ago", heatTag: "Video", artKey: "moment-florence", avatarKey: "story-mccoya", modeTag: "Video", sideTag: "Live"),
//        DMTMomentCard(id: "garden-bite", authorUserID: "moment-user-jorge", author: "Jorge Hicks", dish: "Sharing My Food, My...", note: "Low-key table energy with a close-up bite.", stamp: "1h ago", heatTag: "Video", artKey: "moment-jorge", avatarKey: "story-ruiz", modeTag: "Video", sideTag: "Live")
//    ]

//    private static let momentDetails = [
//        "pepper-sizzle": DMTMomentDetail(
//            id: "pepper-sizzle",
//            author: "Evelyn Drake",
//            dish: "After all, tomorrow is a...",
//            story: "I wanted something with camera energy but still rooted in a real bite, so I kept the setup casual and let the plate do the work.",
//            tags: ["Pepper hit", "After-work plate", "Skillet mood"],
//            pairings: ["Sparkling citrus", "Pickled onion", "Soft egg"]
//        ),
//        "berry-waffle": DMTMomentDetail(
//            id: "berry-waffle",
//            author: "Evelyn Drake",
//            dish: "Where Every Meal Tells...",
//            story: "This one leaned warmer and more conversational. I wanted the bite to feel like an easy opener for people joining halfway through.",
//            tags: ["Weekend energy", "Brunch wish", "Berry gloss"],
//            pairings: ["Vanilla yogurt", "Iced latte", "Mint sugar"]
//        ),
//        "curry-cloud": DMTMomentDetail(
//            id: "curry-cloud",
//            author: "Florence Sutton",
//            dish: "Exploring the World...",
//            story: "I filmed this one outside because the light was soft and the food carried the whole mood. It felt playful without needing a big setup.",
//            tags: ["Cozy bowl", "Silky broth", "Rainy-night wish"],
//            pairings: ["Sesame greens", "Soft tofu", "Mango lassi"]
//        ),
//        "garden-bite": DMTMomentDetail(
//            id: "garden-bite",
//            author: "Jorge Hicks",
//            dish: "Sharing My Food, My...",
//            story: "This plate worked because it felt familiar and close. I kept the framing simple and let the bite and expression carry the post.",
//            tags: ["Soft light", "Casual share", "Table mood"],
//            pairings: ["Lemon soda", "Roasted tomato", "Honey ricotta"]
//        )
//    ]

//    private static let clipDeck = DMTClipDeck(
//        primaryTitle: "Clip",
//        secondaryTitle: "Following",
//        clips: [
//            DMTClipCard(
//                id: "clip-heartbreaker",
//                creatorUserID: "clip-user-heartbreaker",
//                creatorName: "Heart breaker",
//                title: "Heart breaker ❤️",
//                subtitle: "Pick your role and speak your part.",
//                artKey: "clip-heartbreaker",
//                avatarKey: "story-vasquez",
//                likesLine: "3.4k",
//                talksLine: "3.4k",
//                accentTitle: "+",
//                linkedMomentID: "pepper-sizzle"
//            ),
//            DMTClipCard(
//                id: "clip-florence",
//                creatorUserID: "clip-user-florence",
//                creatorName: "Florence Sutton",
//                title: "Night cravings only",
//                subtitle: "Join when the table feels too quiet.",
//                artKey: "clip-florence",
//                avatarKey: "story-mccoya",
//                likesLine: "2.6k",
//                talksLine: "1.8k",
//                accentTitle: "+",
//                linkedMomentID: "curry-cloud"
//            )
//        ]
//    )

//    private static let mateDeck = DMTMateDeck(
//        greeting: "Meal Mate is ready",
//        intro: "Pick a prompt and get a playful food-minded reply for cravings, dish ideas, or table talk starters.",
//        prompts: [
//            DMTMatePrompt(id: "craving-compass", title: "Craving Compass", subtitle: "Name your mood and get a dish direction.", seed: "I want something rich but not heavy."),
//            DMTMatePrompt(id: "plate-riff", title: "Plate Riff", subtitle: "Turn one ingredient into a full bite idea.", seed: "I only have mushrooms and rice."),
//            DMTMatePrompt(id: "table-icebreaker", title: "Table Icebreaker", subtitle: "Find a friendly prompt for your next room.", seed: "Give me a warm opener for a breakfast room.")
//        ]
//    )

//    private static let discoverDeck = DMTDiscoverDeck(
//        title: "Discover",
//        primaryTitle: "New",
//        secondaryTitle: "Follow",
//        spotlight: momentCards,
//        promo: DMTDiscoverPromo(
//            title: "Out of coins. Recharge now!",
//            subtitle: "Keep the room glowing and the prompts moving.",
//            artKey: "outofcoingsj"
//        ),
//        gallery: Array(momentCards.dropFirst(4).prefix(2))
//    )

//    private static let mateReplies = [
//        "craving-compass": DMTMateReply(
//            id: "craving-compass",
//            title: "Craving Compass",
//            lead: "You sound like you want comfort with lift.",
//            replies: [
//                "Try lemony butter pasta with pepper greens so the finish stays bright.",
//                "A roasted chicken rice bowl with crunchy herbs would feel full without dragging.",
//                "If you want soup, a creamy corn chowder with chili oil keeps the texture rich and the finish sharp."
//            ]
//        ),
//        "plate-riff": DMTMateReply(
//            id: "plate-riff",
//            title: "Plate Riff",
//            lead: "Mushrooms and rice can go far with a little contrast.",
//            replies: [
//                "Sear the mushrooms hard, fold them into soy butter rice, and finish with scallions.",
//                "Turn the rice into a crisp-edged pan cake and crown it with garlicky mushrooms.",
//                "Build a quick congee-style bowl and top it with pepper mushrooms plus a jammy egg."
//            ]
//        ),
//        "table-icebreaker": DMTMateReply(
//            id: "table-icebreaker",
//            title: "Table Icebreaker",
//            lead: "Start with something sensory and easy to answer.",
//            replies: [
//                "Ask which breakfast smell feels most like a good morning.",
//                "Try: what is the one bite that can reset a rough day?",
//                "Open with a fun tradeoff: sweet breakfast forever or savory breakfast forever?"
//            ]
//        )
//    ]

    private static let nookDigest = DMTNookDigest(
        userID: "taste-scout-id",
        displayName: "Taste Scout",
        avatarKey: "story-vasquez",
        walletTitle: DMTStringCellar.shared.serve("copy.wallet"),
        walletBalance: 1340,
        followerCount: 120,
        followingCount: 33,
        segmentTitles: [DMTStringCellar.shared.serve("copy.dynamic"), DMTStringCellar.shared.serve("copy.shortVideo")],
        emptyArtKey: "sliderThumbPosNOdata"
    )
}
