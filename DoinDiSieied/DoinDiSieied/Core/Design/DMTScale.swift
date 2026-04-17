import UIKit

enum DMTScale {
    private static let baseWidth: CGFloat = 390
    private static let baseHeight: CGFloat = 844

    static func w(_ value: CGFloat) -> CGFloat {
        UIScreen.main.bounds.width / baseWidth * value
    }

    static func h(_ value: CGFloat) -> CGFloat {
        UIScreen.main.bounds.height / baseHeight * value
    }

    static func r(_ value: CGFloat) -> CGFloat {
        min(UIScreen.main.bounds.width / baseWidth, UIScreen.main.bounds.height / baseHeight) * value
    }
}
