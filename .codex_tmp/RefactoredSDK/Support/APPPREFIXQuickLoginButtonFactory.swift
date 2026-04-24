import UIKit

enum APPPREFIXQuickLoginButtonFactory {
    static func makeButton() -> UIButton {
        let button = UIButton(type: .custom)
        let config = TgextileLuster.shared
        let theme = config.APPPREFIX_theme

        if !theme.loginButtonBackgroundImageName.isEmpty {
            button.setBackgroundImage(UIImage(named: theme.loginButtonBackgroundImageName), for: .normal)
        } else {
            button.backgroundColor = .white
            button.layer.cornerRadius = 10
            button.layer.masksToBounds = true
        }

        button.setTitle(config.APPPREFIX_messages.quickLoginTitle, for: .normal)
        button.setTitleColor(theme.loginButtonTextColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
}
