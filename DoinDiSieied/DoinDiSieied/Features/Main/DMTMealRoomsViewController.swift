import UIKit

final class DMTMealRoomsViewController: UIViewController {
    private let service: DMTFeastService
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let brandLabel = UIImageView()
    private let actionButton = UIButton()
    private let storyScrollView = UIScrollView()
    private let storyStack = UIStackView()
    private let mateButton = UIButton()
//    private let mateImageView = UIImageView()
//    private let mateTitleLabel = UILabel()
    private let roomTitleLabel = UILabel()
    private let roomStack = UIStackView()
    private let spinner = UIActivityIndicatorView(style: .medium)
    private let createRoomButton = UIButton()
    private var homeDeck: DMTHomeDeck?

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
//        view.backgroundColor = DMTPalette.cream
        navigationItem.largeTitleDisplayMode = .never
        configureLayout()
        fetchHomeDeck()
    }

    private func configureLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        brandLabel.translatesAutoresizingMaskIntoConstraints = false
        brandLabel.image = UIImage(named: "Dimmenter")

        actionButton.translatesAutoresizingMaskIntoConstraints = false
     
        actionButton.setImage(UIImage(named: "nitoaniIconb"), for: .normal)
        actionButton.addTarget(self, action: #selector(handleQuickAction), for: .touchUpInside)

        storyScrollView.translatesAutoresizingMaskIntoConstraints = false
        storyScrollView.showsHorizontalScrollIndicator = false

        storyStack.translatesAutoresizingMaskIntoConstraints = false
        storyStack.axis = .horizontal
        storyStack.spacing = DMTScale.w(14)

        mateButton.translatesAutoresizingMaskIntoConstraints = false
        mateButton.setBackgroundImage(UIImage.init(named: "RobotRoomds"), for: .normal)
        mateButton.addTarget(self, action: #selector(handleMateTap), for: .touchUpInside)

//        mateImageView.translatesAutoresizingMaskIntoConstraints = false
//        mateImageView.contentMode = .scaleAspectFit
//
//        mateTitleLabel.translatesAutoresizingMaskIntoConstraints = false
//        mateTitleLabel.font = UIFont.systemFont(ofSize: 22, weight: .black)
//        mateTitleLabel.textColor = DMTPalette.ink

        roomTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        roomTitleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        roomTitleLabel.textColor = DMTPalette.ink

        roomStack.translatesAutoresizingMaskIntoConstraints = false
        roomStack.axis = .vertical
        roomStack.spacing = DMTScale.h(14)

        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()

        createRoomButton.translatesAutoresizingMaskIntoConstraints = false
        createRoomButton.setBackgroundImage(UIImage(named: "createrRoom"), for: .normal)
        createRoomButton.addTarget(self, action: #selector(handleCreateRoom), for: .touchUpInside)

        view.addSubview(scrollView)
        view.addSubview(createRoomButton)
        view.addSubview(spinner)
        scrollView.addSubview(contentView)
        storyScrollView.addSubview(storyStack)
        contentView.addSubview(brandLabel)
        contentView.addSubview(actionButton)
        contentView.addSubview(storyScrollView)
        contentView.addSubview(mateButton)
//        mateButton.addSubview(mateImageView)
//        mateButton.addSubview(mateTitleLabel)
        contentView.addSubview(roomTitleLabel)
        contentView.addSubview(roomStack)

        scrollView.dmtPinEdges(to: view)

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            brandLabel.widthAnchor.constraint(equalToConstant: 87),
            brandLabel.heightAnchor.constraint(equalToConstant: 36),
            
            brandLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: DMTScale.h(6)),
            brandLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DMTScale.w(16)),

            actionButton.centerYAnchor.constraint(equalTo: brandLabel.centerYAnchor),
            actionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DMTScale.w(18)),
            actionButton.widthAnchor.constraint(equalToConstant: DMTScale.w(42)),
            actionButton.heightAnchor.constraint(equalToConstant: DMTScale.w(42)),

            storyScrollView.topAnchor.constraint(equalTo: brandLabel.bottomAnchor, constant: DMTScale.h(18)),
            storyScrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            storyScrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            storyScrollView.heightAnchor.constraint(equalToConstant: DMTScale.h(104)),

            storyStack.topAnchor.constraint(equalTo: storyScrollView.topAnchor),
            storyStack.leadingAnchor.constraint(equalTo: storyScrollView.leadingAnchor, constant: DMTScale.w(12)),
            storyStack.trailingAnchor.constraint(equalTo: storyScrollView.trailingAnchor, constant: -DMTScale.w(12)),
            storyStack.bottomAnchor.constraint(equalTo: storyScrollView.bottomAnchor),
            storyStack.heightAnchor.constraint(equalTo: storyScrollView.heightAnchor),

            mateButton.topAnchor.constraint(equalTo: storyScrollView.bottomAnchor, constant: DMTScale.h(12)),
            mateButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DMTScale.w(15)),
            mateButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DMTScale.w(15)),
            mateButton.heightAnchor.constraint(equalToConstant: DMTScale.h(79)),

