import UIKit

final class DMTRoomCell: UITableViewCell {
    static let reuseID = "DMTRoomCell"

    private var platingCanvas: UIView { contentView }
    private let shellView = UIView()
    private let titleLabel = UILabel()
    private let topicLabel = UILabel()
    private let seatLabel = UILabel()
    private let paceTag = DMTTagView(fillColor: DMTPalette.blush, textColor: DMTPalette.sunrise)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }

    required init?(coder: NSCoder) {
        nil
    }

    func apply(room: DMTRoomCard) {
        titleLabel.text = room.title
        topicLabel.text = room.topic
        seatLabel.text = room.seatLine
        paceTag.renderTagCopy(text: room.pace)
    }

    private func configure() {
        backgroundColor = .clear
        selectionStyle = .none

        shellView.translatesAutoresizingMaskIntoConstraints = false
        shellView.backgroundColor = .white
        shellView.layer.cornerRadius = DMTScale.r(24)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        titleLabel.textColor = DMTPalette.ink
        titleLabel.numberOfLines = 0

        topicLabel.translatesAutoresizingMaskIntoConstraints = false
        topicLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        topicLabel.textColor = DMTPalette.cloudInk
        topicLabel.numberOfLines = 0

        seatLabel.translatesAutoresizingMaskIntoConstraints = false
        seatLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        seatLabel.textColor = DMTPalette.sunrise

        platingCanvas.addSubview(shellView)
        shellView.addSubview(titleLabel)
        shellView.addSubview(topicLabel)
        shellView.addSubview(seatLabel)
        shellView.addSubview(paceTag)

        NSLayoutConstraint.activate([
            shellView.topAnchor.constraint(equalTo: platingCanvas.topAnchor, constant: DMTScale.h(6)),
            shellView.leadingAnchor.constraint(equalTo: platingCanvas.leadingAnchor),
            shellView.trailingAnchor.constraint(equalTo: platingCanvas.trailingAnchor),
            shellView.bottomAnchor.constraint(equalTo: platingCanvas.bottomAnchor, constant: -DMTScale.h(6)),

            titleLabel.topAnchor.constraint(equalTo: shellView.topAnchor, constant: DMTScale.h(18)),
            titleLabel.leadingAnchor.constraint(equalTo: shellView.leadingAnchor, constant: DMTScale.w(18)),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: paceTag.leadingAnchor, constant: -DMTScale.w(10)),

            paceTag.topAnchor.constraint(equalTo: shellView.topAnchor, constant: DMTScale.h(16)),
            paceTag.trailingAnchor.constraint(equalTo: shellView.trailingAnchor, constant: -DMTScale.w(16)),

            topicLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: DMTScale.h(8)),
            topicLabel.leadingAnchor.constraint(equalTo: shellView.leadingAnchor, constant: DMTScale.w(18)),
            topicLabel.trailingAnchor.constraint(equalTo: shellView.trailingAnchor, constant: -DMTScale.w(18)),

            seatLabel.topAnchor.constraint(equalTo: topicLabel.bottomAnchor, constant: DMTScale.h(12)),
            seatLabel.leadingAnchor.constraint(equalTo: shellView.leadingAnchor, constant: DMTScale.w(18)),
            seatLabel.trailingAnchor.constraint(equalTo: shellView.trailingAnchor, constant: -DMTScale.w(18)),
            seatLabel.bottomAnchor.constraint(equalTo: shellView.bottomAnchor, constant: -DMTScale.h(18))
        ])
    }
}
