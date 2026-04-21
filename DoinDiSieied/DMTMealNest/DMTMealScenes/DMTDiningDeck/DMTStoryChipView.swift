import UIKit

final class DMTStoryChipView: UIView {
    private let imageView = UIImageView()
    private let ringView = UIView()
    private let nameLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        configureLayout()
    }

    required init?(coder: NSCoder) {
        nil
    }

    func apply(story: DMTStoryChip) {
        imageView.dmtSetMealImage(
            source: story.artKey,
            placeholder: DMTMainArtworkFactory.avatarImage(for: story.id)
        )
        ringView.layer.borderColor = (story.isActive ? UIColor(red: 1, green: 0.42, blue: 0.45, alpha: 1) : UIColor.clear).cgColor
        ringView.layer.borderWidth = story.isActive ? DMTScale.r(2.5) : 0
        nameLabel.text = story.name
    }

    private func configureLayout() {
        ringView.translatesAutoresizingMaskIntoConstraints = false
        ringView.layer.cornerRadius = DMTScale.r(34)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = DMTScale.r(30)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.systemFont(ofSize: 11, weight: .medium)
        nameLabel.textColor = DMTPalette.ink
        nameLabel.textAlignment = .center

        addSubview(ringView)
        ringView.addSubview(imageView)
        addSubview(nameLabel)

        NSLayoutConstraint.activate([
            ringView.topAnchor.constraint(equalTo: topAnchor),
            ringView.centerXAnchor.constraint(equalTo: centerXAnchor),
            ringView.widthAnchor.constraint(equalToConstant: DMTScale.w(68)),
            ringView.heightAnchor.constraint(equalToConstant: DMTScale.w(68)),

            imageView.topAnchor.constraint(equalTo: ringView.topAnchor, constant: DMTScale.w(4)),
            imageView.leadingAnchor.constraint(equalTo: ringView.leadingAnchor, constant: DMTScale.w(4)),
            imageView.trailingAnchor.constraint(equalTo: ringView.trailingAnchor, constant: -DMTScale.w(4)),
            imageView.bottomAnchor.constraint(equalTo: ringView.bottomAnchor, constant: -DMTScale.w(4)),

            nameLabel.topAnchor.constraint(equalTo: ringView.bottomAnchor, constant: DMTScale.h(6)),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
