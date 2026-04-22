import UIKit

final class DMTBiteFeedViewController: UIViewController {
    private enum DMTClipSegment {
        case primary
        case secondary
    }

    private let hearthService: DMTFeastService
    private let courseScrollView = UIScrollView()
    private let platingCanvas = UIView()
    private let clipSegmentRail = UIStackView()
    private let clipLeadButton = UIButton(type: .system)
    private let clipFollowButton = UIButton(type: .system)
    private let noticeBubbleButton = UIButton(type: .system)
    private let clipStageStack = UIStackView()
    private let simmerSpinner = UIActivityIndicatorView(style: .medium)
    private var clipCourseDeck: DMTClipDeck?
    private var stagedClips: [DMTClipCard] = []
    private var activeClipSegment: DMTClipSegment = .primary

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
        fetchClipCourse()
         
         publishOrbButton.addTarget(self, action: #selector(handlePublishOrbTap), for: .touchUpInside)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @objc func handlePublishOrbTap()  {
        dmtOpenHearth(.publishVideo)
    }

    private func composeLayout() {
        courseScrollView.translatesAutoresizingMaskIntoConstraints = false
        platingCanvas.translatesAutoresizingMaskIntoConstraints = false
        courseScrollView.contentInsetAdjustmentBehavior = .never
        clipSegmentRail.translatesAutoresizingMaskIntoConstraints = false
        clipSegmentRail.axis = .horizontal
        clipSegmentRail.spacing = DMTScale.w(18)
        clipSegmentRail.alignment = .center

        [clipLeadButton, clipFollowButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.setTitleColor(DMTPalette.ink, for: .normal)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        }
        clipLeadButton.addTarget(self, action: #selector(handleLeadClipTap), for: .touchUpInside)
        clipFollowButton.addTarget(self, action: #selector(handleFollowClipTap), for: .touchUpInside)

        noticeBubbleButton.translatesAutoresizingMaskIntoConstraints = false
        noticeBubbleButton.setBackgroundImage(UIImage.dmtMealAsset(named: DMTPlateStamp.clipNoticeBubble), for: .normal)
        noticeBubbleButton.addTarget(self, action: #selector(handleNoticeBubbleTap), for: .touchUpInside)

        clipStageStack.translatesAutoresizingMaskIntoConstraints = false
        clipStageStack.axis = .vertical
        clipStageStack.spacing = DMTScale.h(18)

        simmerSpinner.translatesAutoresizingMaskIntoConstraints = false
        simmerSpinner.startAnimating()

        view.addSubview(courseScrollView)
        view.addSubview(simmerSpinner)
        courseScrollView.addSubview(platingCanvas)
        platingCanvas.addSubview(clipSegmentRail)
        platingCanvas.addSubview(noticeBubbleButton)
        platingCanvas.addSubview(clipStageStack)
        clipSegmentRail.addArrangedSubview(clipLeadButton)
        clipSegmentRail.addArrangedSubview(clipFollowButton)

        view.addSubview(publishOrbButton)
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

            clipSegmentRail.topAnchor.constraint(equalTo: platingCanvas.topAnchor, constant: dmtTopHearthInset),
            clipSegmentRail.leadingAnchor.constraint(equalTo: platingCanvas.leadingAnchor, constant: DMTScale.w(18)),

            noticeBubbleButton.centerYAnchor.constraint(equalTo: clipSegmentRail.centerYAnchor),
            noticeBubbleButton.trailingAnchor.constraint(equalTo: platingCanvas.trailingAnchor, constant: -DMTScale.w(18)),
            noticeBubbleButton.widthAnchor.constraint(equalToConstant: DMTScale.w(38)),
            noticeBubbleButton.heightAnchor.constraint(equalToConstant: DMTScale.w(38)),

            clipStageStack.topAnchor.constraint(equalTo: clipSegmentRail.bottomAnchor, constant: DMTScale.h(18)),
            clipStageStack.leadingAnchor.constraint(equalTo: platingCanvas.leadingAnchor, constant: DMTScale.w(12)),
            clipStageStack.trailingAnchor.constraint(equalTo: platingCanvas.trailingAnchor, constant: -DMTScale.w(12)),
            clipStageStack.bottomAnchor.constraint(equalTo: platingCanvas.bottomAnchor, constant: -DMTScale.h(120)),

            simmerSpinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            simmerSpinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            publishOrbButton.widthAnchor.constraint(equalToConstant: 30),
            publishOrbButton.heightAnchor.constraint(equalToConstant: 30),
            publishOrbButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            publishOrbButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -90),
        ])
    }

