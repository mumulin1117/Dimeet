import UIKit

final class DMTWelcomeAboardViewController: UIViewController {
    var onFinish: ((DMTSessionPayload) -> Void)?

    private let hearthService: DMTFeastService
    private let draft: DMTSignUpDraft
    private let tasteLedger: DMTTasteProfileStore
    private let courseScrollView = UIScrollView()
    private let platingCanvas = UIView()
    private let gradientView = DMTGradientView(colors: [UIColor(red: 1, green: 0.96, blue: 0.86, alpha: 1), UIColor(red: 1, green: 0.76, blue: 0.7, alpha: 1), UIColor(red: 1, green: 0.9, blue: 0.9, alpha: 1)], startPoint: CGPoint(x: 0, y: 0.3), endPoint: CGPoint(x: 1, y: 1))
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let reminderStack = UIStackView()
    private let enterButton = DMTGlowButton()
    private let simmerSpinner = UIActivityIndicatorView(style: .medium)
    private var ctaCopy = DMTStringCellar.shared.serve("copy.enter")

    init(hearthService: DMTFeastService, draft: DMTSignUpDraft, tasteLedger: DMTTasteProfileStore) {
        self.hearthService = hearthService
        self.draft = draft
        self.tasteLedger = tasteLedger
        super.init(nibName: nil, bundle: nil)
        title = DMTStringCellar.shared.serve("copy.welcomeAboard")
    }

    required init?(coder: NSCoder) {
        nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = DMTPalette.paper
        composeLayout()
        fetchDeckCopy()
    }

    private func composeLayout() {
        courseScrollView.translatesAutoresizingMaskIntoConstraints = false
        platingCanvas.translatesAutoresizingMaskIntoConstraints = false
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

        simmerSpinner.translatesAutoresizingMaskIntoConstraints = false
        simmerSpinner.hidesWhenStopped = true
        simmerSpinner.color = .white

        view.addSubview(courseScrollView)
        courseScrollView.addSubview(platingCanvas)
        platingCanvas.addSubview(gradientView)
        gradientView.addSubview(titleLabel)
        gradientView.addSubview(subtitleLabel)
        gradientView.addSubview(reminderStack)
        gradientView.addSubview(enterButton)
        enterButton.addSubview(simmerSpinner)

        courseScrollView.dmtPinCourseEdges(to: view)

        NSLayoutConstraint.activate([
            platingCanvas.topAnchor.constraint(equalTo: courseScrollView.topAnchor),
            platingCanvas.leadingAnchor.constraint(equalTo: courseScrollView.leadingAnchor),
            platingCanvas.trailingAnchor.constraint(equalTo: courseScrollView.trailingAnchor),
            platingCanvas.bottomAnchor.constraint(equalTo: courseScrollView.bottomAnchor),
            platingCanvas.widthAnchor.constraint(equalTo: courseScrollView.widthAnchor),

            gradientView.topAnchor.constraint(equalTo: platingCanvas.safeAreaLayoutGuide.topAnchor, constant: DMTScale.h(18)),
            gradientView.leadingAnchor.constraint(equalTo: platingCanvas.leadingAnchor, constant: DMTScale.w(18)),
            gradientView.trailingAnchor.constraint(equalTo: platingCanvas.trailingAnchor, constant: -DMTScale.w(18)),
            gradientView.bottomAnchor.constraint(equalTo: platingCanvas.bottomAnchor, constant: -DMTScale.h(18)),

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

            simmerSpinner.centerXAnchor.constraint(equalTo: enterButton.centerXAnchor),
            simmerSpinner.centerYAnchor.constraint(equalTo: enterButton.centerYAnchor)
        ])
    }

    private func fetchDeckCopy() {
        Task { [weak self] in
            guard let self else { return }
            do {
                let bundle = try await hearthService.fetchWelcomeBundle()
                await MainActor.run {
                    self.presentDeckCopy(bundle.DMTshientry)
                }
            } catch {
                await MainActor.run {
                    self.dmtServeNotice(title: DMTStringCellar.shared.serve("copy.signalLostTitle"), message: error.localizedDescription)
                }
            }
        }
    }

    private func presentDeckCopy(_ deck: DMTEntryDeck) {
        title = deck.DMTshititle
        ctaCopy = deck.ctaCopy
        titleLabel.text = deck.DMTshititle
        subtitleLabel.text = deck.subtitle
        enterButton.setTitle(deck.ctaCopy, for: .normal)

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
            titleLabel.text = "• \(reminder.DMTshititle)"

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
                let payload = try await hearthService.login(email: draft.ticket.email, password: draft.ticket.password)
                _ = tasteLedger.persistProfile(from: draft)
                await MainActor.run {
                    self.setLoading(false)
                    self.onFinish?(payload)
                }
            } catch {
                await MainActor.run {
                    self.setLoading(false)
                    self.dmtServeNotice(title: DMTStringCellar.shared.serve("copy.tastePassFailedTitle"), message: error.localizedDescription)
                }
            }
        }
    }

    private func setLoading(_ isLoading: Bool) {
        enterButton.isEnabled = !isLoading
        if isLoading {
            enterButton.setTitle(nil, for: .normal)
            simmerSpinner.startAnimating()
        } else {
            simmerSpinner.stopAnimating()
            enterButton.setTitle(ctaCopy, for: .normal)
        }
    }
}
