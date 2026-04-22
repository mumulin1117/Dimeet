import UIKit

final class DMTMealMateViewController: UIViewController {
    private enum DMTDiscoverSegment {
        case primary
        case secondary
    }

    private let hearthService: DMTFeastService
    private let courseScrollView = UIScrollView()
    private let platingCanvas = UIView()
    private let discoverTitleLabel = UILabel()
    private let composerOrbButton = UIButton(type: .system)
    private let filterRail = UIStackView()
    private let freshFilterButton = UIButton(type: .system)
    private let followFilterButton = UIButton(type: .system)
    private let spotlightRail = UIStackView()
    private let rechargePromoCard = UIControl()
    private let promoBackdropView = UIImageView()
    private let promoHeadlineLabel = UILabel()
    private let galleryRail = UIStackView()
    private let simmerSpinner = UIActivityIndicatorView(style: .medium)
    private var discoverDeckCopy: DMTDiscoverDeck?
    private var spotlightMoments: [DMTMomentCard] = []
    private var galleryMoments: [DMTMomentCard] = []
    private var activeDiscoverSegment: DMTDiscoverSegment = .primary

    init(hearthService: DMTFeastService) {
        self.hearthService = hearthService
        super.init(nibName: nil, bundle: nil)
        title = ""
    }

    required init?(coder: NSCoder) {
        nil
    }

