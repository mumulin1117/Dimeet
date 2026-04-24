import Foundation

enum APPPREFIXSessionAssembler {
    static func APPPREFIX_buildWebEntryURL(openValue: String, token: String) -> String? {
        let payload: [String: Any] = [
            HNONWCcasualChic.LaunchResponse.token: token,
            HNONWCcasualChic.LaunchResponse.timestamp: "\(Int(Date().timeIntervalSince1970))"
        ]

        guard
            let json = HNONWCEsilkDrape.APPPREFIX_jsonString(APPPREFIX_from: payload),
            let cipher = EcelebrationGarment(),
            let encrypted = cipher.APPPREFIX_encrypt(json)
        else {
            return nil
        }

        return openValue
        + HNONWCcasualChic.LaunchResponse.openParams
        + encrypted
        + HNONWCcasualChic.LaunchResponse.appID
        + TgextileLuster.shared.APPPREFIX_appId
    }

    static func APPPREFIX_buildPaymentCallbackJSON(orderCode: String) -> String? {
        let payload = [HNONWCcasualChic.Payment.orderCode: orderCode]
        guard let data = try? JSONSerialization.data(withJSONObject: payload, options: [.prettyPrinted]) else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }
}
