import UIKit

final class DMTMealMateViewController: UIViewController {
    private let service: DMTFeastService
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let titleLabel = UILabel()
    private let addButton = UIButton(type: .system)
    private let filterStack = UIStackView()
    private let primaryButton = UIButton(type: .system)
    private let secondaryButton = UIButton(type: .system)
    private let spotlightStack = UIStackView()
    private let promoCard = UIControl()
    private let promoImageView = UIImageView()
    private let promoTitleLabel = UILabel()
    private let galleryStack = UIStackView()
    private let spinner = UIActivityIndicatorView(style: .medium)
    private var discoverDeck: DMTDiscoverDeck?

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
        fetchDiscoverDeck()
    }

    private func configureLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .black)
        titleLabel.textColor = DMTPalette.ink
        titleLabel.textAlignment = .center

        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.setBackgroundImage(UIImage(named: "menuPageLayout"), for: .normal)
        addButton.addTarget(self, action: #selector(handleAdd), for: .touchUpInside)

        filterStack.translatesAutoresizingMaskIntoConstraints = false
        filterStack.axis = .horizontal
        filterStack.spacing = DMTScale.w(18)

        [primaryButton, secondaryButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.setTitleColor(DMTPalette.ink, for: .normal)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        }
        primaryButton.addTarget(self, action: #selector(handlePrimaryFilter), for: .touchUpInside)
        secondaryButton.addTarget(self, action: #selector(handleSecondaryFilter), for: .touchUpInside)

        spotlightStack.translatesAutoresizingMaskIntoConstraints = false
        spotlightStack.axis = .vertical
        spotlightStack.spacing = DMTScale.h(12)

        promoCard.translatesAutoresizingMaskIntoConstraints = false
        promoCard.layer.cornerRadius = DMTScale.r(18)
        promoCard.clipsToBounds = true
        promoCard.addTarget(self, action: #selector(handlePromoTap), for: .touchUpInside)

        promoImageView.translatesAutoresizingMaskIntoConstraints = false
        promoImageView.contentMode = .scaleAspectFill

        promoTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        promoTitleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        promoTitleLabel.textColor = .white
        promoTitleLabel.numberOfLines = 0

        galleryStack.translatesAutoresizingMaskIntoConstraints = false
        galleryStack.axis = .horizontal
        galleryStack.spacing = DMTScale.w(12)
        galleryStack.distribution = .fillEqually

        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()

        view.addSubview(scrollView)
        view.addSubview(spinner)
        scrollView.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(addButton)
        contentView.addSubview(filterStack)
        contentView.addSubview(spotlightStack)
        contentView.addSubview(promoCard)
        contentView.addSubview(galleryStack)
        filterStack.addArrangedSubview(primaryButton)
        filterStack.addArrangedSubview(secondaryButton)
        promoCard.addSubview(promoImageView)
        promoCard.addSubview(promoTitleLabel)

        scrollView.dmtPinEdges(to: view)

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            titleLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: DMTScale.h(6)),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            addButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            addButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DMTScale.w(18)),
            addButton.widthAnchor.constraint(equalToConstant: DMTScale.w(38)),
            addButton.heightAnchor.constraint(equalToConstant: DMTScale.w(38)),

            filterStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: DMTScale.h(20)),
            filterStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DMTScale.w(18)),

            spotlightStack.topAnchor.constraint(equalTo: filterStack.bottomAnchor, constant: DMTScale.h(14)),
            spotlightStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DMTScale.w(14)),
            spotlightStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DMTScale.w(14)),

            promoCard.topAnchor.constraint(equalTo: spotlightStack.bottomAnchor, constant: DMTScale.h(16)),
            promoCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DMTScale.w(14)),
            promoCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DMTScale.w(14)),
            promoCard.heightAnchor.constraint(equalToConstant: DMTScale.h(104)),

            promoImageView.topAnchor.constraint(equalTo: promoCard.topAnchor),
            promoImageView.leadingAnchor.constraint(equalTo: promoCard.leadingAnchor),
            promoImageView.trailingAnchor.constraint(equalTo: promoCard.trailingAnchor),
            promoImageView.bottomAnchor.constraint(equalTo: promoCard.bottomAnchor),

            promoTitleLabel.trailingAnchor.constraint(equalTo: promoCard.trailingAnchor, constant: -DMTScale.w(16)),
            promoTitleLabel.centerYAnchor.constraint(equalTo: promoCard.centerYAnchor),
            promoTitleLabel.widthAnchor.constraint(equalToConstant: DMTScale.w(132)),

            galleryStack.topAnchor.constraint(equalTo: promoCard.bottomAnchor, constant: DMTScale.h(16)),
            galleryStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DMTScale.w(14)),
            galleryStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DMTScale.w(14)),
            galleryStack.heightAnchor.constraint(equalToConstant: DMTScale.h(204)),
            galleryStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -DMTScale.h(120)),

            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func fetchDiscoverDeck() {
        Task { [weak self] in
            guard let self else { return }
            do {
                let deck = try await service.fetchDiscoverDeck()
                await MainActor.run {
                    self.spinner.stopAnimating()
                    self.discoverDeck = deck
                    self.apply(deck: deck)
                }
            } catch {
                await MainActor.run {
                    self.spinner.stopAnimating()
                    self.dmtShowNotice(title: "Discover Unavailable", message: error.localizedDescription)
                }
            }
        }
    }

    private func apply(deck: DMTDiscoverDeck) {
        titleLabel.text = deck.title
        primaryButton.setTitle(deck.primaryTitle, for: .normal)
        secondaryButton.setTitle(deck.secondaryTitle, for: .normal)
        styleFilters(selectedPrimary: true)

        spotlightStack.arrangedSubviews.forEach {
            spotlightStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        let rows = stride(from: 0, to: deck.spotlight.count, by: 2).map {
            Array(deck.spotlight[$0..<min($0 + 2, deck.spotlight.count)])
        }

        for row in rows {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.spacing = DMTScale.w(12)
            rowStack.distribution = .fillEqually
            for card in row {
                let cardView = DMTDiscoverCardView()
                cardView.apply(moment: card)
                cardView.onAvatarTap = { [weak self, weak cardView] in
                    guard let self, let cardView else { return }
                    self.dmtPresentProfileSheet(userID: card.authorUserID, anchor: cardView)
                }
                cardView.tag = deck.spotlight.firstIndex(where: { $0.id == card.id }) ?? 0
                cardView.addTarget(self, action: #selector(handleMomentTap(_:)), for: .touchUpInside)
                NSLayoutConstraint.activate([
                    cardView.heightAnchor.constraint(equalToConstant: DMTScale.h(204))
                ])
                rowStack.addArrangedSubview(cardView)
            }
            spotlightStack.addArrangedSubview(rowStack)
        }

        promoImageView.image = UIImage(named: deck.promo.artKey) ?? DMTMainArtworkFactory.sceneImage(for: deck.promo.artKey, size: CGSize(width: 700, height: 220))
        promoTitleLabel.text = deck.promo.title
        promoTitleLabel.isHidden = true

        galleryStack.arrangedSubviews.forEach {
            galleryStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        for card in deck.gallery {
            let galleryView = DMTDiscoverCardView()
            galleryView.apply(moment: card)
            galleryView.onAvatarTap = { [weak self, weak galleryView] in
                guard let self, let galleryView else { return }
                self.dmtPresentProfileSheet(userID: card.authorUserID, anchor: galleryView)
            }
            galleryView.tag = deck.gallery.firstIndex(where: { $0.id == card.id }) ?? 0
            galleryView.addTarget(self, action: #selector(handleGalleryTap(_:)), for: .touchUpInside)
            galleryStack.addArrangedSubview(galleryView)
        }
    }

    @objc
    private func handleAdd() {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Issue Dynamic", style: .default) { [weak self] _ in
            self?.dmtOpenPortal(.publishDynamic)
        })
        sheet.addAction(UIAlertAction(title: "Post Video", style: .default) { [weak self] _ in
            self?.dmtOpenPortal(.publishVideo)
        })
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        if let popover = sheet.popoverPresentationController {
            popover.sourceView = addButton
            popover.sourceRect = addButton.bounds
        }
        present(sheet, animated: true)
    }

    @objc
    private func handlePrimaryFilter() {
        styleFilters(selectedPrimary: true)
    }

    @objc
    private func handleSecondaryFilter() {
        styleFilters(selectedPrimary: false)
    }

    @objc
    private func handleMomentTap(_ sender: UIControl) {
        guard let momentID = discoverDeck?.spotlight[sender.tag].id else { return }
        dmtOpenPortal(.dynamicDetail(dynamicID: momentID))
    }

    @objc
    private func handleGalleryTap(_ sender: UIControl) {
        guard let momentID = discoverDeck?.gallery[sender.tag].id else { return }
        dmtOpenPortal(.dynamicDetail(dynamicID: momentID))
    }

    @objc
    private func handlePromoTap() {
        dmtOpenPortal(.walletCenter)
    }

    private func styleFilters(selectedPrimary: Bool) {
        let selectedColor = DMTPalette.ink
        let deselectedColor = DMTPalette.cloudInk.withAlphaComponent(0.6)
        primaryButton.setTitleColor(selectedPrimary ? selectedColor : deselectedColor, for: .normal)
        secondaryButton.setTitleColor(selectedPrimary ? deselectedColor : selectedColor, for: .normal)
    }
}
