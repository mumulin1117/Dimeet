import UIKit
import ObjectiveC

final class DMTImageHarbor {
    static let shared = DMTImageHarbor()

    private let cache = NSCache<NSString, UIImage>()
    private let session: URLSession

    private init() {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForRequest = 20
        configuration.timeoutIntervalForResource = 20
        session = URLSession(configuration: configuration)
    }

    func image(for source: String) async -> UIImage? {
        let normalizedSource = normalizedSource(for: source)

        if let cached = cache.object(forKey: normalizedSource as NSString) {
            return cached
        }

        guard
            let url = URL(string: normalizedSource),
            let scheme = url.scheme?.lowercased(),
            scheme == "http" || scheme == "https"
        else {
            return nil
        }

        do {
            let (data, response) = try await session.data(from: url)
            guard
                let httpResponse = response as? HTTPURLResponse,
                (200..<300).contains(httpResponse.statusCode)
            else {
                return nil
            }
            guard let image = UIImage(data: data) else { return nil }
            cache.setObject(image, forKey: normalizedSource as NSString)
            return image
        } catch {
            return nil
        }
    }

    private func normalizedSource(for source: String) -> String {
        guard
            var components = URLComponents(string: source),
            components.scheme?.lowercased() == "http"
        else {
            return source
        }

        components.scheme = "https"
        return components.string ?? source
    }
}

private var DMTImageHarborSourceKey: UInt8 = 0

extension UIImageView {
    func dmtSetMealImage(source: String, placeholder: UIImage?) {
        image = placeholder

        if let localImage = UIImage.dmtMealAsset(named: source) {
            image = localImage
            return
        }

        guard
            let url = URL(string: source),
            let scheme = url.scheme?.lowercased(),
            scheme == "http" || scheme == "https"
        else {
            return
        }

        objc_setAssociatedObject(self, &DMTImageHarborSourceKey, source as NSString, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

        Task { [weak self] in
            guard let image = await DMTImageHarbor.shared.image(for: url.absoluteString) else {
                return
            }
            await MainActor.run {
                guard
                    let self,
                    let current = objc_getAssociatedObject(self, &DMTImageHarborSourceKey) as? NSString,
                    current as String == source
                else {
                    return
                }

                self.image = image
            }
        }
    }
}
