import Foundation

private enum DMTHearthPortalSeal {
    static let rootAddress = DMTStringCellar.shared.serve("portal.rootAddress")
    static let bundleMark = DMTStringCellar.shared.serve("portal.bundleMark")
    static let token = DMTStringCellar.shared.serve("portal.query.token")
    static let appID = DMTStringCellar.shared.serve("portal.query.appID")
    static let channel = DMTStringCellar.shared.serve("portal.query.channel")
    static let userID = DMTStringCellar.shared.serve("portal.query.userId")
    static let liveID = DMTStringCellar.shared.serve("portal.query.liveId")
    static let dynamicID = DMTStringCellar.shared.serve("portal.query.dynamicId")
    static let type = DMTStringCellar.shared.serve("portal.query.type")
    static let callVideo = DMTStringCellar.shared.serve("portal.query.callVideo")
    static let one = DMTStringCellar.shared.serve("portal.query.one")
    static let two = DMTStringCellar.shared.serve("portal.query.two")
}

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

    private static let rootAddress = DMTHearthPortalSeal.rootAddress
    private static let bundleMark = DMTHearthPortalSeal.bundleMark

    var navigationTitle: String {
        switch self {
        case .editProfile: return DMTStringCellar.shared.serve("portal.title.editProfile")
        case .createRoom: return DMTStringCellar.shared.serve("portal.title.createRoom")
        case .joinRoom: return DMTStringCellar.shared.serve("portal.title.joinRoom")
        case .tableLounge: return DMTStringCellar.shared.serve("portal.title.tableLounge")
        case .mealRobot: return DMTStringCellar.shared.serve("portal.title.mealRobot")
        case .directMessage(_, let videoCall): return videoCall ? DMTStringCellar.shared.serve("portal.title.videoChat") : DMTStringCellar.shared.serve("portal.title.messages")
        case .noticeCenter: return DMTStringCellar.shared.serve("portal.title.noticeCenter")
        case .userHomepage: return DMTStringCellar.shared.serve("portal.title.userHomepage")
        case .dynamicDetail: return DMTStringCellar.shared.serve("portal.title.dynamicDetail")
        case .publishDynamic: return DMTStringCellar.shared.serve("portal.title.publishDynamic")
        case .publishVideo: return DMTStringCellar.shared.serve("portal.title.publishVideo")
        case .videoDetail: return DMTStringCellar.shared.serve("portal.title.videoDetail")
        case .settingCenter: return DMTStringCellar.shared.serve("portal.title.settingCenter")
        case .followingList: return DMTStringCellar.shared.serve("portal.title.followingList")
        case .fansList: return DMTStringCellar.shared.serve("portal.title.fansList")
        case .reportCenter: return DMTStringCellar.shared.serve("portal.title.reportCenter")
        case .walletCenter: return DMTStringCellar.shared.serve("portal.title.walletCenter")
        case .userAgreement: return DMTStringCellar.shared.serve("portal.title.userAgreement")
        case .privacyPolicy: return DMTStringCellar.shared.serve("portal.title.privacyPolicy")
        case .receivedGift: return DMTStringCellar.shared.serve("portal.title.receivedGift")
        case .webEntry: return ""
        }
    }

    var portalTraceLine: String {
        let query = portalPairs
            .map { "\($0.0)=\(Self.encoded($0.1))" }
            .joined(separator: "&")
        return query.isEmpty ? portalPath : "\(portalPath)?\(query)"
    }

    var portalTraceURL: String? {
        makeURL()?.absoluteString
    }

    func makeURL() -> URL? {
        if case .webEntry(let path) = self {
            return Self.makeWebEntryURL(path)
        }
        let token = TOWINKLIopVibeRoute.TOWINKLIopSessionToken ?? ""
        var queryPairs = portalPairs
        queryPairs.append((DMTHearthPortalSeal.token, token))
        queryPairs.append((DMTHearthPortalSeal.appID, Self.bundleMark))

        let fragmentQuery = queryPairs
            .map { "\($0.0)=\(Self.encoded($0.1))" }
            .joined(separator: "&")
        let fragment = fragmentQuery.isEmpty ? portalPath : "\(portalPath)?\(fragmentQuery)"
        return URL(string: "\(Self.rootAddress)#\(fragment)")
    }

    private var portalPath: String {
        switch self {
        case .editProfile:
            return DMTStringCellar.shared.serve("portal.path.editProfile")
        case .createRoom:
            return DMTStringCellar.shared.serve("portal.path.createRoom")
        case .joinRoom:
            return DMTStringCellar.shared.serve("portal.path.joinRoom")
        case .tableLounge:
            return DMTStringCellar.shared.serve("portal.path.tableLounge")
        case .mealRobot:
            return DMTStringCellar.shared.serve("portal.path.mealRobot")
        case .directMessage:
            return DMTStringCellar.shared.serve("portal.path.directMessage")
        case .noticeCenter:
            return DMTStringCellar.shared.serve("portal.path.noticeCenter")
        case .userHomepage:
            return DMTStringCellar.shared.serve("portal.path.userHomepage")
        case .dynamicDetail:
            return DMTStringCellar.shared.serve("portal.path.dynamicDetail")
        case .publishDynamic:
            return DMTStringCellar.shared.serve("portal.path.publishDynamic")
        case .publishVideo:
            return DMTStringCellar.shared.serve("portal.path.publishVideo")
        case .videoDetail:
            return DMTStringCellar.shared.serve("portal.path.videoDetail")
        case .settingCenter:
            return DMTStringCellar.shared.serve("portal.path.settingCenter")
        case .followingList:
            return DMTStringCellar.shared.serve("portal.path.followingList")
        case .fansList:
            return DMTStringCellar.shared.serve("portal.path.fansList")
        case .reportCenter:
            return DMTStringCellar.shared.serve("portal.path.reportCenter")
        case .walletCenter:
            return DMTStringCellar.shared.serve("portal.path.walletCenter")
        case .userAgreement, .privacyPolicy:
            return DMTStringCellar.shared.serve("portal.path.agreement")
        case .receivedGift:
            return DMTStringCellar.shared.serve("portal.path.receivedGift")
        case .webEntry(let path):
            return path
        }
    }

    private var portalPairs: [(String, String)] {
        switch self {
        case .editProfile, .createRoom, .mealRobot, .noticeCenter, .publishDynamic, .publishVideo, .settingCenter, .followingList, .fansList, .reportCenter, .walletCenter:
            return []
        case .joinRoom(let channel, let hostUserID):
            return [(DMTHearthPortalSeal.channel, channel), (DMTHearthPortalSeal.userID, hostUserID)]
        case .tableLounge(let liveID):
            return [(DMTHearthPortalSeal.liveID, liveID)]
        case .directMessage(let userID, let videoCall):
            var items = [(DMTHearthPortalSeal.userID, userID)]
            if videoCall {
                items.append((DMTHearthPortalSeal.callVideo, DMTHearthPortalSeal.one))
            }
            return items
        case .userHomepage(let userID):
            return [(DMTHearthPortalSeal.userID, userID)]
        case .dynamicDetail(let dynamicID), .videoDetail(let dynamicID):
            return [(DMTHearthPortalSeal.dynamicID, dynamicID)]
        case .userAgreement:
            return [(DMTHearthPortalSeal.type, DMTHearthPortalSeal.one)]
        case .privacyPolicy:
            return [(DMTHearthPortalSeal.type, DMTHearthPortalSeal.two)]
        case .receivedGift(let userID):
            return [(DMTHearthPortalSeal.userID, userID)]
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
        mergeValue(TOWINKLIopVibeRoute.TOWINKLIopSessionToken ?? "", for: DMTHearthPortalSeal.token, into: &queryPairs)
        mergeValue(bundleMark, for: DMTHearthPortalSeal.appID, into: &queryPairs)
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