//            mateImageView.leadingAnchor.constraint(equalTo: mateButton.leadingAnchor, constant: DMTScale.w(12)),
//            mateImageView.centerYAnchor.constraint(equalTo: mateButton.centerYAnchor),
//            mateImageView.widthAnchor.constraint(equalToConstant: DMTScale.w(58)),
//            mateImageView.heightAnchor.constraint(equalToConstant: DMTScale.w(58)),
//
//            mateTitleLabel.leadingAnchor.constraint(equalTo: mateImageView.trailingAnchor, constant: DMTScale.w(12)),
//            mateTitleLabel.centerYAnchor.constraint(equalTo: mateButton.centerYAnchor),
//            mateTitleLabel.trailingAnchor.constraint(equalTo: mateButton.trailingAnchor, constant: -DMTScale.w(18)),

            roomTitleLabel.topAnchor.constraint(equalTo: mateButton.bottomAnchor, constant: DMTScale.h(18)),
            roomTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DMTScale.w(16)),
            roomTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DMTScale.w(16)),

            roomStack.topAnchor.constraint(equalTo: roomTitleLabel.bottomAnchor, constant: DMTScale.h(14)),
            roomStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DMTScale.w(14)),
            roomStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DMTScale.w(14)),
            roomStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -DMTScale.h(120)),

            createRoomButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -DMTScale.w(16)),
            createRoomButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -DMTScale.h(26)),
            createRoomButton.widthAnchor.constraint(equalToConstant: DMTScale.w(118)),
            createRoomButton.heightAnchor.constraint(equalToConstant: DMTScale.h(50)),

            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func fetchHomeDeck() {
        Task { [weak self] in
            guard let self else { return }
            do {
                let deck = try await service.fetchHomeDeck()
                await MainActor.run {
                    self.spinner.stopAnimating()
                    self.homeDeck = deck
                    self.apply(deck: deck)
                }
            } catch {
                await MainActor.run {
                    self.spinner.stopAnimating()
                    self.dmtShowNotice(title: "Home Unavailable", message: error.localizedDescription)
                }
            }
        }
    }

    private func apply(deck: DMTHomeDeck) {
     
//        mateImageView.image = DMTMainArtworkFactory.sceneImage(for: deck.mateBanner.artKey, size: CGSize(width: 120, height: 120))
//        mateTitleLabel.text = deck.mateBanner.title
        roomTitleLabel.text = deck.sectionTitle
//        createRoomButton.setTitle(deck.createRoomTitle, for: .normal)

        storyStack.arrangedSubviews.forEach {
            storyStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        for story in deck.stories {
            let storyView = DMTStoryChipView()
            storyView.apply(story: story)
            storyView.tag = deck.stories.firstIndex(where: { $0.id == story.id }) ?? 0
            storyView.isUserInteractionEnabled = true
            storyView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleStoryTap(_:))))
            NSLayoutConstraint.activate([
                storyView.widthAnchor.constraint(equalToConstant: DMTScale.w(72))
            ])
            storyStack.addArrangedSubview(storyView)
        }

        roomStack.arrangedSubviews.forEach {
            roomStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        for room in deck.rooms {
            let card = DMTRoomStageCardView()
            card.apply(room: room)
            card.onInfoTap = { [weak self] in
                self?.showRoomDetail(roomID: room.id)
            }
            card.addTarget(self, action: #selector(handleRoomTap(_:)), for: .touchUpInside)
            card.tag = deck.rooms.firstIndex(where: { $0.id == room.id }) ?? 0
            NSLayoutConstraint.activate([
                card.heightAnchor.constraint(equalToConstant: DMTScale.h(266))
            ])
            roomStack.addArrangedSubview(card)
        }
    }

    @objc
    private func handleQuickAction() {
        dmtOpenPortal(.noticeCenter)
    }

    @objc
    private func handleMateTap() {
        dmtOpenPortal(.mealRobot)
    }

    @objc
    private func handleCreateRoom() {
        dmtOpenPortal(.createRoom)
    }

    @objc
    private func handleRoomTap(_ sender: UIControl) {
        guard let room = homeDeck?.rooms[sender.tag] else { return }
        dmtOpenPortal(.joinRoom(channel: room.id, hostUserID: room.hostUserID))
    }

    @objc
    private func handleStoryTap(_ recognizer: UITapGestureRecognizer) {
        guard
            let storyView = recognizer.view,
            let story = homeDeck?.stories[storyView.tag]
        else {
            return
        }

        dmtOpenPortal(.userHomepage(userID: story.id))
    }

    private func showRoomDetail(roomID: String) {
        dmtOpenPortal(.tableLounge(liveID: roomID))
    }
}
