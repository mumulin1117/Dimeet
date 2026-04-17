import UIKit

final class DMTEulaViewController: UIViewController {
    private let service: DMTFeastService
    private let dimView = UIView()
    private let cardView = UIView()
    private let titleLabel = UILabel()
    private let introLabel = UILabel()
    private let stackView = UIStackView()
    private let closingLabel = UILabel()
    private let cancelButton = UIButton(type: .system)
    private let agreeButton = DMTGlowButton()

    init(service: DMTFeastService) {
        self.service = service
        super.init(nibName: nil, bundle: nil)
        modalPresentationCapturesStatusBarAppearance = true
    }

    required init?(coder: NSCoder) {
        nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        loadDeck()
    }

    private func configureLayout() {
        view.backgroundColor = .clear

        dimView.translatesAutoresizingMaskIntoConstraints = false
        dimView.backgroundColor = UIColor.black.withAlphaComponent(0.34)

        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = DMTScale.r(30)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        titleLabel.textColor = DMTPalette.ink
        titleLabel.textAlignment = .center

        introLabel.translatesAutoresizingMaskIntoConstraints = false
        introLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        introLabel.textColor = DMTPalette.cloudInk
        introLabel.numberOfLines = 0

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = DMTScale.h(12)

        closingLabel.translatesAutoresizingMaskIntoConstraints = false
        closingLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        closingLabel.textColor = DMTPalette.cloudInk
        closingLabel.numberOfLines = 0

        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.backgroundColor = DMTPalette.paper
        cancelButton.setTitleColor(DMTPalette.ink, for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        cancelButton.layer.cornerRadius = DMTScale.r(22)
        cancelButton.addTarget(self, action: #selector(closeSheet), for: .touchUpInside)

        agreeButton.translatesAutoresizingMaskIntoConstraints = false
        agreeButton.addTarget(self, action: #selector(closeSheet), for: .touchUpInside)

        view.addSubview(dimView)
        view.addSubview(cardView)
        cardView.addSubview(titleLabel)
        cardView.addSubview(introLabel)
        cardView.addSubview(stackView)
        cardView.addSubview(closingLabel)
        cardView.addSubview(cancelButton)
        cardView.addSubview(agreeButton)

        dimView.dmtPinEdges(to: view)

        NSLayoutConstraint.activate([
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: DMTScale.w(18)),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -DMTScale.w(18)),
            cardView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -DMTScale.h(18)),

            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: DMTScale.h(28)),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: DMTScale.w(20)),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -DMTScale.w(20)),

            introLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: DMTScale.h(18)),
            introLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: DMTScale.w(20)),
            introLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -DMTScale.w(20)),

            stackView.topAnchor.constraint(equalTo: introLabel.bottomAnchor, constant: DMTScale.h(20)),
            stackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: DMTScale.w(20)),
            stackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -DMTScale.w(20)),

            closingLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: DMTScale.h(20)),
            closingLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: DMTScale.w(20)),
            closingLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -DMTScale.w(20)),

            cancelButton.topAnchor.constraint(equalTo: closingLabel.bottomAnchor, constant: DMTScale.h(24)),
            cancelButton.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: DMTScale.w(20)),
            cancelButton.trailingAnchor.constraint(equalTo: cardView.centerXAnchor, constant: -DMTScale.w(8)),
            cancelButton.heightAnchor.constraint(equalToConstant: DMTScale.h(52)),
            cancelButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -DMTScale.h(24)),

            agreeButton.topAnchor.constraint(equalTo: closingLabel.bottomAnchor, constant: DMTScale.h(24)),
            agreeButton.leadingAnchor.constraint(equalTo: cardView.centerXAnchor, constant: DMTScale.w(8)),
            agreeButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -DMTScale.w(20)),
            agreeButton.heightAnchor.constraint(equalToConstant: DMTScale.h(52))
        ])
    }

    private func loadDeck() {
        Task { [weak self] in
            guard let self else { return }
            do {
                let bundle = try await service.fetchAuthBundle()
                await MainActor.run {
                    self.applyDeck(bundle.agreement)
                }
            } catch {
                await MainActor.run {
                    self.dmtShowNotice(title: "Signal Lost", message: error.localizedDescription)
                }
            }
        }
    }

    private func applyDeck(_ deck: DMTEulaDeck) {
        titleLabel.text = deck.title
        introLabel.text = deck.intro
        closingLabel.text = deck.closing
        cancelButton.setTitle(deck.cancelTitle, for: .normal)
        agreeButton.setTitle(deck.agreeTitle, for: .normal)

        stackView.arrangedSubviews.forEach {
            stackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        for bullet in deck.bullets {
            let row = UILabel()
            row.font = UIFont.systemFont(ofSize: 15, weight: .regular)
            row.textColor = DMTPalette.ink
            row.numberOfLines = 0
            row.text = "• \(bullet)"
            stackView.addArrangedSubview(row)
        }
    }

    @objc
    private func closeSheet() {
        dismiss(animated: true)
    }
}
