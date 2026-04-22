import UIKit

final class DMTEulaViewController: UIViewController {
    private let hearthService: DMTFeastService
    private let dimView = UIView()
    private let servingCard = UIView()
    private let titleLabel = UILabel()
    private let introLabel = UILabel()
    private let stackView = UIStackView()
    private let closingLabel = UILabel()
    private let cancelButton = UIButton(type: .system)
    private let agreeButton = DMTGlowButton()

    init(hearthService: DMTFeastService) {
        self.hearthService = hearthService
        super.init(nibName: nil, bundle: nil)
        modalPresentationCapturesStatusBarAppearance = true
    }

    required init?(coder: NSCoder) {
        nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        composeLayout()
        fetchDeckCopy()
    }

    private func composeLayout() {
        view.backgroundColor = .clear

        dimView.translatesAutoresizingMaskIntoConstraints = false
        dimView.backgroundColor = UIColor.black.withAlphaComponent(0.34)

        servingCard.translatesAutoresizingMaskIntoConstraints = false
        servingCard.backgroundColor = .white
        servingCard.layer.cornerRadius = DMTScale.r(30)

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
        view.addSubview(servingCard)
        servingCard.addSubview(titleLabel)
        servingCard.addSubview(introLabel)
        servingCard.addSubview(stackView)
        servingCard.addSubview(closingLabel)
        servingCard.addSubview(cancelButton)
        servingCard.addSubview(agreeButton)

        dimView.dmtPinCourseEdges(to: view)

        NSLayoutConstraint.activate([
            servingCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: DMTScale.w(18)),
            servingCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -DMTScale.w(18)),
            servingCard.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -DMTScale.h(18)),

            titleLabel.topAnchor.constraint(equalTo: servingCard.topAnchor, constant: DMTScale.h(28)),
            titleLabel.leadingAnchor.constraint(equalTo: servingCard.leadingAnchor, constant: DMTScale.w(20)),
            titleLabel.trailingAnchor.constraint(equalTo: servingCard.trailingAnchor, constant: -DMTScale.w(20)),

            introLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: DMTScale.h(18)),
            introLabel.leadingAnchor.constraint(equalTo: servingCard.leadingAnchor, constant: DMTScale.w(20)),
            introLabel.trailingAnchor.constraint(equalTo: servingCard.trailingAnchor, constant: -DMTScale.w(20)),

            stackView.topAnchor.constraint(equalTo: introLabel.bottomAnchor, constant: DMTScale.h(20)),
            stackView.leadingAnchor.constraint(equalTo: servingCard.leadingAnchor, constant: DMTScale.w(20)),
            stackView.trailingAnchor.constraint(equalTo: servingCard.trailingAnchor, constant: -DMTScale.w(20)),

            closingLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: DMTScale.h(20)),
            closingLabel.leadingAnchor.constraint(equalTo: servingCard.leadingAnchor, constant: DMTScale.w(20)),
            closingLabel.trailingAnchor.constraint(equalTo: servingCard.trailingAnchor, constant: -DMTScale.w(20)),

            cancelButton.topAnchor.constraint(equalTo: closingLabel.bottomAnchor, constant: DMTScale.h(24)),
            cancelButton.leadingAnchor.constraint(equalTo: servingCard.leadingAnchor, constant: DMTScale.w(20)),
            cancelButton.trailingAnchor.constraint(equalTo: servingCard.centerXAnchor, constant: -DMTScale.w(8)),
            cancelButton.heightAnchor.constraint(equalToConstant: DMTScale.h(52)),
            cancelButton.bottomAnchor.constraint(equalTo: servingCard.bottomAnchor, constant: -DMTScale.h(24)),

            agreeButton.topAnchor.constraint(equalTo: closingLabel.bottomAnchor, constant: DMTScale.h(24)),
            agreeButton.leadingAnchor.constraint(equalTo: servingCard.centerXAnchor, constant: DMTScale.w(8)),
            agreeButton.trailingAnchor.constraint(equalTo: servingCard.trailingAnchor, constant: -DMTScale.w(20)),
            agreeButton.heightAnchor.constraint(equalToConstant: DMTScale.h(52))
        ])
    }

    private func fetchDeckCopy() {
        Task { [weak self] in
            guard let self else { return }
            do {
                let bundle = try await hearthService.fetchWelcomeBundle()
                await MainActor.run {
                    self.presentDeckCopy(bundle.DMTshiagreement)
                }
            } catch {
                await MainActor.run {
                    self.dmtServeNotice(title: DMTStringCellar.shared.serve("copy.signalLostTitle"), message: error.localizedDescription)
                }
            }
        }
    }

    private func presentDeckCopy(_ deck: DMTEulaDeck) {
        titleLabel.text = deck.DMTshititle
        introLabel.text = deck.intro
        closingLabel.text = deck.closing
        cancelButton.setTitle(deck.cancelTitle, for: .normal)
        agreeButton.setTitle(deck.DMTshiagreeTitle, for: .normal)

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
