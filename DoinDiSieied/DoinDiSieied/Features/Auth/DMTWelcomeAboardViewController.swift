import UIKit

final class DMTWelcomeAboardViewController: UIViewController {
    var onFinish: ((DMTSessionPayload) -> Void)?

    private let service: DMTFeastService
    private let draft: DMTSignUpDraft
    private let profileStore: DMTTasteProfileStore
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let gradientView = DMTGradientView(colors: [UIColor(red: 1, green: 0.96, blue: 0.86, alpha: 1), UIColor(red: 1, green: 0.76, blue: 0.7, alpha: 1), UIColor(red: 1, green: 0.9, blue: 0.9, alpha: 1)], startPoint: CGPoint(x: 0, y: 0.3), endPoint: CGPoint(x: 1, y: 1))
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let reminderStack = UIStackView()
    private let enterButton = DMTGlowButton()
    private let spinner = UIActivityIndicatorView(style: .medium)
    private var buttonTitle = "Enter"

    init(service: DMTFeastService, draft: DMTSignUpDraft, profileStore: DMTTasteProfileStore) {
        self.service = service
        self.draft = draft
        self.profileStore = profileStore
        super.init(nibName: nil, bundle: nil)
        title = "Welcome Aboard"
    }

    required init?(coder: NSCoder) {
        nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = DMTPalette.paper
        configureLayout()
        loadDeck()
    }

    private func configureLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        gradientView.layer.cornerRadius = DMTScale.r(30)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        titleLabel.textColor = DMTPalette.ink
        titleLabel.numberOfLines = 0

        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        subtitleLabel.textColor = DMTPalette.cloudInk
        subtitleLabel.numberOfLines = 0

        reminderStack.translatesAutoresizingMaskIntoConstraints = false
        reminderStack.axis = .vertical
        reminderStack.spacing = DMTScale.h(20)

        enterButton.translatesAutoresizingMaskIntoConstraints = false
        enterButton.addTarget(self, action: #selector(handleEnter), for: .touchUpInside)

        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        spinner.color = .white

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(gradientView)
        gradientView.addSubview(titleLabel)
        gradientView.addSubview(subtitleLabel)
        gradientView.addSubview(reminderStack)
        gradientView.addSubview(enterButton)
        enterButton.addSubview(spinner)

        scrollView.dmtPinEdges(to: view)

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            gradientView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: DMTScale.h(18)),
            gradientView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DMTScale.w(18)),
            gradientView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DMTScale.w(18)),
            gradientView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -DMTScale.h(18)),

            titleLabel.topAnchor.constraint(equalTo: gradientView.topAnchor, constant: DMTScale.h(34)),
            titleLabel.leadingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: DMTScale.w(22)),
            titleLabel.trailingAnchor.constraint(equalTo: gradientView.trailingAnchor, constant: -DMTScale.w(22)),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: DMTScale.h(10)),
            subtitleLabel.leadingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: DMTScale.w(22)),
            subtitleLabel.trailingAnchor.constraint(equalTo: gradientView.trailingAnchor, constant: -DMTScale.w(22)),

            reminderStack.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: DMTScale.h(26)),
            reminderStack.leadingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: DMTScale.w(22)),
            reminderStack.trailingAnchor.constraint(equalTo: gradientView.trailingAnchor, constant: -DMTScale.w(22)),

            enterButton.topAnchor.constraint(equalTo: reminderStack.bottomAnchor, constant: DMTScale.h(34)),
            enterButton.leadingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: DMTScale.w(22)),
            enterButton.trailingAnchor.constraint(equalTo: gradientView.trailingAnchor, constant: -DMTScale.w(22)),
            enterButton.heightAnchor.constraint(equalToConstant: DMTScale.h(54)),
            enterButton.bottomAnchor.constraint(equalTo: gradientView.bottomAnchor, constant: -DMTScale.h(28)),

            spinner.centerXAnchor.constraint(equalTo: enterButton.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: enterButton.centerYAnchor)
        ])
    }

    private func loadDeck() {
        Task { [weak self] in
            guard let self else { return }
            do {
                let bundle = try await service.fetchAuthBundle()
                await MainActor.run {
                    self.applyDeck(bundle.entry)
                }
            } catch {
                await MainActor.run {
                    self.dmtShowNotice(title: "Signal Lost", message: error.localizedDescription)
                }
            }
        }
    }

    private func applyDeck(_ deck: DMTEntryDeck) {
        title = deck.title
        buttonTitle = deck.buttonTitle
        titleLabel.text = deck.title
        subtitleLabel.text = deck.subtitle
        enterButton.setTitle(deck.buttonTitle, for: .normal)

        reminderStack.arrangedSubviews.forEach {
            reminderStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        for reminder in deck.reminders {
            let row = UIStackView()
            row.axis = .vertical
            row.spacing = DMTScale.h(6)

            let titleLabel = UILabel()
            titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
            titleLabel.textColor = DMTPalette.ink
            titleLabel.text = "• \(reminder.title)"

            let subtitleLabel = UILabel()
            subtitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            subtitleLabel.textColor = DMTPalette.ink.withAlphaComponent(0.82)
            subtitleLabel.numberOfLines = 0
            subtitleLabel.text = reminder.subtitle

            row.addArrangedSubview(titleLabel)
            row.addArrangedSubview(subtitleLabel)
            reminderStack.addArrangedSubview(row)
        }
    }

    @objc
    private func handleEnter() {
        setLoading(true)

        Task { [weak self] in
            guard let self else { return }
            do {
                let payload = try await service.login(email: draft.ticket.email, password: draft.ticket.password)
                _ = profileStore.persistProfile(from: draft)
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
        enterButton.isEnabled = !isLoading
        if isLoading {
            enterButton.setTitle(nil, for: .normal)
            spinner.startAnimating()
        } else {
            spinner.stopAnimating()
            enterButton.setTitle(buttonTitle, for: .normal)
        }
    }
}
