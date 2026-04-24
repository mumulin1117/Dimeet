import UIKit

final class HNONWYCELRStyleSparkNotifier {
    enum HNONWYCELRState {
        case HNONWYCELRsuccess
        case HNONWYCELRerror

        var HNONWYCELRbackgroundColor: UIColor {
            switch self {
            case .HNONWYCELRsuccess:
                return UIColor(red: 0.20, green: 0.70, blue: 0.30, alpha: 0.95)
            case .HNONWYCELRerror:
                return UIColor(red: 0.90, green: 0.30, blue: 0.30, alpha: 0.95)
            }
        }

        var HNONWYCELRicon: UIImage? {
            switch self {
            case .HNONWYCELRsuccess:
                return UIImage(systemName: "checkmark.circle.fill")
            case .HNONWYCELRerror:
                return UIImage(systemName: "xmark.octagon.fill")
            }
        }
    }

    static func HNONWYCELRshow(
        HNONWYCELRmessage: String,
        HNONWYCELRstate: HNONWYCELRState,
        HNONWYCELRin viewController: UIViewController
    ) {
        let superview = viewController.view!
        let toast = UIView()
        let iconView = UIImageView()
        let messageLabel = UILabel()
        let topConstraint = toast.topAnchor.constraint(equalTo: superview.topAnchor, constant: -60)

        toast.translatesAutoresizingMaskIntoConstraints = false
        toast.backgroundColor = HNONWYCELRstate.HNONWYCELRbackgroundColor
        toast.layer.cornerRadius = 8
        toast.clipsToBounds = true

        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.image = HNONWYCELRstate.HNONWYCELRicon?.withTintColor(.white, renderingMode: .alwaysOriginal)
        iconView.contentMode = .scaleAspectFit

        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.text = HNONWYCELRmessage
        messageLabel.textColor = .white
        messageLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        messageLabel.numberOfLines = 0

        toast.addSubview(iconView)
        toast.addSubview(messageLabel)
        superview.addSubview(toast)

        NSLayoutConstraint.activate([
            topConstraint,
            toast.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            toast.leadingAnchor.constraint(greaterThanOrEqualTo: superview.leadingAnchor, constant: 20),
            toast.trailingAnchor.constraint(lessThanOrEqualTo: superview.trailingAnchor, constant: -20),
            toast.widthAnchor.constraint(lessThanOrEqualTo: superview.widthAnchor, constant: -40),
            toast.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),

            iconView.leadingAnchor.constraint(equalTo: toast.leadingAnchor, constant: 12),
            iconView.centerYAnchor.constraint(equalTo: toast.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 24),
            iconView.heightAnchor.constraint(equalToConstant: 24),

            messageLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 8),
            messageLabel.trailingAnchor.constraint(equalTo: toast.trailingAnchor, constant: -12),
            messageLabel.topAnchor.constraint(equalTo: toast.topAnchor, constant: 12),
            messageLabel.bottomAnchor.constraint(equalTo: toast.bottomAnchor, constant: -12)
        ])

        superview.layoutIfNeeded()
        topConstraint.constant = viewController.view.safeAreaInsets.top + 10

        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut) {
            superview.layoutIfNeeded()
        } completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                topConstraint.constant = -toast.frame.height - 10
                UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseIn) {
                    superview.layoutIfNeeded()
                } completion: { _ in
                    toast.removeFromSuperview()
                }
            }
        }
    }
}
