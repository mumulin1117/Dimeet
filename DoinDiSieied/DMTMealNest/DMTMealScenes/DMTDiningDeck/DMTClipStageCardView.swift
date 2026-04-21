import UIKit

final class DMTClipStageCardView: UIControl {
    var onAvatarTap: (() -> Void)?
    var onChatTap: (() -> Void)?
    var onReportTap: (() -> Void)?

    private let artView = UIImageView()
    private let alertButton = UIButton(type: .system)
    private let playButton = UIButton(type: .system)
    private let focusButton = UIButton()
    private let avatarView = UIImageView()
    private let avatarButton = UIButton(type: .system)
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let actionStack = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        composeLayout()
        focusButton.setImage(UIImage.dmtMealAsset(named: DMTPlateStamp.focusOrb), for: .normal)
        playButton.isUserInteractionEnabled = false
        focusButton.isUserInteractionEnabled = false
    }

    required init?(coder: NSCoder) {
        nil
    }

    func apply(clip: DMTClipCard) {
        artView.dmtSetMealImage(
            source: clip.artKey,
            placeholder: DMTMainArtworkFactory.sceneImage(for: clip.id, size: CGSize(width: 720, height: 1200))
        )
        avatarView.dmtSetMealImage(
            source: clip.avatarKey,
            placeholder: DMTMainArtworkFactory.avatarImage(for: clip.creatorName, size: CGSize(width: 72, height: 72))
        )
        titleLabel.text = clip.title
        subtitleLabel.text = clip.subtitle

        actionStack.arrangedSubviews.forEach {
            actionStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    
        let actions = [
            (DMTPlateStamp.actionLike, clip.likesLine),
            (DMTPlateStamp.actionTalk, clip.talksLine)
        ]

        for action in actions {
            let shell = UIStackView()
            shell.axis = .vertical
            shell.alignment = .center
            shell.spacing = DMTScale.h(6)

            let bubble = UIImageView(image: UIImage.dmtMealAsset(named: action.0))
            bubble.translatesAutoresizingMaskIntoConstraints = false
            bubble.contentMode = .scaleAspectFit

            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
            label.textColor = .white
            label.text = action.1

            shell.addArrangedSubview(bubble)
            shell.addArrangedSubview(label)
            NSLayoutConstraint.activate([
                bubble.widthAnchor.constraint(equalToConstant: DMTScale.w(48)),
                bubble.heightAnchor.constraint(equalToConstant: DMTScale.w(48))
            ])
            actionStack.addArrangedSubview(shell)
        }
    }

    private func composeLayout() {
        layer.cornerRadius = DMTScale.r(28)
        clipsToBounds = true
        focusButton.translatesAutoresizingMaskIntoConstraints = false
        focusButton.setImage(UIImage.dmtMealAsset(named: DMTPlateStamp.focusBadge), for: .normal)
        alertButton.setImage(UIImage.dmtMealAsset(named: DMTPlateStamp.reportOrb), for: .normal)
        artView.translatesAutoresizingMaskIntoConstraints = false
        artView.contentMode = .scaleAspectFill
        alertButton.translatesAutoresizingMaskIntoConstraints = false
        alertButton.addTarget(self, action: #selector(handleReportTap), for: .touchUpInside)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        playButton.tintColor = .white
        playButton.backgroundColor = UIColor.black.withAlphaComponent(0.26)
        playButton.layer.cornerRadius = DMTScale.r(30)
        playButton.isUserInteractionEnabled = false

        focusButton.addTarget(self, action: #selector(handleChatTap), for: .touchUpInside)

        avatarView.translatesAutoresizingMaskIntoConstraints = false
        avatarView.layer.cornerRadius = DMTScale.r(22)
        avatarView.clipsToBounds = true
        avatarView.layer.borderWidth = 2
        avatarView.layer.borderColor = UIColor.white.cgColor

        avatarButton.translatesAutoresizingMaskIntoConstraints = false
        avatarButton.backgroundColor = .clear
        avatarButton.addTarget(self, action: #selector(handleAvatarTap), for: .touchUpInside)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 2

        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        subtitleLabel.textColor = UIColor.white.withAlphaComponent(0.92)
        subtitleLabel.numberOfLines = 2

        actionStack.translatesAutoresizingMaskIntoConstraints = false
        actionStack.axis = .vertical
        actionStack.spacing = DMTScale.h(18)

        addSubview(artView)
        addSubview(playButton)
        addSubview(avatarView)
        addSubview(avatarButton)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(actionStack)
        addSubview(focusButton)
        addSubview(alertButton)
        NSLayoutConstraint.activate([
            artView.topAnchor.constraint(equalTo: topAnchor),
            artView.leadingAnchor.constraint(equalTo: leadingAnchor),
            artView.trailingAnchor.constraint(equalTo: trailingAnchor),
            artView.bottomAnchor.constraint(equalTo: bottomAnchor),
            alertButton.widthAnchor.constraint(equalToConstant: 40),
            alertButton.heightAnchor.constraint(equalToConstant: 40),
            alertButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 30),
            alertButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            
            playButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            playButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            playButton.widthAnchor.constraint(equalToConstant: DMTScale.w(60)),
            playButton.heightAnchor.constraint(equalToConstant: DMTScale.w(60)),

            avatarView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: DMTScale.w(18)),
            avatarView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -DMTScale.h(112)),
            avatarView.widthAnchor.constraint(equalToConstant: DMTScale.w(44)),
            avatarView.heightAnchor.constraint(equalToConstant: DMTScale.w(44)),

            avatarButton.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor),
            avatarButton.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),
            avatarButton.widthAnchor.constraint(equalToConstant: DMTScale.w(54)),
            avatarButton.heightAnchor.constraint(equalToConstant: DMTScale.w(54)),

            focusButton.widthAnchor.constraint(equalToConstant: 30),
            focusButton.heightAnchor.constraint(equalToConstant: 20),
            focusButton.centerYAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 0),
            focusButton.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor, constant: 0),

            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: DMTScale.w(18)),
            titleLabel.trailingAnchor.constraint(equalTo: actionStack.leadingAnchor, constant: -DMTScale.w(14)),
            titleLabel.bottomAnchor.constraint(equalTo: subtitleLabel.topAnchor, constant: -DMTScale.h(6)),

            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: DMTScale.w(18)),
            subtitleLabel.trailingAnchor.constraint(equalTo: actionStack.leadingAnchor, constant: -DMTScale.w(14)),
            subtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -DMTScale.h(24)),

            actionStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -DMTScale.w(18)),
            actionStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -DMTScale.h(38))
        ])
    }

    @objc
    private func handleAvatarTap() {
        onAvatarTap?()
    }

    @objc
    private func handleChatTap() {
        onChatTap?()
    }

    @objc
    private func handleReportTap() {
        onReportTap?()
    }
}
