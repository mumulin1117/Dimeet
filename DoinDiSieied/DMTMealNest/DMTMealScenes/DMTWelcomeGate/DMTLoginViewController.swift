import UIKit

final class DMTLoginViewController: UIViewController {
    var onFinish: ((DMTSessionPayload) -> Void)?
    var onNeedSignUp: ((DMTLoginTicket) -> Void)?

    private let service: DMTFeastService
    private let profileStore: DMTTasteProfileStore
    private let preferredTitle: String
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let headerView = UIImageView.init(image: UIImage.init(named: "cravingsLogicAction"))
    private let symbolShell = UIImageView.init(image: UIImage.init(named: "voiceEchoInstance"))
    
    private let cardView = UIView()
    private let emailField = DMTInputField()
    private let passwordField = DMTInputField()
    private let hintLabel = UILabel()
    private let confirmButton = DMTGlowButton()
    private let spinner = UIActivityIndicatorView(style: .medium)
    private var buttonTitle = "Confirm"

    init(service: DMTFeastService, profileStore: DMTTasteProfileStore, preferredTitle: String) {
        self.service = service
        self.profileStore = profileStore
        self.preferredTitle = preferredTitle
        super.init(nibName: nil, bundle: nil)
        title = preferredTitle
    }

    required init?(coder: NSCoder) {
        nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hintLabel.isHidden = true
        view.backgroundColor = DMTPalette.cream
        navigationItem.largeTitleDisplayMode = .never
        configureLayout()
        loadDeck()
    }

    private func configureLayout() {
        headerView.contentMode = .scaleToFill
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        headerView.translatesAutoresizingMaskIntoConstraints = false

        symbolShell.translatesAutoresizingMaskIntoConstraints = false
        symbolShell.backgroundColor = UIColor.white.withAlphaComponent(0.16)
        symbolShell.layer.cornerRadius = DMTScale.r(32)

       

        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = DMTScale.r(28)
        cardView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        hintLabel.translatesAutoresizingMaskIntoConstraints = false
        hintLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        hintLabel.textColor = DMTPalette.cloudInk
        hintLabel.numberOfLines = 0

        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.addTarget(self, action: #selector(handleConfirm), for: .touchUpInside)

        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        spinner.color = .white

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(headerView)
        headerView.addSubview(symbolShell)
       
        contentView.addSubview(cardView)
        cardView.addSubview(emailField)
        cardView.addSubview(passwordField)
        cardView.addSubview(hintLabel)
        cardView.addSubview(confirmButton)
        confirmButton.addSubview(spinner)

        scrollView.dmtPinEdges(to: view)
        scrollView.contentInsetAdjustmentBehavior = .never
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            headerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: DMTScale.h(390)),

            symbolShell.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            symbolShell.centerYAnchor.constraint(equalTo: headerView.centerYAnchor, constant: DMTScale.h(-8)),
            symbolShell.widthAnchor.constraint(equalToConstant: DMTScale.w(120)),
            symbolShell.heightAnchor.constraint(equalToConstant: DMTScale.w(120)),

            cardView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -DMTScale.h(54)),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            emailField.topAnchor.constraint(equalTo: cardView.topAnchor, constant: DMTScale.h(32)),
            emailField.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: DMTScale.w(20)),
            emailField.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -DMTScale.w(20)),

            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: DMTScale.h(20)),
            passwordField.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: DMTScale.w(20)),
            passwordField.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -DMTScale.w(20)),

            hintLabel.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: DMTScale.h(12)),
            hintLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: DMTScale.w(20)),
            hintLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -DMTScale.w(20)),

            confirmButton.topAnchor.constraint(equalTo: hintLabel.bottomAnchor, constant: DMTScale.h(22)),
            confirmButton.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: DMTScale.w(20)),
            confirmButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -DMTScale.w(20)),
            confirmButton.heightAnchor.constraint(equalToConstant: DMTScale.h(54)),
            confirmButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -DMTScale.h(38)),

            spinner.centerXAnchor.constraint(equalTo: confirmButton.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: confirmButton.centerYAnchor)
        ])
    }

    private func loadDeck() {
        Task { [weak self] in
            guard let self else { return }
            do {
                let bundle = try await service.fetchAuthBundle()
                await MainActor.run {
                    self.applyDeck(bundle.login)
                }
            } catch {
                await MainActor.run {
                    self.dmtShowNotice(title: "Signal Lost", message: error.localizedDescription)
                }
            }
        }
    }

    private func applyDeck(_ deck: DMTLoginDeck) {
        title = preferredTitle
        buttonTitle = deck.buttonTitle
        emailField.apply(title: deck.emailTitle, placeholder: deck.emailPlaceholder)
        emailField.entryField.keyboardType = .emailAddress
        emailField.entryField.textContentType = .username
        passwordField.apply(title: deck.passwordTitle, placeholder: deck.passwordPlaceholder, isSecure: true)
        passwordField.entryField.textContentType = .password
        hintLabel.text = deck.hintLine
        confirmButton.setTitle(deck.buttonTitle, for: .normal)
    }

    @objc
    private func handleConfirm() {
        let email = profileStore.normalizedEmail(emailField.text)
        let password = passwordField.text.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !email.isEmpty, !password.isEmpty else {
            dmtShowNotice(title: "Missing Taste Pass", message: "Fill in both email and password.")
            return
        }

        setLoading(true)

        let ticket = DMTLoginTicket(email: email, password: password)

        if profileStore.isTestAccount(email: email, password: password) {
            profileStore.ensureTestProfile()
            performLogin(ticket: ticket)
            return
        }

        if profileStore.canDirectLogin(email: email, password: password) {
            performLogin(ticket: ticket)
            return
        }

        if profileStore.hasPasswordMismatch(email: email, password: password) {
            setLoading(false)
            dmtShowNotice(title: "Taste Pass Failed", message: "This account was saved locally with a different password.")
            return
        }

        setLoading(false)
        onNeedSignUp?(ticket)
    }

    private func performLogin(ticket: DMTLoginTicket) {
        Task { [weak self] in
            guard let self else { return }
            do {
                let payload = try await service.login(email: ticket.email, password: ticket.password)
                await MainActor.run {
                    self.setLoading(false)
                    self.onFinish?(payload)
                }
            } catch {
                await MainActor.run {
                    self.setLoading(false)
                    self.dmtShowNotice(title: "Taste Pass Failed", message: error.localizedDescription)
                }
            }
        }
    }

    private func setLoading(_ isLoading: Bool) {
        confirmButton.isEnabled = !isLoading
        if isLoading {
            confirmButton.setTitle(nil, for: .normal)
            spinner.startAnimating()
        } else {
            spinner.stopAnimating()
            confirmButton.setTitle(buttonTitle, for: .normal)
        }
    }
}
