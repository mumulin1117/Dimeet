import UIKit

enum DMTMainArtworkFactory {
    static func avatarImage(for key: String, size: CGSize = CGSize(width: 96, height: 96)) -> UIImage {
        if let image = UIImage.dmtMealAsset(named: key) {
            return image
        }
        let palette = paletteForKey(key)
        let initials = initialsForKey(key)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            let bounds = CGRect(origin: .zero, size: size)
            let gradient = CGGradient(
                colorsSpace: CGColorSpaceCreateDeviceRGB(),
                colors: [palette.0.cgColor, palette.1.cgColor] as CFArray,
                locations: [0, 1]
            )!
            context.cgContext.drawLinearGradient(gradient, start: CGPoint(x: 0, y: 0), end: CGPoint(x: size.width, y: size.height), options: [])
            UIColor.white.withAlphaComponent(0.18).setFill()
            context.cgContext.fillEllipse(in: bounds.insetBy(dx: size.width * 0.18, dy: size.height * 0.12))

            let ringRect = bounds.insetBy(dx: size.width * 0.13, dy: size.height * 0.13)
            context.cgContext.setStrokeColor(UIColor.white.withAlphaComponent(0.45).cgColor)
            context.cgContext.setLineWidth(size.width * 0.025)
            context.cgContext.strokeEllipse(in: ringRect)

            let paragraph = NSMutableParagraphStyle()
            paragraph.alignment = .center
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: size.width * 0.34, weight: .bold),
                .foregroundColor: UIColor.white,
                .paragraphStyle: paragraph
            ]
            let textRect = CGRect(x: 0, y: size.height * 0.31, width: size.width, height: size.height * 0.34)
            initials.draw(in: textRect, withAttributes: attributes)
        }
    }

    static func sceneImage(for key: String, size: CGSize) -> UIImage {
        if let image = UIImage.dmtMealAsset(named: key) {
            return image
        }
        let palette = paletteForKey(key)
        let glyph = glyphForKey(key)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            let gradient = CGGradient(
                colorsSpace: CGColorSpaceCreateDeviceRGB(),
                colors: [palette.0.cgColor, palette.1.cgColor] as CFArray,
                locations: [0, 1]
            )!
            context.cgContext.drawLinearGradient(gradient, start: CGPoint(x: 0, y: 0), end: CGPoint(x: size.width, y: size.height), options: [])

            UIColor.white.withAlphaComponent(0.16).setFill()
            context.cgContext.fillEllipse(in: CGRect(x: -size.width * 0.16, y: size.height * 0.1, width: size.width * 0.7, height: size.width * 0.7))
            context.cgContext.fillEllipse(in: CGRect(x: size.width * 0.52, y: -size.height * 0.06, width: size.width * 0.42, height: size.width * 0.42))
            UIColor.black.withAlphaComponent(0.1).setFill()
            context.cgContext.fillEllipse(in: CGRect(x: size.width * 0.18, y: size.height * 0.58, width: size.width * 0.64, height: size.height * 0.34))

            let symbolConfig = UIImage.SymbolConfiguration(pointSize: min(size.width, size.height) * 0.24, weight: .regular)
            let symbol = UIImage(systemName: glyph, withConfiguration: symbolConfig)?
                .withTintColor(.white.withAlphaComponent(0.95), renderingMode: .alwaysOriginal)
            let symbolSize = min(size.width, size.height) * 0.24
            symbol?.draw(in: CGRect(x: size.width * 0.1, y: size.height * 0.1, width: symbolSize, height: symbolSize))
        }
    }

    private static func paletteForKey(_ key: String) -> (UIColor, UIColor) {
        switch key {
        case "story-vasquez", "room-cocoa", "clip-heartbreaker", "moment-evelyn":
            return (UIColor(red: 0.97, green: 0.43, blue: 0.49, alpha: 1), UIColor(red: 0.55, green: 0.18, blue: 0.39, alpha: 1))
        case "story-mccoya", "room-bitebreak", "moment-florence":
            return (UIColor(red: 1, green: 0.69, blue: 0.28, alpha: 1), UIColor(red: 0.97, green: 0.39, blue: 0.21, alpha: 1))
        case "story-ruiz", "clip-florence", "moment-jorge":
            return (UIColor(red: 0.57, green: 0.44, blue: 0.89, alpha: 1), UIColor(red: 0.24, green: 0.28, blue: 0.72, alpha: 1))
        case "story-matheus", "moment-denim", "gallery-ember":
            return (UIColor(red: 0.36, green: 0.76, blue: 0.87, alpha: 1), UIColor(red: 0.15, green: 0.4, blue: 0.82, alpha: 1))
        case "story-bernard", "room-midnight", "gallery-silk":
            return (UIColor(red: 0.55, green: 0.68, blue: 0.34, alpha: 1), UIColor(red: 0.24, green: 0.38, blue: 0.12, alpha: 1))
        case "mate-robot":
            return (UIColor(red: 1, green: 0.89, blue: 0.35, alpha: 1), UIColor(red: 1, green: 0.74, blue: 0.14, alpha: 1))
        case "promo-splash":
            return (UIColor(red: 0.84, green: 0.63, blue: 1, alpha: 1), UIColor(red: 0.55, green: 0.35, blue: 1, alpha: 1))
        case "nook-empty":
            return (UIColor(red: 0.45, green: 0.8, blue: 1, alpha: 1), UIColor(red: 1, green: 0.78, blue: 0.22, alpha: 1))
        default:
            return (DMTPalette.peach, DMTPalette.sunrise)
        }
    }

    private static func initialsForKey(_ key: String) -> String {
        switch key {
        case "story-vasquez":
            return "V"
        case "story-mccoya":
            return "M"
        case "story-ruiz":
            return "R"
        case "story-matheus":
            return "M"
        case "story-bernard":
            return "B"
        default:
            return "D"
        }
    }

    private static func glyphForKey(_ key: String) -> String {
        switch key {
        case "mate-robot":
            return "sparkles"
        case "promo-splash":
            return "gift.fill"
        case "nook-empty":
            return "book.closed.fill"
        case "clip-heartbreaker", "clip-florence":
            return "play.circle.fill"
        case "gallery-ember", "gallery-silk":
            return "fork.knife.circle.fill"
        default:
            return "person.fill.viewfinder"
        }
    }
}
