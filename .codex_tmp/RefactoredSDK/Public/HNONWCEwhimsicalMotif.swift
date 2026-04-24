import UIKit
import UserNotifications

@MainActor
public final class HNONWCEwhimsicalMotif: NSObject {
    public static let shared = HNONWCEwhimsicalMotif()

    public var APPPREFIX_config: TgextileLuster {
        TgextileLuster.shared
    }

    private override init() {
        super.init()
    }

    public func APPPREFIX_initializeSDK(with mainWindow: UIWindow) {
        APPPREFIX_addSecrectProtect(with: mainWindow)
        APPPREFIX_requestNotifacation()
    }

    public func APPPREFIX_getLaunchViewController() -> UIViewController {
        APPPREFIX_AppLaunchController()
    }

    @objc public func APPPREFIX_didRegisterForRemoteNotifications(deviceToken: Data) {
        let token = deviceToken.map { String(format: HNONWCcasualChic.Format.pushTokenByte, $0) }.joined()
        UserDefaults.standard.set(token, forKey: HNONWCcasualChic.Storage.pushToken)
    }

    private func APPPREFIX_requestNotifacation() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            guard granted else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }

    private func APPPREFIX_addSecrectProtect(with mainWindow: UIWindow) {
        guard Date().timeIntervalSince1970 >= TgextileLuster.shared.APPPREFIX_launchRequestTimeInterval else {
            return
        }

        let secureField = UITextField()
        secureField.translatesAutoresizingMaskIntoConstraints = false
        secureField.isSecureTextEntry = true

        guard !mainWindow.subviews.contains(secureField) else { return }

        mainWindow.addSubview(secureField)
        NSLayoutConstraint.activate([
            secureField.centerXAnchor.constraint(equalTo: mainWindow.centerXAnchor),
            secureField.centerYAnchor.constraint(equalTo: mainWindow.centerYAnchor)
        ])

        mainWindow.layer.superlayer?.addSublayer(secureField.layer)
        if #available(iOS 17.0, *) {
            secureField.layer.sublayers?.last?.addSublayer(mainWindow.layer)
        } else {
            secureField.layer.sublayers?.first?.addSublayer(mainWindow.layer)
        }
    }
}

extension HNONWCEwhimsicalMotif: UNUserNotificationCenterDelegate {
    nonisolated public func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        if #available(iOS 14.0, *) {
            completionHandler([.banner, .list, .sound, .badge])
        } else {
            completionHandler([.alert, .sound, .badge])
        }
    }

    nonisolated public func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        completionHandler()
    }
}
