import UIKit

final class DMTMatePromptCell: UITableViewCell {
    static let reuseID = "DMTMatePromptCell"

    private let shellView = UIView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let seedLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }

    required init?(coder: NSCoder) {
        nil
    }

    func apply(prompt: DMTMatePrompt) {
        titleLabel.text = prompt.title
        subtitleLabel.text = prompt.subtitle
        seedLabel.text = "Prompt seed: \(prompt.seed)"
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

        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        subtitleLabel.textColor = DMTPalette.cloudInk
        subtitleLabel.numberOfLines = 0

        seedLabel.translatesAutoresizingMaskIntoConstraints = false
        seedLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        seedLabel.textColor = DMTPalette.sunrise
        seedLabel.numberOfLines = 0

        contentView.addSubview(shellView)
        shellView.addSubview(titleLabel)
        shellView.addSubview(subtitleLabel)
        shellView.addSubview(seedLabel)

        NSLayoutConstraint.activate([
            shellView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: DMTScale.h(6)),
            shellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            shellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            shellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -DMTScale.h(6)),

            titleLabel.topAnchor.constraint(equalTo: shellView.topAnchor, constant: DMTScale.h(18)),
            titleLabel.leadingAnchor.constraint(equalTo: shellView.leadingAnchor, constant: DMTScale.w(18)),
            titleLabel.trailingAnchor.constraint(equalTo: shellView.trailingAnchor, constant: -DMTScale.w(18)),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: DMTScale.h(8)),
            subtitleLabel.leadingAnchor.constraint(equalTo: shellView.leadingAnchor, constant: DMTScale.w(18)),
            subtitleLabel.trailingAnchor.constraint(equalTo: shellView.trailingAnchor, constant: -DMTScale.w(18)),

            seedLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: DMTScale.h(10)),
            seedLabel.leadingAnchor.constraint(equalTo: shellView.leadingAnchor, constant: DMTScale.w(18)),
            seedLabel.trailingAnchor.constraint(equalTo: shellView.trailingAnchor, constant: -DMTScale.w(18)),
            seedLabel.bottomAnchor.constraint(equalTo: shellView.bottomAnchor, constant: -DMTScale.h(18))
        ])
    }
}
