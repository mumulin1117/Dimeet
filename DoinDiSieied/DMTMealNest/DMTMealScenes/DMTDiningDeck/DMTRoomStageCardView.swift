import UIKit

final class DMTRoomStageCardView: UIControl {
    var onInfoTap: (() -> Void)?

    private let imageView = UIImageView()
    private let onlineBadge = UILabel()
    private let infoButton = UIButton(type: .system)
    private let avatarStack = UIStackView()
    private let titleLabel = UILabel()
    private let captionLabel = UILabel()
    private let accentBadge = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        composeLayout()
    }

    required init?(coder: NSCoder) {
        nil
    }

    func apply(room: DMTRoomCard) {
        imageView.dmtSetMealImage(
            source: room.artKey,
            placeholder: DMTMainArtworkFactory.sceneImage(for: room.id, size: CGSize(width: 720, height: 520))
        )
        onlineBadge.text = "  \(room.onlineCount) Online  "
        titleLabel.text = room.hostName
        captionLabel.text = room.caption
        accentBadge.text = room.trailingAccent
        accentBadge.isHidden = room.trailingAccent == nil

        avatarStack.arrangedSubviews.forEach {
            avatarStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        for key in room.attendeeKeys.prefix(3) {
            let avatar = UIImageView()
            avatar.translatesAutoresizingMaskIntoConstraints = false
            avatar.contentMode = .scaleAspectFill
            avatar.layer.cornerRadius = DMTScale.r(14)
            avatar.clipsToBounds = true
            avatar.layer.borderColor = UIColor.white.cgColor
            avatar.layer.borderWidth = 1.5
            avatar.dmtSetMealImage(
                source: key,
                placeholder: DMTMainArtworkFactory.avatarImage(for: room.id + key, size: CGSize(width: 44, height: 44))
            )
            NSLayoutConstraint.activate([
                avatar.widthAnchor.constraint(equalToConstant: DMTScale.w(28)),
                avatar.heightAnchor.constraint(equalToConstant: DMTScale.w(28))
            ])
            avatarStack.addArrangedSubview(avatar)
        }
    }

    private func composeLayout() {
        layer.cornerRadius = DMTScale.r(22)
        clipsToBounds = true

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill

        onlineBadge.translatesAutoresizingMaskIntoConstraints = false
        onlineBadge.backgroundColor = UIColor(red: 1, green: 0.55, blue: 0.16, alpha: 1)
        onlineBadge.textColor = .white
        onlineBadge.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        onlineBadge.layer.cornerRadius = DMTScale.r(7)
        onlineBadge.clipsToBounds = true

        infoButton.translatesAutoresizingMaskIntoConstraints = false
        infoButton.setImage(UIImage(systemName: "exclamationmark.circle"), for: .normal)
        infoButton.tintColor = .white
        infoButton.backgroundColor = UIColor.black.withAlphaComponent(0.18)
        infoButton.layer.cornerRadius = DMTScale.r(15)
        infoButton.addTarget(self, action: #selector(handleInfoTap), for: .touchUpInside)

        avatarStack.translatesAutoresizingMaskIntoConstraints = false
        avatarStack.axis = .horizontal
        avatarStack.spacing = -DMTScale.w(8)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .white

        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        captionLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        captionLabel.textColor = UIColor.white.withAlphaComponent(0.92)
        captionLabel.numberOfLines = 2

        accentBadge.translatesAutoresizingMaskIntoConstraints = false
        accentBadge.backgroundColor = UIColor(red: 0.99, green: 0.39, blue: 0.78, alpha: 1)
        accentBadge.textColor = .white
        accentBadge.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        accentBadge.textAlignment = .center
        accentBadge.numberOfLines = 2
        accentBadge.layer.cornerRadius = DMTScale.r(18)
        accentBadge.clipsToBounds = true

        addSubview(imageView)
        addSubview(onlineBadge)
        addSubview(infoButton)
        addSubview(avatarStack)
        addSubview(titleLabel)
        addSubview(captionLabel)
        addSubview(accentBadge)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),

            onlineBadge.topAnchor.constraint(equalTo: topAnchor, constant: DMTScale.h(14)),
            onlineBadge.leadingAnchor.constraint(equalTo: leadingAnchor, constant: DMTScale.w(14)),
            onlineBadge.heightAnchor.constraint(equalToConstant: DMTScale.h(24)),

            infoButton.topAnchor.constraint(equalTo: topAnchor, constant: DMTScale.h(14)),
            infoButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -DMTScale.w(14)),
            infoButton.widthAnchor.constraint(equalToConstant: DMTScale.w(30)),
            infoButton.heightAnchor.constraint(equalToConstant: DMTScale.w(30)),

            avatarStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: DMTScale.w(16)),
            avatarStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -DMTScale.h(82)),

            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: DMTScale.w(16)),
            titleLabel.bottomAnchor.constraint(equalTo: captionLabel.topAnchor, constant: -DMTScale.h(4)),
            titleLabel.trailingAnchor.constraint(equalTo: accentBadge.leadingAnchor, constant: -DMTScale.w(12)),

            captionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: DMTScale.w(16)),
            captionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -DMTScale.w(16)),
            captionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -DMTScale.h(16)),

            accentBadge.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            accentBadge.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -DMTScale.w(14)),
            accentBadge.widthAnchor.constraint(equalToConstant: DMTScale.w(112)),
            accentBadge.heightAnchor.constraint(equalToConstant: DMTScale.h(44))
        ])
    }

    @objc
    private func handleInfoTap() {
        onInfoTap?()
    }
}
