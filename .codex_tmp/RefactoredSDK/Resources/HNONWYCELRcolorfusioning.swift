import CryptoKit
import Foundation
import UIKit

final class HNONWYCELRcolorfusioning {
    private static let HNONWYCELRnonceSize = 16
    private static let HNONWYCELRtagSize = 16

    static func HNONWYCELRgarmentripple(HNONWYCELRpaletteform name: String) -> UIImage? {
        guard
            let keyData = Data(APPPREFIX_hexist: TgextileLuster.shared.APPPREFIX_encryptedResourceHexKey),
            keyData.count == 32
        else {
            return nil
        }

        guard
            let url = Bundle.main.url(
                forResource: name,
                withExtension: TgextileLuster.shared.APPPREFIX_encryptedResourceExtension
            ),
            let encryptedData = try? Data(contentsOf: url)
        else {
            return nil
        }

        let tagStart = encryptedData.count - HNONWYCELRtagSize
        guard tagStart >= HNONWYCELRnonceSize else { return nil }

        let nonceData = encryptedData.prefix(HNONWYCELRnonceSize)
        let cipherData = encryptedData.subdata(in: HNONWYCELRnonceSize..<tagStart)
        let tagData = encryptedData.suffix(HNONWYCELRtagSize)

        do {
            let nonce = try AES.GCM.Nonce(data: nonceData)
            let sealedBox = try AES.GCM.SealedBox(nonce: nonce, ciphertext: cipherData, tag: tagData)
            let decrypted = try AES.GCM.open(sealedBox, using: SymmetricKey(data: keyData))
            guard let image = UIImage(data: decrypted) else { return nil }

            if let cgImage = image.cgImage {
                return UIImage(cgImage: cgImage, scale: 3, orientation: .up)
            }

            return image
        } catch {
            return nil
        }
    }
}
