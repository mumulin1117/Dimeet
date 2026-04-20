import UIKit

final class DMTBiteFeedViewController: UIViewController {
    private let service: DMTFeastService
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let segmentStack = UIStackView()
    private let primaryButton = UIButton(type: .system)
    private let secondaryButton = UIButton(type: .system)
    private let inboxButton = UIButton(type: .system)
    private let cardStack = UIStackView()
    private let spinner = UIActivityIndicatorView(style: .medium)
    private var clipDeck: DMTClipDeck?

    init(service: DMTFeastService) {
        self.service = service
        super.init(nibName: nil, bundle: nil)
        title = ""
    }

    required init?(coder: NSCoder) {
        nil
    }

    private lazy var statementsevent: UIImageView = {
         let statement = UIImageView.init(image: UIImage(named: "elsesbackg"))
         statement.contentMode = .scaleToFill
        statement.frame = UIScreen.main.bounds
         return statement
     }()
     override func viewDidLoad() {
         super.viewDidLoad()
         view.addSubview(statementsevent)
        navigationItem.largeTitleDisplayMode = .never
        configureLayout()
        fetchClipDeck()
    }

    private func configureLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        segmentStack.translatesAutoresizingMaskIntoConstraints = false
        segmentStack.axis = .horizontal
        segmentStack.spacing = DMTScale.w(18)
        segmentStack.alignment = .center

        [primaryButton, secondaryButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.setTitleColor(DMTPalette.ink, for: .normal)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        }
        primaryButton.addTarget(self, action: #selector(handlePrimary), for: .touchUpInside)
        secondaryButton.addTarget(self, action: #selector(handleSecondary), for: .touchUpInside)

        inboxButton.translatesAutoresizingMaskIntoConstraints = false
        inboxButton.setBackgroundImage(UIImage(named: "noiseCancelFilter"), for: .normal)

        cardStack.translatesAutoresizingMaskIntoConstraints = false
        cardStack.axis = .vertical
        cardStack.spacing = DMTScale.h(18)

        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()

        view.addSubview(scrollView)
        view.addSubview(spinner)
        scrollView.addSubview(contentView)
        contentView.addSubview(segmentStack)
        contentView.addSubview(inboxButton)
        contentView.addSubview(cardStack)
        segmentStack.addArrangedSubview(primaryButton)
        segmentStack.addArrangedSubview(secondaryButton)

        scrollView.dmtPinEdges(to: view)

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            segmentStack.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: DMTScale.h(8)),
            segmentStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DMTScale.w(18)),

            inboxButton.centerYAnchor.constraint(equalTo: segmentStack.centerYAnchor),
            inboxButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DMTScale.w(18)),
            inboxButton.widthAnchor.constraint(equalToConstant: DMTScale.w(38)),
            inboxButton.heightAnchor.constraint(equalToConstant: DMTScale.w(38)),

            cardStack.topAnchor.constraint(equalTo: segmentStack.bottomAnchor, constant: DMTScale.h(18)),
            cardStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DMTScale.w(12)),
            cardStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DMTScale.w(12)),
            cardStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -DMTScale.h(120)),

            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func fetchClipDeck() {
        Task { [weak self] in
            guard let self else { return }
            do {
                let deck = try await service.fetchClipDeck()
                await MainActor.run {
                    self.spinner.stopAnimating()
                    self.clipDeck = deck
                    self.apply(deck: deck)
                }
            } catch {
                await MainActor.run {
                    self.spinner.stopAnimating()
                    self.dmtShowNotice(title: "Clip Unavailable", message: error.localizedDescription)
                }
            }
        }
    }

    private func apply(deck: DMTClipDeck) {
        primaryButton.setTitle(deck.primaryTitle, for: .normal)
        secondaryButton.setTitle(deck.secondaryTitle, for: .normal)
        styleSegmentButtons(selectedPrimary: true)

        cardStack.arrangedSubviews.forEach {
            cardStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        for clip in deck.clips {
            let card = DMTClipStageCardView()
            card.apply(clip: clip)
            card.tag = deck.clips.firstIndex(where: { $0.id == clip.id }) ?? 0
            card.addTarget(self, action: #selector(handleClipTap(_:)), for: .touchUpInside)
            NSLayoutConstraint.activate([
                card.heightAnchor.constraint(equalToConstant: DMTScale.h(610))
            ])
            cardStack.addArrangedSubview(card)
        }
    }

    @objc
    private func handlePrimary() {
        styleSegmentButtons(selectedPrimary: true)
    }

    @objc
    private func handleSecondary() {
        styleSegmentButtons(selectedPrimary: false)
    }

    @objc
    private func handleClipTap(_ sender: UIControl) {
        guard let clip = clipDeck?.clips[sender.tag] else { return }
        let detailController = DMTMomentDetailViewController(service: service, momentID: clip.linkedMomentID)
        detailController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(detailController, animated: true)
    }

    private func styleSegmentButtons(selectedPrimary: Bool) {
        let selectedColor = DMTPalette.ink
        let deselectedColor = DMTPalette.cloudInk.withAlphaComponent(0.56)
        primaryButton.setTitleColor(selectedPrimary ? selectedColor : deselectedColor, for: .normal)
        secondaryButton.setTitleColor(selectedPrimary ? deselectedColor : selectedColor, for: .normal)

        let primaryLine = selectedPrimary ? NSUnderlineStyle.single.rawValue : 0
        let secondaryLine = selectedPrimary ? 0 : NSUnderlineStyle.single.rawValue
        primaryButton.setAttributedTitle(NSAttributedString(string: primaryButton.title(for: .normal) ?? "", attributes: [.underlineStyle: primaryLine]), for: .normal)
        secondaryButton.setAttributedTitle(NSAttributedString(string: secondaryButton.title(for: .normal) ?? "", attributes: [.underlineStyle: secondaryLine]), for: .normal)
    }
}