    private func fetchClipCourse() {
        Task { [weak self] in
            guard let self else { return }
            do {
                let deck = try await hearthService.fetchClipCourse()
                await MainActor.run {
                    self.simmerSpinner.stopAnimating()
                    self.clipCourseDeck = deck
                    self.styleClipHeader(deck: deck)
                    self.renderClipStage(using: deck, activeClipSegment: .primary, animated: false)
                }
            } catch {
                await MainActor.run {
                    self.simmerSpinner.stopAnimating()
                    self.dmtServeNotice(title: DMTStringCellar.shared.serve("copy.clipUnavailableTitle"), message: error.localizedDescription)
                }
            }
        }
    }

    
   private lazy var publishOrbButton: UIButton = {
        let add = UIButton.init()
        add.setImage(UIImage.dmtMealAsset(named: DMTPlateStamp.clipPublishOrb), for: .normal)
        return add
    }()
    private func styleClipHeader(deck: DMTClipDeck) {
        clipLeadButton.setTitle(deck.primaryTitle, for: .normal)
        clipFollowButton.setTitle(deck.secondaryTitle, for: .normal)
    }

    @objc
    private func handleLeadClipTap() {
        guard let deck = clipCourseDeck, activeClipSegment != .primary else { return }
        renderClipStage(using: deck, activeClipSegment: .primary, animated: true)
    }

    @objc
    private func handleFollowClipTap() {
        guard let deck = clipCourseDeck, activeClipSegment != .secondary else { return }
        renderClipStage(using: deck, activeClipSegment: .secondary, animated: true)
    }

    @objc
    private func handleClipCardTap(_ sender: UIControl) {
        guard stagedClips.indices.contains(sender.tag) else { return }
        let clip = stagedClips[sender.tag]
        dmtOpenHearth(.videoDetail(dynamicID: clip.linkedMomentID))
    }

    @objc
    private func handleNoticeBubbleTap() {
        dmtOpenHearth(.noticeCenter)
    }

    private func styleClipSegmentRail(selectedPrimary: Bool) {
        let selectedColor = DMTPalette.ink
        let deselectedColor = DMTPalette.cloudInk.withAlphaComponent(0.56)
        clipLeadButton.setTitleColor(selectedPrimary ? selectedColor : deselectedColor, for: .normal)
        clipFollowButton.setTitleColor(selectedPrimary ? deselectedColor : selectedColor, for: .normal)

        let primaryLine = selectedPrimary ? NSUnderlineStyle.single.rawValue : 0
        let secondaryLine = selectedPrimary ? 0 : NSUnderlineStyle.single.rawValue
        clipLeadButton.setAttributedTitle(NSAttributedString(string: clipLeadButton.title(for: .normal) ?? "", attributes: [.underlineStyle: primaryLine]), for: .normal)
        clipFollowButton.setAttributedTitle(NSAttributedString(string: clipFollowButton.title(for: .normal) ?? "", attributes: [.underlineStyle: secondaryLine]), for: .normal)
    }

    private func renderClipStage(using deck: DMTClipDeck, activeClipSegment: DMTClipSegment, animated: Bool) {
        self.activeClipSegment = activeClipSegment
        styleClipSegmentRail(selectedPrimary: activeClipSegment == .primary)
        stagedClips = clipRailSlice(from: deck, activeClipSegment: activeClipSegment)

        let rebuild = { [self] in
            clipStageStack.arrangedSubviews.forEach {
                clipStageStack.removeArrangedSubview($0)
                $0.removeFromSuperview()
            }

            for (index, clip) in stagedClips.enumerated() {
                let card = DMTClipStageCardView()
                card.apply(clip: clip)
                card.onAvatarTap = { [weak self, weak card] in
                    guard let self, let card else { return }
                    self.dmtPresentGuestSheet(userID: clip.creatorUserID, anchor: card)
                }
                card.onChatTap = { [weak self] in
                    self?.dmtOpenHearth(.directMessage(userID: clip.creatorUserID, videoCall: false))
                }
                card.onReportTap = { [weak self] in
                    self?.dmtOpenHearth(.reportCenter)
                }
                card.tag = index
                card.addTarget(self, action: #selector(handleClipCardTap(_:)), for: .touchUpInside)
                NSLayoutConstraint.activate([
                    card.heightAnchor.constraint(equalToConstant: DMTScale.h(610))
                ])
                clipStageStack.addArrangedSubview(card)
            }
        }

        if animated {
            UIView.transition(with: clipStageStack, duration: 0.22, options: [.transitionCrossDissolve, .allowAnimatedContent], animations: rebuild)
        } else {
            rebuild()
        }
    }

    private func clipRailSlice(from deck: DMTClipDeck, activeClipSegment: DMTClipSegment) -> [DMTClipCard] {
        let filtered = deck.clips.enumerated().compactMap { index, clip in
            switch activeClipSegment {
            case .primary:
                return index.isMultiple(of: 2) ? clip : nil
            case .secondary:
                return index.isMultiple(of: 2) ? nil : clip
            }
        }

        return filtered.isEmpty ? deck.clips : filtered
    }
}
