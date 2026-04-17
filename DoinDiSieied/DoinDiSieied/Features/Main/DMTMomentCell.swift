import UIKit

final class DMTMomentCell: UITableViewCell {
    static let reuseID = "DMTMomentCell"

    private let shellView = UIView()
    private let authorLabel = UILabel()
    private let dishLabel = UILabel()
    private let noteLabel = UILabel()
    private let metaLabel = UILabel()
    private let heatTag = DMTTagView(fillColor: DMTPalette.mint, textColor: DMTPalette.ink)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }

    required init?(coder: NSCoder) {
        nil
    }

    func apply(moment: DMTMomentCard) {
        authorLabel.text = moment.author
        dishLabel.text = moment.dish
        noteLabel.text = moment.note
        metaLabel.text = moment.stamp
        heatTag.apply(text: moment.heatTag)
    }

    private func configure() {
        backgroundColor = .clear
        selectionStyle = .none

        shellView.translatesAutoresizingMaskIntoConstraints = false
        shellView.backgroundColor = .white
        shellView.layer.cornerRadius = DMTScale.r(24)

        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        authorLabel.textColor = DMTPalette.sunrise

        dishLabel.translatesAutoresizingMaskIntoConstraints = false
        dishLabel.font = UIFont.systemFont(ofSize: 21, weight: .bold)
        dishLabel.textColor = DMTPalette.ink
        dishLabel.numberOfLines = 0

        noteLabel.translatesAutoresizingMaskIntoConstraints = false
        noteLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        noteLabel.textColor = DMTPalette.cloudInk
        noteLabel.numberOfLines = 0

        metaLabel.translatesAutoresizingMaskIntoConstraints = false
        metaLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        metaLabel.textColor = DMTPalette.cloudInk

        contentView.addSubview(shellView)
        shellView.addSubview(authorLabel)
        shellView.addSubview(dishLabel)
        shellView.addSubview(noteLabel)
        shellView.addSubview(metaLabel)
        shellView.addSubview(heatTag)

        NSLayoutConstraint.activate([
            shellView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: DMTScale.h(6)),
            shellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            shellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            shellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -DMTScale.h(6)),

            authorLabel.topAnchor.constraint(equalTo: shellView.topAnchor, constant: DMTScale.h(18)),
            authorLabel.leadingAnchor.constraint(equalTo: shellView.leadingAnchor, constant: DMTScale.w(18)),
            authorLabel.trailingAnchor.constraint(lessThanOrEqualTo: heatTag.leadingAnchor, constant: -DMTScale.w(8)),

            heatTag.topAnchor.constraint(equalTo: shellView.topAnchor, constant: DMTScale.h(16)),
            heatTag.trailingAnchor.constraint(equalTo: shellView.trailingAnchor, constant: -DMTScale.w(16)),

            dishLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: DMTScale.h(8)),
            dishLabel.leadingAnchor.constraint(equalTo: shellView.leadingAnchor, constant: DMTScale.w(18)),
            dishLabel.trailingAnchor.constraint(equalTo: shellView.trailingAnchor, constant: -DMTScale.w(18)),

            noteLabel.topAnchor.constraint(equalTo: dishLabel.bottomAnchor, constant: DMTScale.h(8)),
            noteLabel.leadingAnchor.constraint(equalTo: shellView.leadingAnchor, constant: DMTScale.w(18)),
            noteLabel.trailingAnchor.constraint(equalTo: shellView.trailingAnchor, constant: -DMTScale.w(18)),

            metaLabel.topAnchor.constraint(equalTo: noteLabel.bottomAnchor, constant: DMTScale.h(12)),
            metaLabel.leadingAnchor.constraint(equalTo: shellView.leadingAnchor, constant: DMTScale.w(18)),
            metaLabel.trailingAnchor.constraint(equalTo: shellView.trailingAnchor, constant: -DMTScale.w(18)),
            metaLabel.bottomAnchor.constraint(equalTo: shellView.bottomAnchor, constant: -DMTScale.h(18))
        ])
    }
}
