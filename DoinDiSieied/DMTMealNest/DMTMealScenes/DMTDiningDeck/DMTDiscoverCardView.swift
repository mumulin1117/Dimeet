import UIKit

final class DMTDiscoverCardView: UIControl {
    var onAvatarTap: (() -> Void)?

    private let artView = UIImageView()
    private let avatarView = UIImageView()
    private let avatarButton = UIButton(type: .system)
    private let leftBadgeView = UIImageView()
    private let leftBadge = UILabel()
    private let rightBadge = UILabel()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        composeLayout()
        rightBadge.isHidden = true
    }

    required init?(coder: NSCoder) {
        nil
    }

    func apply(moment: DMTMomentCard) {
        artView.dmtSetMealImage(
            source: moment.artKey,
            placeholder: DMTMainArtworkFactory.sceneImage(for: moment.id, size: CGSize(width: 360, height: 440))
        )
        avatarView.dmtSetMealImage(
            source: moment.avatarKey,
            placeholder: DMTMainArtworkFactory.avatarImage(for: moment.author, size: CGSize(width: 64, height: 64))
        )
        leftBadgeView.image = UIImage.dmtMealAsset(named: moment.modeTag == DMTStringCellar.shared.serve("copy.modeAudio") ? DMTPlateStamp.audioModeBadge : DMTPlateStamp.pictureModeBadge)
        leftBadge.text = moment.modeTag
        rightBadge.text = moment.sideTag
        titleLabel.text = moment.dish
        subtitleLabel.text = moment.note
        leftBadgeView.isHidden = false
        leftBadge.isHidden = false
        rightBadge.isHidden = false
        avatarView.isHidden = false
        titleLabel.isHidden = false
        subtitleLabel.isHidden = false
    }

    func applyGallery(artKey: String) {
        artView.dmtSetMealImage(
            source: artKey,
            placeholder: DMTMainArtworkFactory.sceneImage(for: artKey, size: CGSize(width: 300, height: 200))
        )
        leftBadgeView.isHidden = true
        leftBadge.isHidden = true
        rightBadge.isHidden = true
        avatarView.isHidden = true
        titleLabel.isHidden = true
        subtitleLabel.isHidden = true
    }

    private func composeLayout() {
        layer.cornerRadius = DMTScale.r(20)
        clipsToBounds = true

        artView.translatesAutoresizingMaskIntoConstraints = false
        artView.contentMode = .scaleAspectFill

        avatarView.translatesAutoresizingMaskIntoConstraints = false
        avatarView.contentMode = .scaleAspectFill
        avatarView.layer.cornerRadius = DMTScale.r(17)
        avatarView.clipsToBounds = true
        avatarView.layer.borderWidth = 1.5
        avatarView.layer.borderColor = UIColor.white.cgColor

        avatarButton.translatesAutoresizingMaskIntoConstraints = false
        avatarButton.backgroundColor = .clear
        avatarButton.addTarget(self, action: #selector(handleAvatarTap), for: .touchUpInside)

        leftBadgeView.translatesAutoresizingMaskIntoConstraints = false
        leftBadgeView.contentMode = .scaleToFill

        [leftBadge, rightBadge].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.textColor = .white
            $0.font = UIFont.systemFont(ofSize: 11, weight: .bold)
            $0.textAlignment = .center
        }
        rightBadge.backgroundColor = UIColor.white.withAlphaComponent(0.26)
        rightBadge.layer.cornerRadius = DMTScale.r(7)
        rightBadge.clipsToBounds = true

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        titleLabel.textColor = .white

        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = UIFont.systemFont(ofSize: 11, weight: .medium)
        subtitleLabel.textColor = UIColor.white.withAlphaComponent(0.92)
        subtitleLabel.numberOfLines = 1

        addSubview(artView)
        addSubview(avatarView)
        addSubview(avatarButton)
        addSubview(leftBadgeView)
        addSubview(leftBadge)
        addSubview(rightBadge)
        addSubview(titleLabel)
        addSubview(subtitleLabel)

        NSLayoutConstraint.activate([
            artView.topAnchor.constraint(equalTo: topAnchor),
            artView.leadingAnchor.constraint(equalTo: leadingAnchor),
            artView.trailingAnchor.constraint(equalTo: trailingAnchor),
            artView.bottomAnchor.constraint(equalTo: bottomAnchor),

            leftBadgeView.topAnchor.constraint(equalTo: topAnchor, constant: DMTScale.h(10)),
            leftBadgeView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: DMTScale.w(10)),
            leftBadgeView.widthAnchor.constraint(equalToConstant: DMTScale.w(48)),
            leftBadgeView.heightAnchor.constraint(equalToConstant: DMTScale.h(16)),

            leftBadge.centerXAnchor.constraint(equalTo: leftBadgeView.centerXAnchor),
            leftBadge.centerYAnchor.constraint(equalTo: leftBadgeView.centerYAnchor),
            leftBadge.widthAnchor.constraint(greaterThanOrEqualToConstant: DMTScale.w(40)),

            rightBadge.topAnchor.constraint(equalTo: topAnchor, constant: DMTScale.h(10)),
            rightBadge.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -DMTScale.w(10)),
            rightBadge.widthAnchor.constraint(greaterThanOrEqualToConstant: DMTScale.w(42)),
            rightBadge.heightAnchor.constraint(equalToConstant: DMTScale.h(22)),

            avatarView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: DMTScale.w(12)),
            avatarView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -DMTScale.h(66)),
            avatarView.widthAnchor.constraint(equalToConstant: DMTScale.w(34)),
            avatarView.heightAnchor.constraint(equalToConstant: DMTScale.w(34)),

            avatarButton.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor),
            avatarButton.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),
            avatarButton.widthAnchor.constraint(equalToConstant: DMTScale.w(42)),
            avatarButton.heightAnchor.constraint(equalToConstant: DMTScale.w(42)),

            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: DMTScale.w(12)),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -DMTScale.w(12)),
            titleLabel.bottomAnchor.constraint(equalTo: subtitleLabel.topAnchor, constant: -DMTScale.h(4)),

            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: DMTScale.w(12)),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -DMTScale.w(12)),
            subtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -DMTScale.h(12))
        ])
    }

    @objc
    private func handleAvatarTap() {
        onAvatarTap?()
    }
}