    private lazy var backdropCanvas: UIImageView = {
         let statement = UIImageView.init(image: UIImage.dmtMealAsset(named: DMTPlateStamp.hearthBackdrop))
         statement.contentMode = .scaleToFill
        statement.frame = UIScreen.main.bounds
         return statement
     }()
     override func viewDidLoad() {
         super.viewDidLoad()
         view.addSubview(backdropCanvas)
        navigationItem.largeTitleDisplayMode = .never
        composeLayout()
         courseScrollView.contentInsetAdjustmentBehavior = .never
        fetchDiscoverCourse()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    private func composeLayout() {
        courseScrollView.translatesAutoresizingMaskIntoConstraints = false
        platingCanvas.translatesAutoresizingMaskIntoConstraints = false

        discoverTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        discoverTitleLabel.font = UIFont.systemFont(ofSize: 28, weight: .black)
        discoverTitleLabel.textColor = DMTPalette.ink
        discoverTitleLabel.textAlignment = .center

        composerOrbButton.translatesAutoresizingMaskIntoConstraints = false
        composerOrbButton.setBackgroundImage(UIImage.dmtMealAsset(named: DMTPlateStamp.discoverComposer), for: .normal)
        composerOrbButton.addTarget(self, action: #selector(handleComposerOrbTap), for: .touchUpInside)

        filterRail.translatesAutoresizingMaskIntoConstraints = false
        filterRail.axis = .horizontal
        filterRail.spacing = DMTScale.w(18)

        [freshFilterButton, followFilterButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.setTitleColor(DMTPalette.ink, for: .normal)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        }
        freshFilterButton.addTarget(self, action: #selector(handleFreshFilterTap), for: .touchUpInside)
        followFilterButton.addTarget(self, action: #selector(handleFollowFilterTap), for: .touchUpInside)

        spotlightRail.translatesAutoresizingMaskIntoConstraints = false
        spotlightRail.axis = .vertical
        spotlightRail.spacing = DMTScale.h(12)

        rechargePromoCard.translatesAutoresizingMaskIntoConstraints = false
        rechargePromoCard.layer.cornerRadius = DMTScale.r(18)
        rechargePromoCard.clipsToBounds = true
        rechargePromoCard.addTarget(self, action: #selector(handleRechargePromoTap), for: .touchUpInside)

        promoBackdropView.translatesAutoresizingMaskIntoConstraints = false
        promoBackdropView.contentMode = .scaleAspectFill

        promoHeadlineLabel.translatesAutoresizingMaskIntoConstraints = false
        promoHeadlineLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        promoHeadlineLabel.textColor = .white
        promoHeadlineLabel.numberOfLines = 0

        galleryRail.translatesAutoresizingMaskIntoConstraints = false
        galleryRail.axis = .horizontal
        galleryRail.spacing = DMTScale.w(12)
        galleryRail.distribution = .fillEqually

        simmerSpinner.translatesAutoresizingMaskIntoConstraints = false
        simmerSpinner.startAnimating()

        view.addSubview(courseScrollView)
        view.addSubview(simmerSpinner)
        courseScrollView.addSubview(platingCanvas)
        platingCanvas.addSubview(discoverTitleLabel)
        platingCanvas.addSubview(composerOrbButton)
        platingCanvas.addSubview(filterRail)
        platingCanvas.addSubview(spotlightRail)
        platingCanvas.addSubview(rechargePromoCard)
        platingCanvas.addSubview(galleryRail)
        filterRail.addArrangedSubview(freshFilterButton)
        filterRail.addArrangedSubview(followFilterButton)
        rechargePromoCard.addSubview(promoBackdropView)
        rechargePromoCard.addSubview(promoHeadlineLabel)

        NSLayoutConstraint.activate([
            courseScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            courseScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            courseScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            courseScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            platingCanvas.topAnchor.constraint(equalTo: courseScrollView.topAnchor),
            platingCanvas.leadingAnchor.constraint(equalTo: courseScrollView.leadingAnchor),
            platingCanvas.trailingAnchor.constraint(equalTo: courseScrollView.trailingAnchor),
            platingCanvas.bottomAnchor.constraint(equalTo: courseScrollView.bottomAnchor),
            platingCanvas.widthAnchor.constraint(equalTo: courseScrollView.widthAnchor),

            discoverTitleLabel.topAnchor.constraint(equalTo: platingCanvas.topAnchor, constant: dmtTopHearthInset),
            discoverTitleLabel.centerXAnchor.constraint(equalTo: platingCanvas.centerXAnchor),

            composerOrbButton.centerYAnchor.constraint(equalTo: discoverTitleLabel.centerYAnchor),
            composerOrbButton.trailingAnchor.constraint(equalTo: platingCanvas.trailingAnchor, constant: -DMTScale.w(18)),
            composerOrbButton.widthAnchor.constraint(equalToConstant: DMTScale.w(38)),
            composerOrbButton.heightAnchor.constraint(equalToConstant: DMTScale.w(38)),

            filterRail.topAnchor.constraint(equalTo: discoverTitleLabel.bottomAnchor, constant: DMTScale.h(20)),
            filterRail.leadingAnchor.constraint(equalTo: platingCanvas.leadingAnchor, constant: DMTScale.w(18)),

            spotlightRail.topAnchor.constraint(equalTo: filterRail.bottomAnchor, constant: DMTScale.h(14)),
            spotlightRail.leadingAnchor.constraint(equalTo: platingCanvas.leadingAnchor, constant: DMTScale.w(14)),
            spotlightRail.trailingAnchor.constraint(equalTo: platingCanvas.trailingAnchor, constant: -DMTScale.w(14)),

            rechargePromoCard.topAnchor.constraint(equalTo: spotlightRail.bottomAnchor, constant: DMTScale.h(16)),
            rechargePromoCard.leadingAnchor.constraint(equalTo: platingCanvas.leadingAnchor, constant: DMTScale.w(14)),
            rechargePromoCard.trailingAnchor.constraint(equalTo: platingCanvas.trailingAnchor, constant: -DMTScale.w(14)),
            rechargePromoCard.heightAnchor.constraint(equalToConstant: DMTScale.h(104)),

            promoBackdropView.topAnchor.constraint(equalTo: rechargePromoCard.topAnchor),
            promoBackdropView.leadingAnchor.constraint(equalTo: rechargePromoCard.leadingAnchor),
            promoBackdropView.trailingAnchor.constraint(equalTo: rechargePromoCard.trailingAnchor),
            promoBackdropView.bottomAnchor.constraint(equalTo: rechargePromoCard.bottomAnchor),

            promoHeadlineLabel.trailingAnchor.constraint(equalTo: rechargePromoCard.trailingAnchor, constant: -DMTScale.w(16)),
            promoHeadlineLabel.centerYAnchor.constraint(equalTo: rechargePromoCard.centerYAnchor),
            promoHeadlineLabel.widthAnchor.constraint(equalToConstant: DMTScale.w(132)),

            galleryRail.topAnchor.constraint(equalTo: rechargePromoCard.bottomAnchor, constant: DMTScale.h(16)),
            galleryRail.leadingAnchor.constraint(equalTo: platingCanvas.leadingAnchor, constant: DMTScale.w(14)),
            galleryRail.trailingAnchor.constraint(equalTo: platingCanvas.trailingAnchor, constant: -DMTScale.w(14)),
            galleryRail.heightAnchor.constraint(equalToConstant: DMTScale.h(204)),
            galleryRail.bottomAnchor.constraint(equalTo: platingCanvas.bottomAnchor, constant: -DMTScale.h(120)),

            simmerSpinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            simmerSpinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func fetchDiscoverCourse() {
        Task { [weak self] in
            guard let self else { return }
            do {
                let deck = try await hearthService.fetchDiscoverCourse()
                await MainActor.run {
                    self.simmerSpinner.stopAnimating()
                    self.discoverDeckCopy = deck
                    self.styleDiscoverHeader(deck: deck)
                    self.renderMoments(using: deck, activeDiscoverSegment: .primary, animated: false)
                }
            } catch {
                await MainActor.run {
                    self.simmerSpinner.stopAnimating()
                    self.dmtServeNotice(title: DMTStringCellar.shared.serve("copy.discoverUnavailableTitle"), message: error.localizedDescription)
                }
            }
        }
    }

    private func styleDiscoverHeader(deck: DMTDiscoverDeck) {
        discoverTitleLabel.text = deck.title
        freshFilterButton.setTitle(deck.primaryTitle, for: .normal)
        followFilterButton.setTitle(deck.secondaryTitle, for: .normal)

        promoBackdropView.image = UIImage.dmtMealAsset(named: deck.promo.artKey) ?? DMTMainArtworkFactory.sceneImage(for: deck.promo.artKey, size: CGSize(width: 700, height: 220))
        promoHeadlineLabel.text = deck.promo.title
        promoHeadlineLabel.isHidden = true
    }

    @objc
    private func handleComposerOrbTap() {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: DMTStringCellar.shared.serve("copy.issueDynamic"), style: .default) { [weak self] _ in
            self?.dmtOpenHearth(.publishDynamic)
        })
        sheet.addAction(UIAlertAction(title: DMTStringCellar.shared.serve("copy.postVideo"), style: .default) { [weak self] _ in
            self?.dmtOpenHearth(.publishVideo)
        })
        sheet.addAction(UIAlertAction(title: DMTStringCellar.shared.serve("copy.cancel"), style: .cancel))
        if let popover = sheet.popoverPresentationController {
            popover.sourceView = composerOrbButton
            popover.sourceRect = composerOrbButton.bounds
        }
        present(sheet, animated: true)
    }

    @objc
    private func handleFreshFilterTap() {
        guard let deck = discoverDeckCopy, activeDiscoverSegment != .primary else { return }
        renderMoments(using: deck, activeDiscoverSegment: .primary, animated: true)
    }

    @objc
    private func handleFollowFilterTap() {
        guard let deck = discoverDeckCopy, activeDiscoverSegment != .secondary else { return }
        renderMoments(using: deck, activeDiscoverSegment: .secondary, animated: true)
    }

    @objc
    private func handleSpotlightTap(_ sender: UIControl) {
        guard spotlightMoments.indices.contains(sender.tag) else { return }
        openMomentPortal(for: spotlightMoments[sender.tag], seatMark: "spotlight")
    }

    @objc
    private func handleGalleryCardTap(_ sender: UIControl) {
        guard galleryMoments.indices.contains(sender.tag) else { return }
        openMomentPortal(for: galleryMoments[sender.tag], seatMark: "gallery")
    }

    @objc
    private func handleRechargePromoTap() {
        let portalRoute: DMTHearthPortalRoute = .walletCenter
        print("[DMTMealMate] tap=promo page=\(portalRoute.portalTraceLine)")
        if let portalURL = portalRoute.portalTraceURL {
            print("[DMTMealMate] url=\(portalURL)")
        }
        dmtOpenHearth(portalRoute)
    }

    private func styleDiscoverRail(selectedPrimary: Bool) {
        let selectedColor = DMTPalette.ink
        let deselectedColor = DMTPalette.cloudInk.withAlphaComponent(0.6)
        freshFilterButton.setTitleColor(selectedPrimary ? selectedColor : deselectedColor, for: .normal)
        followFilterButton.setTitleColor(selectedPrimary ? deselectedColor : selectedColor, for: .normal)
    }

    private func renderMoments(using deck: DMTDiscoverDeck, activeDiscoverSegment: DMTDiscoverSegment, animated: Bool) {
        self.activeDiscoverSegment = activeDiscoverSegment
        styleDiscoverRail(selectedPrimary: activeDiscoverSegment == .primary)

        let bucket = discoverMomentSlice(from: deck, activeDiscoverSegment: activeDiscoverSegment)
        spotlightMoments = Array(bucket.prefix(4))
        let overflow = Array(bucket.dropFirst(4).prefix(2))
        galleryMoments = overflow.isEmpty ? Array(spotlightMoments.prefix(2)) : overflow

        let spotlightRefresh = { [self] in
            spotlightRail.arrangedSubviews.forEach {
                spotlightRail.removeArrangedSubview($0)
                $0.removeFromSuperview()
            }

            let rows = stride(from: 0, to: spotlightMoments.count, by: 2).map {
                Array(spotlightMoments[$0..<min($0 + 2, spotlightMoments.count)])
            }

            for row in rows {
                let rowStack = UIStackView()
                rowStack.axis = .horizontal
                rowStack.spacing = DMTScale.w(12)
                rowStack.distribution = .fillEqually
                for card in row {
                    let servingCard = DMTDiscoverCardView()
                    servingCard.apply(moment: card)
                    servingCard.onAvatarTap = { [weak self, weak servingCard] in
                        guard let self, let servingCard else { return }
                        self.dmtPresentGuestSheet(userID: card.authorUserID, anchor: servingCard)
                    }
                    servingCard.tag = spotlightMoments.firstIndex(where: { $0.id == card.id }) ?? 0
                    servingCard.addTarget(self, action: #selector(handleSpotlightTap(_:)), for: .touchUpInside)
                    NSLayoutConstraint.activate([
                        servingCard.heightAnchor.constraint(equalToConstant: DMTScale.h(204))
                    ])
                    rowStack.addArrangedSubview(servingCard)
                }
                spotlightRail.addArrangedSubview(rowStack)
            }
        }

        let galleryRefresh = { [self] in
            galleryRail.arrangedSubviews.forEach {
                galleryRail.removeArrangedSubview($0)
                $0.removeFromSuperview()
            }

            for (index, card) in galleryMoments.enumerated() {
                let galleryView = DMTDiscoverCardView()
                galleryView.apply(moment: card)
                galleryView.onAvatarTap = { [weak self, weak galleryView] in
                    guard let self, let galleryView else { return }
                    self.dmtPresentGuestSheet(userID: card.authorUserID, anchor: galleryView)
                }
                galleryView.tag = index
                galleryView.addTarget(self, action: #selector(handleGalleryCardTap(_:)), for: .touchUpInside)
                galleryRail.addArrangedSubview(galleryView)
            }
        }

        if animated {
            UIView.transition(with: spotlightRail, duration: 0.22, options: [.transitionCrossDissolve, .allowAnimatedContent], animations: spotlightRefresh)
            UIView.transition(with: galleryRail, duration: 0.22, options: [.transitionCrossDissolve, .allowAnimatedContent], animations: galleryRefresh)
        } else {
            spotlightRefresh()
            galleryRefresh()
        }
    }

    private func discoverMomentSlice(from deck: DMTDiscoverDeck, activeDiscoverSegment: DMTDiscoverSegment) -> [DMTMomentCard] {
        let combined = deck.spotlight + deck.gallery
        let filtered = combined.enumerated().compactMap { index, moment in
            switch activeDiscoverSegment {
            case .primary:
                return index.isMultiple(of: 2) ? moment : nil
            case .secondary:
                return index.isMultiple(of: 2) ? nil : moment
            }
        }

        return filtered.isEmpty ? combined : filtered
    }

    private func openMomentPortal(for moment: DMTMomentCard, seatMark: String) {
        let cleanedDynamicID = moment.id.trimmingCharacters(in: .whitespacesAndNewlines)
        guard cleanedDynamicID.isEmpty == false else {
            print("[DMTMealMate] tap=\(seatMark) skipped-empty-dynamicId mode=\(moment.modeTag) title=\(moment.dish)")
            return
        }

        let portalRoute = routeForMoment(moment, dynamicID: cleanedDynamicID)
        print("[DMTMealMate] tap=\(seatMark) mode=\(moment.modeTag) dynamicId=\(cleanedDynamicID) title=\(moment.dish) page=\(portalRoute.portalTraceLine)")
        if let portalURL = portalRoute.portalTraceURL {
            print("[DMTMealMate] url=\(portalURL)")
        }
        dmtOpenHearth(portalRoute)
    }

    private func routeForMoment(_ moment: DMTMomentCard, dynamicID: String) -> DMTHearthPortalRoute {
        let pictureSeal = DMTStringCellar.shared.serve("copy.modePicture")
        let audioSeal = DMTStringCellar.shared.serve("copy.modeAudio")

        switch moment.modeTag {
        case pictureSeal:
            return .dynamicDetail(dynamicID: dynamicID)
        case audioSeal:
            return .dynamicDetail(dynamicID: dynamicID)
        default:
            return .dynamicDetail(dynamicID: dynamicID)
        }
    }
}
