import UIKit

final class DMTMealRoomsViewController: UIViewController {
    private let hearthService: DMTFeastService
    private let courseScrollView = UIScrollView()
    private let platingCanvas = UIView()
    private let brandMarkView = UIImageView()
    private let noticeOrbButton = UIButton()
    private let storyRailView = UIScrollView()
    private let storyRailStack = UIStackView()
    private let mealRobotBanner = UIButton()
    private let roomSectionLabel = UILabel()
    private let roomDeckStack = UIStackView()
    private let simmerSpinner = UIActivityIndicatorView(style: .medium)
    private let forgeRoomButton = UIButton()
    private var hearthDeck: DMTHomeDeck?

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
        courseScrollView.contentInsetAdjustmentBehavior = .never
        navigationItem.largeTitleDisplayMode = .never
        composeLayout()
        fetchHearthDeck()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    private func composeLayout() {
        courseScrollView.translatesAutoresizingMaskIntoConstraints = false
        platingCanvas.translatesAutoresizingMaskIntoConstraints = false

        brandMarkView.translatesAutoresizingMaskIntoConstraints = false
        brandMarkView.image = UIImage.dmtMealAsset(named: DMTPlateStamp.brandMark)

        noticeOrbButton.translatesAutoresizingMaskIntoConstraints = false
     
        noticeOrbButton.setImage(UIImage.dmtMealAsset(named: DMTPlateStamp.noticeOrb), for: .normal)
        noticeOrbButton.addTarget(self, action: #selector(handleNoticeOrbTap), for: .touchUpInside)

        storyRailView.translatesAutoresizingMaskIntoConstraints = false
        storyRailView.showsHorizontalScrollIndicator = false

        storyRailStack.translatesAutoresizingMaskIntoConstraints = false
        storyRailStack.axis = .horizontal
        storyRailStack.spacing = DMTScale.w(14)

        mealRobotBanner.translatesAutoresizingMaskIntoConstraints = false
        mealRobotBanner.setBackgroundImage(UIImage.dmtMealAsset(named: DMTPlateStamp.mealRobotBanner), for: .normal)
        mealRobotBanner.addTarget(self, action: #selector(handleMealRobotTap), for: .touchUpInside)

        roomSectionLabel.translatesAutoresizingMaskIntoConstraints = false
        roomSectionLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        roomSectionLabel.textColor = DMTPalette.ink

        roomDeckStack.translatesAutoresizingMaskIntoConstraints = false
        roomDeckStack.axis = .vertical
        roomDeckStack.spacing = DMTScale.h(14)

        simmerSpinner.translatesAutoresizingMaskIntoConstraints = false
        simmerSpinner.startAnimating()

        forgeRoomButton.translatesAutoresizingMaskIntoConstraints = false
        forgeRoomButton.setBackgroundImage(UIImage.dmtMealAsset(named: DMTPlateStamp.createRoomButton), for: .normal)
        forgeRoomButton.addTarget(self, action: #selector(handleForgeRoomTap), for: .touchUpInside)

        view.addSubview(courseScrollView)
        view.addSubview(forgeRoomButton)
        view.addSubview(simmerSpinner)
        courseScrollView.addSubview(platingCanvas)
        storyRailView.addSubview(storyRailStack)
        platingCanvas.addSubview(brandMarkView)
        platingCanvas.addSubview(noticeOrbButton)
        platingCanvas.addSubview(storyRailView)
        platingCanvas.addSubview(mealRobotBanner)
        platingCanvas.addSubview(roomSectionLabel)
        platingCanvas.addSubview(roomDeckStack)

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
            brandMarkView.widthAnchor.constraint(equalToConstant: 87),
            brandMarkView.heightAnchor.constraint(equalToConstant: 36),
            
            brandMarkView.topAnchor.constraint(equalTo: platingCanvas.topAnchor, constant: dmtTopHearthInset),
            brandMarkView.leadingAnchor.constraint(equalTo: platingCanvas.leadingAnchor, constant: DMTScale.w(16)),

            noticeOrbButton.centerYAnchor.constraint(equalTo: brandMarkView.centerYAnchor),
            noticeOrbButton.trailingAnchor.constraint(equalTo: platingCanvas.trailingAnchor, constant: -DMTScale.w(18)),
            noticeOrbButton.widthAnchor.constraint(equalToConstant: DMTScale.w(42)),
            noticeOrbButton.heightAnchor.constraint(equalToConstant: DMTScale.w(42)),

            storyRailView.topAnchor.constraint(equalTo: brandMarkView.bottomAnchor, constant: DMTScale.h(18)),
            storyRailView.leadingAnchor.constraint(equalTo: platingCanvas.leadingAnchor),
            storyRailView.trailingAnchor.constraint(equalTo: platingCanvas.trailingAnchor),
            storyRailView.heightAnchor.constraint(equalToConstant: DMTScale.h(104)),

            storyRailStack.topAnchor.constraint(equalTo: storyRailView.topAnchor),
            storyRailStack.leadingAnchor.constraint(equalTo: storyRailView.leadingAnchor, constant: DMTScale.w(12)),
            storyRailStack.trailingAnchor.constraint(equalTo: storyRailView.trailingAnchor, constant: -DMTScale.w(12)),
            storyRailStack.bottomAnchor.constraint(equalTo: storyRailView.bottomAnchor),
            storyRailStack.heightAnchor.constraint(equalTo: storyRailView.heightAnchor),

            mealRobotBanner.topAnchor.constraint(equalTo: storyRailView.bottomAnchor, constant: DMTScale.h(12)),
            mealRobotBanner.leadingAnchor.constraint(equalTo: platingCanvas.leadingAnchor, constant: DMTScale.w(15)),
            mealRobotBanner.trailingAnchor.constraint(equalTo: platingCanvas.trailingAnchor, constant: -DMTScale.w(15)),
            mealRobotBanner.heightAnchor.constraint(equalToConstant: DMTScale.h(79)),

            roomSectionLabel.topAnchor.constraint(equalTo: mealRobotBanner.bottomAnchor, constant: DMTScale.h(18)),
            roomSectionLabel.leadingAnchor.constraint(equalTo: platingCanvas.leadingAnchor, constant: DMTScale.w(16)),
            roomSectionLabel.trailingAnchor.constraint(equalTo: platingCanvas.trailingAnchor, constant: -DMTScale.w(16)),

            roomDeckStack.topAnchor.constraint(equalTo: roomSectionLabel.bottomAnchor, constant: DMTScale.h(14)),
            roomDeckStack.leadingAnchor.constraint(equalTo: platingCanvas.leadingAnchor, constant: DMTScale.w(14)),
            roomDeckStack.trailingAnchor.constraint(equalTo: platingCanvas.trailingAnchor, constant: -DMTScale.w(14)),
            roomDeckStack.bottomAnchor.constraint(equalTo: platingCanvas.bottomAnchor, constant: -DMTScale.h(120)),

            forgeRoomButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -DMTScale.w(16)),
            forgeRoomButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -DMTScale.h(26)),
            forgeRoomButton.widthAnchor.constraint(equalToConstant: DMTScale.w(118)),
            forgeRoomButton.heightAnchor.constraint(equalToConstant: DMTScale.h(50)),

            simmerSpinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            simmerSpinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func fetchHearthDeck() {
        Task { [weak self] in
            guard let self else { return }
            do {
                let deck = try await hearthService.fetchHearthDeck()
                await MainActor.run {
                    self.simmerSpinner.stopAnimating()
                    self.hearthDeck = deck
                    self.renderRoomDeck(deck: deck)
                }
            } catch {
                await MainActor.run {
                    self.simmerSpinner.stopAnimating()
                    self.dmtServeNotice(title: DMTStringCellar.shared.serve("copy.homeUnavailableTitle"), message: error.localizedDescription)
                }
            }
        }
    }

    private func renderRoomDeck(deck: DMTHomeDeck) {
        roomSectionLabel.text = deck.sectionTitle

        storyRailStack.arrangedSubviews.forEach {
            storyRailStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        for story in deck.stories {
            let storyView = DMTStoryChipView()
            storyView.renderStoryChip(story: story)
            storyView.tag = deck.stories.firstIndex(where: { $0.id == story.id }) ?? 0
            storyView.isUserInteractionEnabled = true
            storyView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleStoryRailTap(_:))))
            NSLayoutConstraint.activate([
                storyView.widthAnchor.constraint(equalToConstant: DMTScale.w(72))
            ])
            storyRailStack.addArrangedSubview(storyView)
        }

        roomDeckStack.arrangedSubviews.forEach {
            roomDeckStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        for room in deck.rooms {
            let card = DMTRoomStageCardView()
            card.apply(room: room)
            card.onInfoTap = { [weak self] in
                self?.showRoomDetail(roomID: room.id)
            }
            card.addTarget(self, action: #selector(handleRoomCardTap(_:)), for: .touchUpInside)
            card.tag = deck.rooms.firstIndex(where: { $0.id == room.id }) ?? 0
            NSLayoutConstraint.activate([
                card.heightAnchor.constraint(equalToConstant: DMTScale.h(266))
            ])
            roomDeckStack.addArrangedSubview(card)
        }
    }

    @objc
    private func handleNoticeOrbTap() {
        dmtOpenHearth(.noticeCenter)
    }

    @objc
    private func handleMealRobotTap() {
        dmtOpenHearth(.mealRobot)
    }

    @objc
    private func handleForgeRoomTap() {
        dmtOpenHearth(.createRoom)
    }

    @objc
    private func handleRoomCardTap(_ sender: UIControl) {
        guard let room = hearthDeck?.rooms[sender.tag] else { return }
        dmtOpenHearth(.joinRoom(channel: room.id, hostUserID: room.hostUserID))
    }

    @objc
    private func handleStoryRailTap(_ recognizer: UITapGestureRecognizer) {
        guard
            let storyView = recognizer.view,
            let story = hearthDeck?.stories[storyView.tag]
        else {
            return
        }

        dmtOpenHearth(.userHomepage(userID: story.id))
    }

    private func showRoomDetail(roomID: String) {
        dmtOpenHearth(.tableLounge(liveID: roomID))
    }
}
