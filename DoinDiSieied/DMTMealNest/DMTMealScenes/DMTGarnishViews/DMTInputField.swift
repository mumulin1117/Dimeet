import UIKit

final class DMTInputField: UIView {
    private let fieldTitleLabel = UILabel()
    private let fieldShellView = UIView()
    private let visibilityToggleButton = UIButton(type: .system)
    let entryField = UITextField()

    private var usesSecureFlavor = false

    var text: String {
        entryField.text ?? ""
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        assembleFieldChrome()
    }

    required init?(coder: NSCoder) {
        nil
    }

    func renderFieldCopy(title: String, placeholder: String, isSecure: Bool = false) {
        fieldTitleLabel.text = title
        entryField.placeholder = placeholder
        usesSecureFlavor = isSecure
        entryField.isSecureTextEntry = isSecure
        visibilityToggleButton.isHidden = !isSecure
        refreshVisibilityGlyph()
    }

    private func assembleFieldChrome() {
        translatesAutoresizingMaskIntoConstraints = false

        fieldTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        fieldTitleLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        fieldTitleLabel.textColor = DMTPalette.ink

        fieldShellView.translatesAutoresizingMaskIntoConstraints = false
        fieldShellView.backgroundColor = UIColor.white.withAlphaComponent(0.82)
        fieldShellView.layer.cornerRadius = DMTScale.r(16)
        fieldShellView.layer.borderWidth = 1
        fieldShellView.layer.borderColor = DMTPalette.line.cgColor

        entryField.translatesAutoresizingMaskIntoConstraints = false
        entryField.textColor = DMTPalette.ink
        entryField.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        entryField.autocorrectionType = .no
        entryField.autocapitalizationType = .none

        visibilityToggleButton.translatesAutoresizingMaskIntoConstraints = false
        visibilityToggleButton.tintColor = DMTPalette.cloudInk
        visibilityToggleButton.isHidden = true
        visibilityToggleButton.addTarget(self, action: #selector(flipSecureFlavor), for: .touchUpInside)

        addSubview(fieldTitleLabel)
        addSubview(fieldShellView)
        fieldShellView.addSubview(entryField)
        fieldShellView.addSubview(visibilityToggleButton)

        NSLayoutConstraint.activate([
            fieldTitleLabel.topAnchor.constraint(equalTo: topAnchor),
            fieldTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            fieldTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            fieldShellView.topAnchor.constraint(equalTo: fieldTitleLabel.bottomAnchor, constant: DMTScale.h(10)),
            fieldShellView.leadingAnchor.constraint(equalTo: leadingAnchor),
            fieldShellView.trailingAnchor.constraint(equalTo: trailingAnchor),
            fieldShellView.bottomAnchor.constraint(equalTo: bottomAnchor),
            fieldShellView.heightAnchor.constraint(equalToConstant: DMTScale.h(54)),

            entryField.topAnchor.constraint(equalTo: fieldShellView.topAnchor),
            entryField.leadingAnchor.constraint(equalTo: fieldShellView.leadingAnchor, constant: DMTScale.w(16)),
            entryField.bottomAnchor.constraint(equalTo: fieldShellView.bottomAnchor),
            entryField.trailingAnchor.constraint(equalTo: visibilityToggleButton.leadingAnchor, constant: -DMTScale.w(8)),

            visibilityToggleButton.centerYAnchor.constraint(equalTo: fieldShellView.centerYAnchor),
            visibilityToggleButton.trailingAnchor.constraint(equalTo: fieldShellView.trailingAnchor, constant: -DMTScale.w(12)),
            visibilityToggleButton.widthAnchor.constraint(equalToConstant: DMTScale.w(28)),
            visibilityToggleButton.heightAnchor.constraint(equalToConstant: DMTScale.h(28))
        ])
    }

    @objc
    private func flipSecureFlavor() {
        guard usesSecureFlavor else { return }
        entryField.isSecureTextEntry.toggle()
        refreshVisibilityGlyph()
    }

    private func refreshVisibilityGlyph() {
        let imageName = entryField.isSecureTextEntry ? "eye" : "eye.slash"
        visibilityToggleButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
}
