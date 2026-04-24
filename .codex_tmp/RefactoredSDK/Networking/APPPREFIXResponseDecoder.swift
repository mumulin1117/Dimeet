import Foundation

enum APPPREFIXResponseDecoder {
    static func decode(rawData: Data, isPaymentFlow: Bool) -> Result<[String: Any]?, Error> {
        do {
            guard let json = try JSONSerialization.jsonObject(with: rawData) as? [String: Any] else {
                throw NSError(domain: HNONWCcasualChic.Network.invalidJSON, code: 1001)
            }

            guard let code = json[HNONWCcasualChic.Network.code] as? String else {
                throw NSError(
                    domain: json[HNONWCcasualChic.Network.message] as? String ?? HNONWCcasualChic.Network.fallbackMessage,
                    code: 1002
                )
            }

            if isPaymentFlow {
                guard code == HNONWCcasualChic.Network.successCode else {
                    throw NSError(domain: HNONWCcasualChic.Network.payError, code: 1003)
                }

                return .success([:])
            }

            guard
                code == HNONWCcasualChic.Network.successCode,
                let encryptedResult = json[HNONWCcasualChic.Network.result] as? String,
                let aes = EcelebrationGarment(),
                let decryptedString = aes.APPPREFIX_decrypt(APPPREFIX_base64String: encryptedResult),
                let decryptedData = decryptedString.data(using: .utf8),
                let result = try JSONSerialization.jsonObject(with: decryptedData) as? [String: Any]
            else {
                throw NSError(
                    domain: json[HNONWCcasualChic.Network.message] as? String ?? HNONWCcasualChic.Network.decryptError,
                    code: 1004
                )
            }

            return .success(result)
        } catch {
            return .failure(error)
        }
    }
}
