import UIKit

final class DMTStoryChipView: UIView {
    private let storyAvatarView = UIImageView()
    private let storyRingView = UIView()
    private let storyNameLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        composeLayout()
    }

    required init?(coder: NSCoder) {
        nil
    }

    func renderStoryChip(story: DMTStoryChip) {
        storyAvatarView.dmtSetMealImage(
            source: story.artKey,
            placeholder: DMTMainArtworkFactory.avatarImage(for: story.id)
        )
        storyRingView.layer.borderColor = (story.isActive ? UIColor(red: 1, green: 0.42, blue: 0.45, alpha: 1) : UIColor.clear).cgColor
        storyRingView.layer.borderWidth = story.isActive ? DMTScale.r(2.5) : 0
        storyNameLabel.text = story.name
    }

    private func composeLayout() {
        storyRingView.translatesAutoresizingMaskIntoConstraints = false
        storyRingView.layer.cornerRadius = DMTScale.r(34)

        storyAvatarView.translatesAutoresizingMaskIntoConstraints = false
        storyAvatarView.layer.cornerRadius = DMTScale.r(30)
        storyAvatarView.clipsToBounds = true
        storyAvatarView.contentMode = .scaleAspectFill

        storyNameLabel.translatesAutoresizingMaskIntoConstraints = false
        storyNameLabel.font = UIFont.systemFont(ofSize: 11, weight: .medium)
        storyNameLabel.textColor = DMTPalette.ink
        storyNameLabel.textAlignment = .center

        addSubview(storyRingView)
        storyRingView.addSubview(storyAvatarView)
        addSubview(storyNameLabel)

        NSLayoutConstraint.activate([
            storyRingView.topAnchor.constraint(equalTo: topAnchor),
            storyRingView.centerXAnchor.constraint(equalTo: centerXAnchor),
            storyRingView.widthAnchor.constraint(equalToConstant: DMTScale.w(68)),
            storyRingView.heightAnchor.constraint(equalToConstant: DMTScale.w(68)),

            storyAvatarView.topAnchor.constraint(equalTo: storyRingView.topAnchor, constant: DMTScale.w(4)),
            storyAvatarView.leadingAnchor.constraint(equalTo: storyRingView.leadingAnchor, constant: DMTScale.w(4)),
            storyAvatarView.trailingAnchor.constraint(equalTo: storyRingView.trailingAnchor, constant: -DMTScale.w(4)),
            storyAvatarView.bottomAnchor.constraint(equalTo: storyRingView.bottomAnchor, constant: -DMTScale.w(4)),

            storyNameLabel.topAnchor.constraint(equalTo: storyRingView.bottomAnchor, constant: DMTScale.h(6)),
            storyNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            storyNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            storyNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
