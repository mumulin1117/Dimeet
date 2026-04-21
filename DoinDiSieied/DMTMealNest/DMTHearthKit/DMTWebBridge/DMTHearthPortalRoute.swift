import Foundation

enum DMTHearthPortalRoute {
    case editProfile
    case createRoom
    case joinRoom(channel: String, hostUserID: String)
    case tableLounge(liveID: String)
    case mealRobot
    case directMessage(userID: String, videoCall: Bool)
    case noticeCenter
    case userHomepage(userID: String)
    case dynamicDetail(dynamicID: String)
    case publishDynamic
    case publishVideo
    case videoDetail(dynamicID: String)
    case settingCenter
    case followingList
    case fansList
    case reportCenter
    case walletCenter
    case userAgreement
    case privacyPolicy
    case receivedGift(userID: String)
    case webEntry(path: String)

    private static let rootAddress = "https://pqr2kjh8dm.shop/"
    private static let bundleMark = "79709626"

    var navigationTitle: String {
        switch self {
        case .editProfile: return "Edit Profile"
        case .createRoom: return "Create Room"
        case .joinRoom: return "Join Room"
        case .tableLounge: return "Voice Lounge"
        case .mealRobot: return "Meal Robot"
        case .directMessage(_, let videoCall): return videoCall ? "Video Chat" : "Messages"
        case .noticeCenter: return "Notice"
        case .userHomepage: return "Homepage"
        case .dynamicDetail: return "Dynamic"
        case .publishDynamic: return "Issue"
        case .publishVideo: return "Post Video"
        case .videoDetail: return "Video"
        case .settingCenter: return "Setting"
        case .followingList: return "Following"
        case .fansList: return "Fans"
        case .reportCenter: return "Report"
        case .walletCenter: return "Wallet"
        case .userAgreement: return "Agreement"
        case .privacyPolicy: return "Privacy"
        case .receivedGift: return "Received Gift"
        case .webEntry: return ""
        }
    }

    func makeURL() -> URL? {
        if case .webEntry(let path) = self {
            return Self.makeWebEntryURL(path)
        }
        let token = TOWINKLIopVibeRoute.TOWINKLIopSessionToken ?? ""
        var queryPairs = portalPairs
        queryPairs.append(("token", token))
        queryPairs.append(("appID", Self.bundleMark))

        let fragmentQuery = queryPairs
            .map { "\($0.0)=\(Self.encoded($0.1))" }
            .joined(separator: "&")
        let fragment = fragmentQuery.isEmpty ? portalPath : "\(portalPath)?\(fragmentQuery)"
        return URL(string: "\(Self.rootAddress)#\(fragment)")
    }

    private var portalPath: String {
        switch self {
        case .editProfile:
            return "pages/EditProfile/index"
        case .createRoom:
            return "pages/CreateRoom/index"
        case .joinRoom:
            return "pages/JoinLiveRoom/index"
        case .tableLounge:
            return "pages/virtualChatRoom/index"
        case .mealRobot:
            return "pages/AIRobot/index"
        case .directMessage:
            return "pages/DetailsMesses/index"
        case .noticeCenter:
            return "pages/Notice/index"
        case .userHomepage:
            return "pages/homepage/index"
        case .dynamicDetail:
            return "pages/DynamicDetails/index"
        case .publishDynamic:
            return "pages/issue/index"
        case .publishVideo:
            return "pages/postVideos/index"
        case .videoDetail:
            return "pages/VideoDetails/index"
        case .settingCenter:
            return "pages/Setting/index"
        case .followingList:
            return "pages/Following/index"
        case .fansList:
            return "pages/fansList/index"
        case .reportCenter:
            return "pages/report/index"
        case .walletCenter:
            return "pages/MyWallet/index"
        case .userAgreement, .privacyPolicy:
            return "pages/agreement/index"
        case .receivedGift:
            return "pages/receivedGift/index"
        case .webEntry(let path):
            return path
        }
    }

    private var portalPairs: [(String, String)] {
        switch self {
        case .editProfile, .createRoom, .mealRobot, .noticeCenter, .publishDynamic, .publishVideo, .settingCenter, .followingList, .fansList, .reportCenter, .walletCenter:
            return []
        case .joinRoom(let channel, let hostUserID):
            return [("channel", channel), ("userId", hostUserID)]
        case .tableLounge(let liveID):
            return [("liveId", liveID)]
        case .directMessage(let userID, let videoCall):
            var items = [("userId", userID)]
            if videoCall {
                items.append(("CallVideo", "1"))
            }
            return items
        case .userHomepage(let userID):
            return [("userId", userID)]
        case .dynamicDetail(let dynamicID), .videoDetail(let dynamicID):
            return [("dynamicId", dynamicID)]
        case .userAgreement:
            return [("type", "1")]
        case .privacyPolicy:
            return [("type", "2")]
        case .receivedGift(let userID):
            return [("userId", userID)]
        case .webEntry:
            return []
        }
    }

    private static func encoded(_ value: String) -> String {
        let forbidden = CharacterSet(charactersIn: ":#[]@!$&'()*+,;=?/ ")
        return value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed.subtracting(forbidden)) ?? value
    }

    private static func makeWebEntryURL(_ rawPath: String) -> URL? {
        let trimmed = rawPath.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.isEmpty == false else { return nil }

        if trimmed.hasPrefix("http://") || trimmed.hasPrefix("https://") {
            return URL(string: trimmed)
        }

        var cleanPath = trimmed
        while cleanPath.hasPrefix("#") || cleanPath.hasPrefix("/") {
            cleanPath.removeFirst()
        }

        let pairParts = cleanPath.split(separator: "?", maxSplits: 1, omittingEmptySubsequences: false)
        let pagePath = pairParts.map(String.init).first ?? cleanPath
        var queryPairs = parseQuery(pairParts.count > 1 ? String(pairParts[1]) : "")
        mergeValue(TOWINKLIopVibeRoute.TOWINKLIopSessionToken ?? "", for: "token", into: &queryPairs)
        mergeValue(bundleMark, for: "appID", into: &queryPairs)
        let query = queryPairs.map { "\($0.0)=\(encoded($0.1))" }.joined(separator: "&")
        let fragment = query.isEmpty ? pagePath : "\(pagePath)?\(query)"
        return URL(string: "\(rootAddress)#\(fragment)")
    }

    private static func parseQuery(_ query: String) -> [(String, String)] {
        guard query.isEmpty == false else { return [] }
        return query
            .split(separator: "&")
            .map { pair in
                let pieces = pair.split(separator: "=", maxSplits: 1, omittingEmptySubsequences: false)
                let key = pieces.map(String.init).first ?? ""
                let value = pieces.count > 1 ? String(pieces[1]) : ""
                return (key, value)
            }
            .filter { $0.0.isEmpty == false }
    }

    private static func mergeValue(_ value: String, for key: String, into pairs: inout [(String, String)]) {
        guard pairs.contains(where: { $0.0 == key }) == false else { return }
        pairs.append((key, value))
    }
}
