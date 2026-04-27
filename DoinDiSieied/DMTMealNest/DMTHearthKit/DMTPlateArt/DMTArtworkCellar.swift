import UIKit

final class DMTArtworkCellar {
    static let shared = DMTArtworkCellar()
    private static let pantryFolder = "DMTCipherPantry"

    private struct DMTArtworkSeal: Decodable {
        let file: String
        let scale: CGFloat
    }

    private let platedCache = NSCache<NSString, UIImage>()
    private let bundle: Bundle
    private let sealedCatalog: [String: DMTArtworkSeal]

    private init(bundle: Bundle = .main) {
        self.bundle = bundle
        sealedCatalog = Self.unsealCatalog(bundle: bundle)
    }

    func image(named key: String) -> UIImage? {
        if let cachedTaste = platedCache.object(forKey: key as NSString) {
            return cachedTaste
        }

        guard
            let sealedAsset = sealedCatalog[key],
            let sealedURL = sealedURL(for: sealedAsset.file),
            let sealedPlate = try? Data(contentsOf: sealedURL)
        else {
            return nil
        }

        let openedPlate = DMTCipherKitchen.reveal(sealedPlate)

        guard let image = UIImage(data: openedPlate, scale: sealedAsset.scale) else {
            return nil
        }

        platedCache.setObject(image, forKey: key as NSString)
        return image
    }

    private static func unsealCatalog(bundle: Bundle) -> [String: DMTArtworkSeal] {
        guard
            let catalogURL =
                bundle.url(forResource: "dmt_artindex", withExtension: "dat", subdirectory: pantryFolder) ??
                bundle.url(forResource: "dmt_artindex", withExtension: "dat"),
            let sealedCatalog = try? Data(contentsOf: catalogURL)
        else {
            return [:]
        }

        let openedCatalog = DMTCipherKitchen.reveal(sealedCatalog)
        let decoder = JSONDecoder()
        return (try? decoder.decode([String: DMTArtworkSeal].self, from: openedCatalog)) ?? [:]
    }

    private func sealedURL(for file: String) -> URL? {
        bundle.url(forResource: file, withExtension: "dat", subdirectory: Self.pantryFolder) ??
        bundle.url(forResource: file, withExtension: "dat")
    }
}

extension UIImage {
    static func dmtMealAsset(named key: String) -> UIImage? {
        DMTArtworkCellar.shared.image(named: key)
    }
}
