import UIKit

final class DMTBiteFeedViewController: UIViewController {
    private enum DMTClipSegment {
        case primary
        case secondary
    }

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
    private var visibleClips: [DMTClipCard] = []
    private var selectedSegment: DMTClipSegment = .primary

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
         
         menuPageLayout.addTarget(self, action: #selector(publishiMyVideor), for: .touchUpInside)
    }
    
    @objc func publishiMyVideor()  {
        dmtOpenPortal(.publishVideo)
    }

    private func configureLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentInsetAdjustmentBehavior = .never
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
        inboxButton.addTarget(self, action: #selector(handleInboxTap), for: .touchUpInside)

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

        view.addSubview(menuPageLayout)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            segmentStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: dmtTopChromeSpacing),
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
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            menuPageLayout.widthAnchor.constraint(equalToConstant: 30),
            menuPageLayout.heightAnchor.constraint(equalToConstant: 30),
            menuPageLayout.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            menuPageLayout.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -90),
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
                    self.applyBase(deck: deck)
                    self.renderClips(using: deck, selectedSegment: .primary, animated: false)
                }
            } catch {
                await MainActor.run {
                    self.spinner.stopAnimating()
                    self.dmtShowNotice(title: "Clip Unavailable", message: error.localizedDescription)
                }
            }
        }
    }

    
   private lazy var menuPageLayout: UIButton = {
        let add = UIButton.init()
        add.setImage(UIImage.init(named: "menuPageLayout"), for: .normal)
        return add
    }()
    private func applyBase(deck: DMTClipDeck) {
        primaryButton.setTitle(deck.primaryTitle, for: .normal)
        secondaryButton.setTitle(deck.secondaryTitle, for: .normal)
    }

    @objc
    private func handlePrimary() {
        guard let deck = clipDeck, selectedSegment != .primary else { return }
        renderClips(using: deck, selectedSegment: .primary, animated: true)
    }

    @objc
    private func handleSecondary() {
        guard let deck = clipDeck, selectedSegment != .secondary else { return }
        renderClips(using: deck, selectedSegment: .secondary, animated: true)
    }

    @objc
    private func handleClipTap(_ sender: UIControl) {
        guard visibleClips.indices.contains(sender.tag) else { return }
        let clip = visibleClips[sender.tag]
        dmtOpenPortal(.videoDetail(dynamicID: clip.linkedMomentID))
    }

    @objc
    private func handleInboxTap() {
        dmtOpenPortal(.noticeCenter)
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

    private func renderClips(using deck: DMTClipDeck, selectedSegment: DMTClipSegment, animated: Bool) {
        self.selectedSegment = selectedSegment
        styleSegmentButtons(selectedPrimary: selectedSegment == .primary)
        visibleClips = clipSubset(from: deck, selectedSegment: selectedSegment)

        let rebuild = { [self] in
            cardStack.arrangedSubviews.forEach {
                cardStack.removeArrangedSubview($0)
                $0.removeFromSuperview()
            }

            for (index, clip) in visibleClips.enumerated() {
                let card = DMTClipStageCardView()
                card.apply(clip: clip)
                card.onAvatarTap = { [weak self, weak card] in
                    guard let self, let card else { return }
                    self.dmtPresentProfileSheet(userID: clip.creatorUserID, anchor: card)
                }
                card.onChatTap = { [weak self] in
                    self?.dmtOpenPortal(.directMessage(userID: clip.creatorUserID, videoCall: false))
                }
                card.onReportTap = { [weak self] in
                    self?.dmtOpenPortal(.reportCenter)
                }
                card.tag = index
                card.addTarget(self, action: #selector(handleClipTap(_:)), for: .touchUpInside)
                NSLayoutConstraint.activate([
                    card.heightAnchor.constraint(equalToConstant: DMTScale.h(610))
                ])
                cardStack.addArrangedSubview(card)
            }
        }

        if animated {
            UIView.transition(with: cardStack, duration: 0.22, options: [.transitionCrossDissolve, .allowAnimatedContent], animations: rebuild)
        } else {
            rebuild()
        }
    }

    private func clipSubset(from deck: DMTClipDeck, selectedSegment: DMTClipSegment) -> [DMTClipCard] {
        let filtered = deck.clips.enumerated().compactMap { index, clip in
            switch selectedSegment {
            case .primary:
                return index.isMultiple(of: 2) ? clip : nil
            case .secondary:
                return index.isMultiple(of: 2) ? nil : clip
            }
        }

        return filtered.isEmpty ? deck.clips : filtered
    }
}
