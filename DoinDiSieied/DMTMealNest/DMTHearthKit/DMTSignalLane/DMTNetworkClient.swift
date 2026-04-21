import Foundation

enum DMTNetworkFault: LocalizedError {
    case invalidResponse
    case status(Int)

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return DMTStringCellar.shared.serve("copy.mealSignalInterrupted")
        case .status(let code):
            return "\(DMTStringCellar.shared.serve("copy.kitchenReturnedPrefix")) \(code)."
        }
    }
}

final class DMTNetworkClient {
    private let session: URLSession
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let baseURL = URL(string: DMTStringCellar.shared.serve("network.baseURL"))!

    init() {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [DMTMockServerURLProtocol.self]
        configuration.timeoutIntervalForRequest = 12
        configuration.timeoutIntervalForResource = 12
        session = URLSession(configuration: configuration)
    }

    func load<Response: Decodable>(_ path: String, method: String = "GET", body: Encodable? = nil) async throws -> Response {
        var request = URLRequest(url: baseURL.appendingPathComponent(path))
        request.httpMethod = method
        request.setValue(DMTStringCellar.shared.serve("network.contentType"), forHTTPHeaderField: "Content-Type")

        if let body {
            request.httpBody = try encoder.encode(DMTAnyEncodable(body))
        }

        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw DMTNetworkFault.invalidResponse
        }

        guard (200..<300).contains(httpResponse.statusCode) else {
            throw DMTNetworkFault.status(httpResponse.statusCode)
        }

        return try decoder.decode(Response.self, from: data)
    }
}

private struct DMTAnyEncodable: Encodable {
    private let encodeBlock: (Encoder) throws -> Void

    init(_ wrapped: Encodable) {
        encodeBlock = wrapped.encode
    }

    func encode(to encoder: Encoder) throws {
        try encodeBlock(encoder)
    }
}
