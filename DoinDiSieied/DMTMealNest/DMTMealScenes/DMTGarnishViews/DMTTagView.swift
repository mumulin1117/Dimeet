import UIKit

final class DMTTagView: UIView {
    private let tagTitleLabel = UILabel()

    init(fillColor: UIColor = DMTPalette.blush, textColor: UIColor = DMTPalette.sunrise) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = fillColor
        layer.cornerRadius = DMTScale.r(14)

        tagTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        tagTitleLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        tagTitleLabel.textColor = textColor
        addSubview(tagTitleLabel)

        NSLayoutConstraint.activate([
            tagTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: DMTScale.h(7)),
            tagTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: DMTScale.w(12)),
            tagTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -DMTScale.w(12)),
            tagTitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -DMTScale.h(7))
        ])
    }

    required init?(coder: NSCoder) {
        nil
    }

    func renderTagCopy(text: String) {
        tagTitleLabel.text = text
    }
}
