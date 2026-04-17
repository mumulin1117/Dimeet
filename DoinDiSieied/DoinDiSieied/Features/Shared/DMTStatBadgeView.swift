import UIKit

final class DMTStatBadgeView: UIView {
    private let valueLabel = UILabel()
    private let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        layer.cornerRadius = DMTScale.r(20)

        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        valueLabel.textColor = DMTPalette.ink

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        titleLabel.textColor = DMTPalette.cloudInk
        titleLabel.numberOfLines = 2

        addSubview(valueLabel)
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            valueLabel.topAnchor.constraint(equalTo: topAnchor, constant: DMTScale.h(16)),
            valueLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: DMTScale.w(16)),
            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -DMTScale.w(16)),

            titleLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: DMTScale.h(6)),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: DMTScale.w(16)),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -DMTScale.w(16)),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -DMTScale.h(16))
        ])
    }

    required init?(coder: NSCoder) {
        nil
    }

    func apply(chip: DMTStatChip) {
        valueLabel.text = chip.value
        titleLabel.text = chip.label
    }
}
