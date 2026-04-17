import UIKit

final class DMTTagView: UIView {
    private let titleLabel = UILabel()

    init(fillColor: UIColor = DMTPalette.blush, textColor: UIColor = DMTPalette.sunrise) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = fillColor
        layer.cornerRadius = DMTScale.r(14)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        titleLabel.textColor = textColor
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: DMTScale.h(7)),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: DMTScale.w(12)),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -DMTScale.w(12)),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -DMTScale.h(7))
        ])
    }

    required init?(coder: NSCoder) {
        nil
    }

    func apply(text: String) {
        titleLabel.text = text
    }
}
