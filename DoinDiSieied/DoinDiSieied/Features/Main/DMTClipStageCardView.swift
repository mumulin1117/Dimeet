import UIKit

final class DMTClipStageCardView: UIControl {
    private let artView = UIImageView()
    private let playButton = UIButton(type: .system)
    private let avatarView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let actionStack = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        configureLayout()
    }

    required init?(coder: NSCoder) {
        nil
    }

    func apply(clip: DMTClipCard) {
        artView.image = DMTMainArtworkFactory.sceneImage(for: clip.artKey, size: CGSize(width: 720, height: 1200))
        avatarView.image = DMTMainArtworkFactory.avatarImage(for: clip.avatarKey, size: CGSize(width: 72, height: 72))
        titleLabel.text = clip.title
        subtitleLabel.text = clip.subtitle

        actionStack.arrangedSubviews.forEach {
            actionStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        let actions = [
            ("heart.fill", clip.likesLine, UIColor(red: 1, green: 0.44, blue: 0.48, alpha: 1)),
            ("bubble.right", clip.talksLine, UIColor.white),
            ("plus", clip.accentTitle, UIColor.white)
        ]

        for action in actions {
            let shell = UIStackView()
            shell.axis = .vertical
            shell.alignment = .center
            shell.spacing = DMTScale.h(6)

            let bubble = UIView()
            bubble.translatesAutoresizingMaskIntoConstraints = false
            bubble.backgroundColor = action.2 == .white ? UIColor.white.withAlphaComponent(0.2) : UIColor.white
            bubble.layer.cornerRadius = DMTScale.r(24)

            let icon = UIImageView(image: UIImage(systemName: action.0))
            icon.translatesAutoresizingMaskIntoConstraints = false
            icon.tintColor = action.2 == .white ? UIColor.white : action.2
            bubble.addSubview(icon)

            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
            label.textColor = .white
            label.text = action.1

            shell.addArrangedSubview(bubble)
            shell.addArrangedSubview(label)
            NSLayoutConstraint.activate([
                bubble.widthAnchor.constraint(equalToConstant: DMTScale.w(48)),
                bubble.heightAnchor.constraint(equalToConstant: DMTScale.w(48)),
                icon.centerXAnchor.constraint(equalTo: bubble.centerXAnchor),
                icon.centerYAnchor.constraint(equalTo: bubble.centerYAnchor)
            ])
            actionStack.addArrangedSubview(shell)
        }
    }

    private func configureLayout() {
        layer.cornerRadius = DMTScale.r(28)
        clipsToBounds = true

        artView.translatesAutoresizingMaskIntoConstraints = false
        artView.contentMode = .scaleAspectFill

        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        playButton.tintColor = .white
        playButton.backgroundColor = UIColor.black.withAlphaComponent(0.26)
        playButton.layer.cornerRadius = DMTScale.r(30)
        playButton.isUserInteractionEnabled = false

        avatarView.translatesAutoresizingMaskIntoConstraints = false
        avatarView.layer.cornerRadius = DMTScale.r(22)
        avatarView.clipsToBounds = true
        avatarView.layer.borderWidth = 2
        avatarView.layer.borderColor = UIColor.white.cgColor

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        titleLabel.textColor = .white

        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        subtitleLabel.textColor = UIColor.white.withAlphaComponent(0.92)
        subtitleLabel.numberOfLines = 0

        actionStack.translatesAutoresizingMaskIntoConstraints = false
        actionStack.axis = .vertical
        actionStack.spacing = DMTScale.h(18)

        addSubview(artView)
        addSubview(playButton)
        addSubview(avatarView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(actionStack)

        NSLayoutConstraint.activate([
            artView.topAnchor.constraint(equalTo: topAnchor),
            artView.leadingAnchor.constraint(equalTo: leadingAnchor),
            artView.trailingAnchor.constraint(equalTo: trailingAnchor),
            artView.bottomAnchor.constraint(equalTo: bottomAnchor),

            playButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            playButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            playButton.widthAnchor.constraint(equalToConstant: DMTScale.w(60)),
            playButton.heightAnchor.constraint(equalToConstant: DMTScale.w(60)),

            avatarView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: DMTScale.w(18)),
            avatarView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -DMTScale.h(72)),
            avatarView.widthAnchor.constraint(equalToConstant: DMTScale.w(44)),
            avatarView.heightAnchor.constraint(equalToConstant: DMTScale.w(44)),

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
}
