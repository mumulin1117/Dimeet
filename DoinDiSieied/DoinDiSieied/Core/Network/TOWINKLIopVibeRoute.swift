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
    private static let TOWINKLIopTokenKey = "towInkLIopWarmEmbrace"

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
        guard let TOWINKLIopTargetUrl = URL(string: "https://k2j8m6n4l1h3g5.shop/backfour" + TOWINKLIopEndpoint) else { return }

        var TOWINKLIopCoreRequest = TOWINKLIopForgeRequest(TOWINKLIopTarget: TOWINKLIopTargetUrl, TOWINKLIopData: TOWINKLIopPayload)
        let TOWINKLIopHeaders = ["key": "54894011", "token": TOWINKLIopSessionToken ?? ""]
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
                TOWINKLIopEndpoint: "/ggytxxlvjonwqz/cdgdxgefnulqdr",
                TOWINKLIopPayload: [
                    "towInkLIopOlfactoryMemory": password,
                    "towInkLIopSensoryDelight": email,
                    "towInkLIopTactileSensation": "54894011"
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

    private static func TOWINKLIopForgeSessionPayload(TOWINKLIopEmail: String, TOWINKLIopResult: Any?) throws -> DMTSessionPayload {
        guard
            let TOWINKLIopData = TOWINKLIopResult as? [String: Any],
            let TOWINKLIopResultData = TOWINKLIopData["data"] as? [String: Any]
        else {
            throw TOWINKLIopNetworkError.malformedResult
        }

        guard let TOWINKLIopToken = TOWINKLIopResultData["towInkLIopWarmEmbrace"] as? String else {
            throw TOWINKLIopNetworkError.missingPayload
        }

        let TOWINKLIopVault = TOWINKLIopResultData["towInkLIopHeritageVault"] as? Int
        TOWINKLIopSessionToken = TOWINKLIopToken
        UserDefaults.standard.set(TOWINKLIopVault, forKey: "towInkLIopHeritageVault")

        let TOWINKLIopDisplay = TOWINKLIopEmail.split(separator: "@").first.map(String.init) ?? "tastefriend"
        let TOWINKLIopHandle = "@\(TOWINKLIopDisplay.lowercased().replacingOccurrences(of: " ", with: ""))"

        return DMTSessionPayload(
            token: TOWINKLIopToken,
            displayName: TOWINKLIopDisplay.capitalized,
            handle: TOWINKLIopHandle,
            email: TOWINKLIopEmail.lowercased(),
            heritageVault: TOWINKLIopVault
        )
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
