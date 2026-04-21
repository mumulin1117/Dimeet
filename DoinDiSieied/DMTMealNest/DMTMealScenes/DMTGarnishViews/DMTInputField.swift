import UIKit

final class DMTInputField: UIView {
    private let titleLabel = UILabel()
    private let shellView = UIView()
    private let toggleButton = UIButton(type: .system)
    let entryField = UITextField()

    private var isSecureStyle = false

    var text: String {
        entryField.text ?? ""
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        nil
    }

    func apply(title: String, placeholder: String, isSecure: Bool = false) {
        titleLabel.text = title
        entryField.placeholder = placeholder
        isSecureStyle = isSecure
        entryField.isSecureTextEntry = isSecure
        toggleButton.isHidden = !isSecure
        updateToggle()
    }

    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        titleLabel.textColor = DMTPalette.ink

        shellView.translatesAutoresizingMaskIntoConstraints = false
        shellView.backgroundColor = UIColor.white.withAlphaComponent(0.82)
        shellView.layer.cornerRadius = DMTScale.r(16)
        shellView.layer.borderWidth = 1
        shellView.layer.borderColor = DMTPalette.line.cgColor

        entryField.translatesAutoresizingMaskIntoConstraints = false
        entryField.textColor = DMTPalette.ink
        entryField.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        entryField.autocorrectionType = .no
        entryField.autocapitalizationType = .none

        toggleButton.translatesAutoresizingMaskIntoConstraints = false
        toggleButton.tintColor = DMTPalette.cloudInk
        toggleButton.isHidden = true
        toggleButton.addTarget(self, action: #selector(toggleSecureState), for: .touchUpInside)

        addSubview(titleLabel)
        addSubview(shellView)
        shellView.addSubview(entryField)
        shellView.addSubview(toggleButton)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            shellView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: DMTScale.h(10)),
            shellView.leadingAnchor.constraint(equalTo: leadingAnchor),
            shellView.trailingAnchor.constraint(equalTo: trailingAnchor),
            shellView.bottomAnchor.constraint(equalTo: bottomAnchor),
            shellView.heightAnchor.constraint(equalToConstant: DMTScale.h(54)),

            entryField.topAnchor.constraint(equalTo: shellView.topAnchor),
            entryField.leadingAnchor.constraint(equalTo: shellView.leadingAnchor, constant: DMTScale.w(16)),
            entryField.bottomAnchor.constraint(equalTo: shellView.bottomAnchor),
            entryField.trailingAnchor.constraint(equalTo: toggleButton.leadingAnchor, constant: -DMTScale.w(8)),

            toggleButton.centerYAnchor.constraint(equalTo: shellView.centerYAnchor),
            toggleButton.trailingAnchor.constraint(equalTo: shellView.trailingAnchor, constant: -DMTScale.w(12)),
            toggleButton.widthAnchor.constraint(equalToConstant: DMTScale.w(28)),
            toggleButton.heightAnchor.constraint(equalToConstant: DMTScale.h(28))
        ])
    }

    @objc
    private func toggleSecureState() {
        guard isSecureStyle else { return }
        entryField.isSecureTextEntry.toggle()
        updateToggle()
    }

    private func updateToggle() {
        let imageName = entryField.isSecureTextEntry ? "eye" : "eye.slash"
        toggleButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
}
