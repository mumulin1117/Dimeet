import Foundation

final class HNONWCEsilkDrape: NSObject {
    static let shared = HNONWCEsilkDrape()

    internal override init() {
        super.init()
    }

    func APPPREFIX_postRequest(
        _ path: String,
        APPPREFIX_params: [String: Any],
        APPPREFIX_isPaymentFlow: Bool = false,
        APPPREFIX_completion: @escaping (Result<[String: Any]?, Error>) -> Void = { _ in }
    ) {
        guard let requestURL = URL(string: TgextileLuster.shared.APPPREFIX_baseURL + path) else {
            DispatchQueue.main.async {
                APPPREFIX_completion(.failure(NSError(domain: HNONWCcasualChic.Network.urlError, code: 400)))
            }
            return
        }

        guard
            let jsonString = HNONWCEsilkDrape.APPPREFIX_jsonString(APPPREFIX_from: APPPREFIX_params),
            let aes = EcelebrationGarment(),
            let encryptedString = aes.APPPREFIX_encrypt(jsonString),
            let encryptedData = encryptedString.data(using: .utf8)
        else {
            DispatchQueue.main.async {
                APPPREFIX_completion(.failure(NSError(domain: HNONWCcasualChic.Network.decryptError, code: 401)))
            }
            return
        }

        var request = URLRequest(url: requestURL)
        request.httpMethod = HNONWCcasualChic.Network.post
        request.httpBody = encryptedData
        request.timeoutInterval = 15

        APPPREFIXRequestHeaderFactory.makeHeaders().forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error {
                DispatchQueue.main.async {
                    APPPREFIX_completion(.failure(error))
                }
                return
            }

            guard let data else {
                DispatchQueue.main.async {
                    APPPREFIX_completion(.failure(NSError(domain: HNONWCcasualChic.Network.noData, code: 1000)))
                }
                return
            }

            let result = APPPREFIXResponseDecoder.decode(rawData: data, isPaymentFlow: APPPREFIX_isPaymentFlow)
            DispatchQueue.main.async {
                APPPREFIX_completion(result)
            }
        }.resume()
    }

    class func APPPREFIX_jsonString(APPPREFIX_from dict: [String: Any]) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: dict) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}
