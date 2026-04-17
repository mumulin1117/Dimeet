import UIKit

final class DMTDiscoverCardView: UIControl {
    private let artView = UIImageView()
    private let leftBadge = UILabel()
    private let rightBadge = UILabel()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        configureLayout()
    }

    required init?(coder: NSCoder) {
        nil
    }

    func apply(moment: DMTMomentCard) {
        artView.image = DMTMainArtworkFactory.sceneImage(for: moment.artKey, size: CGSize(width: 360, height: 440))
        leftBadge.text = moment.modeTag
        rightBadge.text = moment.sideTag
        titleLabel.text = moment.author
        subtitleLabel.text = moment.dish
    }

    func applyGallery(artKey: String) {
        artView.image = DMTMainArtworkFactory.sceneImage(for: artKey, size: CGSize(width: 300, height: 200))
        leftBadge.isHidden = true
        rightBadge.isHidden = true
        titleLabel.isHidden = true
        subtitleLabel.isHidden = true
    }

    private func configureLayout() {
        layer.cornerRadius = DMTScale.r(20)
        clipsToBounds = true

        artView.translatesAutoresizingMaskIntoConstraints = false
        artView.contentMode = .scaleAspectFill

        [leftBadge, rightBadge].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.backgroundColor = UIColor.white.withAlphaComponent(0.26)
            $0.textColor = .white
            $0.font = UIFont.systemFont(ofSize: 11, weight: .bold)
            $0.textAlignment = .center
            $0.layer.cornerRadius = DMTScale.r(7)
            $0.clipsToBounds = true
        }

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .white

        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        subtitleLabel.textColor = UIColor.white.withAlphaComponent(0.92)
        subtitleLabel.numberOfLines = 2

        addSubview(artView)
        addSubview(leftBadge)
        addSubview(rightBadge)
        addSubview(titleLabel)
        addSubview(subtitleLabel)

        NSLayoutConstraint.activate([
            artView.topAnchor.constraint(equalTo: topAnchor),
            artView.leadingAnchor.constraint(equalTo: leadingAnchor),
            artView.trailingAnchor.constraint(equalTo: trailingAnchor),
            artView.bottomAnchor.constraint(equalTo: bottomAnchor),

            leftBadge.topAnchor.constraint(equalTo: topAnchor, constant: DMTScale.h(10)),
            leftBadge.leadingAnchor.constraint(equalTo: leadingAnchor, constant: DMTScale.w(10)),
            leftBadge.widthAnchor.constraint(greaterThanOrEqualToConstant: DMTScale.w(48)),
            leftBadge.heightAnchor.constraint(equalToConstant: DMTScale.h(22)),

            rightBadge.topAnchor.constraint(equalTo: topAnchor, constant: DMTScale.h(10)),
            rightBadge.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -DMTScale.w(10)),
            rightBadge.widthAnchor.constraint(greaterThanOrEqualToConstant: DMTScale.w(42)),
            rightBadge.heightAnchor.constraint(equalToConstant: DMTScale.h(22)),

            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: DMTScale.w(12)),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -DMTScale.w(12)),
            titleLabel.bottomAnchor.constraint(equalTo: subtitleLabel.topAnchor, constant: -DMTScale.h(4)),

            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: DMTScale.w(12)),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -DMTScale.w(12)),
            subtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -DMTScale.h(12))
        ])
    }
}
