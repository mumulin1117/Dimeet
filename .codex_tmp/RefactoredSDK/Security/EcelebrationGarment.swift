import CommonCrypto
import Foundation

struct EcelebrationGarment {
    private let APPPREFIX_aesKeyData: Data
    private let APPPREFIX_aesIVData: Data

    init?() {
        guard
            let key = TgextileLuster.shared.APPPREFIX_aesKey.data(using: .utf8),
            let iv = TgextileLuster.shared.APPPREFIX_aesIV.data(using: .utf8)
        else {
            return nil
        }

        APPPREFIX_aesKeyData = key
        APPPREFIX_aesIVData = iv
    }

    func APPPREFIX_encrypt(_ APPPREFIX_text: String) -> String? {
        guard let data = APPPREFIX_text.data(using: .utf8) else { return nil }
        return APPPREFIX_aesProcess(APPPREFIX_input: data, APPPREFIX_operation: kCCEncrypt)?.APPPREFIX_hexString()
    }

    func APPPREFIX_decrypt(APPPREFIX_base64String: String) -> String? {
        guard let data = Data(APPPREFIX_hexist: APPPREFIX_base64String) else { return nil }
        return APPPREFIX_aesProcess(APPPREFIX_input: data, APPPREFIX_operation: kCCDecrypt)?.APPPREFIX_utf8ArtString()
    }

    private func APPPREFIX_aesProcess(APPPREFIX_input: Data, APPPREFIX_operation: Int) -> Data? {
        let outputLength = APPPREFIX_input.count + kCCBlockSizeAES128
        var outputData = Data(count: outputLength)
        var movedBytes: size_t = 0

        let status = outputData.withUnsafeMutableBytes { outputBuffer in
            APPPREFIX_input.withUnsafeBytes { inputBuffer in
                APPPREFIX_aesIVData.withUnsafeBytes { ivBuffer in
                    APPPREFIX_aesKeyData.withUnsafeBytes { keyBuffer in
                        CCCrypt(
                            CCOperation(APPPREFIX_operation),
                            CCAlgorithm(kCCAlgorithmAES),
                            CCOptions(kCCOptionPKCS7Padding),
                            keyBuffer.baseAddress,
                            APPPREFIX_aesKeyData.count,
                            ivBuffer.baseAddress,
                            inputBuffer.baseAddress,
                            APPPREFIX_input.count,
                            outputBuffer.baseAddress,
                            outputLength,
                            &movedBytes
                        )
                    }
                }
            }
        }

        guard status == kCCSuccess else { return nil }
        outputData.removeSubrange(movedBytes..<outputData.count)
        return outputData
    }
}
