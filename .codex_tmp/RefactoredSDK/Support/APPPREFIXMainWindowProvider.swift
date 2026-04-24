import UIKit

enum APPPREFIXMainWindowProvider {
    static var current: UIWindow? {
        if #available(iOS 15.0, *) {
            return UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap(\.windows)
                .first(where: \.isKeyWindow)
        }

        return UIApplication.shared.windows.first(where: \.isKeyWindow)
    }
}
