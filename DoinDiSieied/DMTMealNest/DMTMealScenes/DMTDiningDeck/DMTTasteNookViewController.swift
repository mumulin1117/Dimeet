import UIKit

final class DMTTasteNookViewController: UIViewController {
    private let hearthService: DMTFeastService
    private let seatSession: DMTSessionStore
    private let tasteLedger: DMTTasteProfileStore
    private let courseScrollView = UIScrollView()
    private let platingCanvas = UIView()
    private let nookTitleLabel = UILabel()
    private let spiceGearButton = UIButton(type: .system)
    private let profileTasteView = UIImageView()
    private let editTasteButton = UIButton(type: .system)
    private let profileNameLabel = UILabel()
    private let walletTasteCard = UIView()
    private let walletBackdropView = UIImageView()
    private let walletCaptionLabel = UILabel()
    private let walletAmountLabel = UILabel()
    private let statsRail = UIStackView()
    private let giftTasteCard = UIButton()
    private let segmentPlate = UIView()
    private let dynamicTasteButton = UIButton(type: .system)
    private let shortTasteButton = UIButton(type: .system)
    private let emptyTasteView = UIImageView()
    private var nookDigestCopy: DMTNookDigest?

    init(hearthService: DMTFeastService, seatSession: DMTSessionStore, tasteLedger: DMTTasteProfileStore) {
        self.hearthService = hearthService
        self.seatSession = seatSession
        self.tasteLedger = tasteLedger
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
        fetchDigest()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    private func composeLayout() {
        courseScrollView.contentInsetAdjustmentBehavior = .never
        courseScrollView.translatesAutoresizingMaskIntoConstraints = false
        platingCanvas.translatesAutoresizingMaskIntoConstraints = false

        nookTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        nookTitleLabel.font = UIFont.systemFont(ofSize: 28, weight: .black)
        nookTitleLabel.textColor = DMTPalette.ink
        nookTitleLabel.text = DMTStringCellar.shared.serve("copy.me")

        spiceGearButton.translatesAutoresizingMaskIntoConstraints = false
        spiceGearButton.tintColor = DMTPalette.ink
        spiceGearButton.setImage(UIImage(systemName: "gearshape.fill"), for: .normal)
        spiceGearButton.addTarget(self, action: #selector(handleSpiceGearTap), for: .touchUpInside)

        profileTasteView.translatesAutoresizingMaskIntoConstraints = false
        profileTasteView.layer.cornerRadius = DMTScale.r(34)
        profileTasteView.clipsToBounds = true
        profileTasteView.layer.borderWidth = 2
        profileTasteView.layer.borderColor = UIColor.white.cgColor
        profileTasteView.backgroundColor = UIColor.white.withAlphaComponent(0.4)

        editTasteButton.translatesAutoresizingMaskIntoConstraints = false
        editTasteButton.setBackgroundImage(UIImage.dmtMealAsset(named: DMTPlateStamp.editTasteButton), for: .normal)
        editTasteButton.addTarget(self, action: #selector(handleEditTasteTap), for: .touchUpInside)

        profileNameLabel.translatesAutoresizingMaskIntoConstraints = false
        profileNameLabel.font = UIFont.systemFont(ofSize: 22, weight: .black)
        profileNameLabel.textColor = DMTPalette.ink

        walletTasteCard.translatesAutoresizingMaskIntoConstraints = false
        walletTasteCard.contentMode = .scaleToFill
        walletTasteCard.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleWalletTasteTap)))
        walletTasteCard.isUserInteractionEnabled = true

        walletBackdropView.translatesAutoresizingMaskIntoConstraints = false
        walletBackdropView.image = UIImage.dmtMealAsset(named: DMTPlateStamp.walletCard)
        walletBackdropView.contentMode = .scaleToFill

        walletCaptionLabel.translatesAutoresizingMaskIntoConstraints = false
        walletCaptionLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        walletCaptionLabel.textColor = DMTPalette.ink

        walletAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        walletAmountLabel.font = UIFont.systemFont(ofSize: 15, weight: .black)
        walletAmountLabel.textColor = DMTPalette.ink

        statsRail.translatesAutoresizingMaskIntoConstraints = false
        statsRail.axis = .horizontal
        statsRail.distribution = .fillEqually

        giftTasteCard.translatesAutoresizingMaskIntoConstraints = false
        giftTasteCard.setBackgroundImage(UIImage.dmtMealAsset(named: DMTPlateStamp.giftCard), for: .normal)
        giftTasteCard.clipsToBounds = true
        giftTasteCard.addTarget(self, action: #selector(handleGiftTasteTap), for: .touchUpInside)

     

        segmentPlate.translatesAutoresizingMaskIntoConstraints = false
        segmentPlate.backgroundColor = UIColor.white.withAlphaComponent(0.82)
        segmentPlate.layer.cornerRadius = DMTScale.r(18)

        [dynamicTasteButton, shortTasteButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
            $0.layer.cornerRadius = DMTScale.r(16)
        }
        dynamicTasteButton.addTarget(self, action: #selector(handleDynamicShelfTap), for: .touchUpInside)
        shortTasteButton.addTarget(self, action: #selector(handleShortShelfTap), for: .touchUpInside)

        emptyTasteView.translatesAutoresizingMaskIntoConstraints = false
        emptyTasteView.contentMode = .scaleAspectFit
        let balfo = UIImageView(image: UIImage.dmtMealAsset(named: "baoshiddfv"))
        balfo.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(courseScrollView)
        courseScrollView.addSubview(platingCanvas)
        platingCanvas.addSubview(nookTitleLabel)
        platingCanvas.addSubview(spiceGearButton)
        platingCanvas.addSubview(profileTasteView)
        platingCanvas.addSubview(editTasteButton)
        platingCanvas.addSubview(profileNameLabel)
        platingCanvas.addSubview(walletTasteCard)
        platingCanvas.addSubview(statsRail)
        platingCanvas.addSubview(giftTasteCard)
        platingCanvas.addSubview(segmentPlate)
        platingCanvas.addSubview(emptyTasteView)
       
        walletTasteCard.addSubview(walletBackdropView)
//        walletTasteCard.addSubview(walletCaptionLabel)
        walletTasteCard.addSubview(balfo)
        walletTasteCard.addSubview(walletAmountLabel)
        segmentPlate.addSubview(dynamicTasteButton)
        segmentPlate.addSubview(shortTasteButton)

        emptyTasteView.bottomAnchor.constraint(equalTo: platingCanvas.bottomAnchor, constant: -DMTScale.h(40)).isActive = true
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

            nookTitleLabel.topAnchor.constraint(equalTo: platingCanvas.topAnchor, constant: dmtTopHearthInset),
            nookTitleLabel.centerXAnchor.constraint(equalTo: platingCanvas.centerXAnchor),

            spiceGearButton.centerYAnchor.constraint(equalTo: nookTitleLabel.centerYAnchor),
            spiceGearButton.trailingAnchor.constraint(equalTo: platingCanvas.trailingAnchor, constant: -DMTScale.w(16)),
            spiceGearButton.widthAnchor.constraint(equalToConstant: DMTScale.w(34)),
            spiceGearButton.heightAnchor.constraint(equalToConstant: DMTScale.w(34)),

            profileTasteView.topAnchor.constraint(equalTo: nookTitleLabel.bottomAnchor, constant: DMTScale.h(18)),
            profileTasteView.leadingAnchor.constraint(equalTo: platingCanvas.leadingAnchor, constant: DMTScale.w(16)),
            profileTasteView.widthAnchor.constraint(equalToConstant: DMTScale.w(68)),
            profileTasteView.heightAnchor.constraint(equalToConstant: DMTScale.w(68)),

            editTasteButton.topAnchor.constraint(equalTo: profileTasteView.bottomAnchor, constant: -DMTScale.h(10)),
            editTasteButton.leadingAnchor.constraint(equalTo: profileTasteView.leadingAnchor, constant: DMTScale.w(8)),
            editTasteButton.widthAnchor.constraint(equalToConstant: DMTScale.w(52)),
            editTasteButton.heightAnchor.constraint(equalToConstant: DMTScale.h(24)),

            profileNameLabel.topAnchor.constraint(equalTo: editTasteButton.bottomAnchor, constant: DMTScale.h(12)),
            profileNameLabel.leadingAnchor.constraint(equalTo: platingCanvas.leadingAnchor, constant: DMTScale.w(16)),
            profileNameLabel.widthAnchor.constraint(equalToConstant: DMTScale.w(170)),

            walletTasteCard.topAnchor.constraint(equalTo: nookTitleLabel.bottomAnchor, constant: DMTScale.h(14)),
            walletTasteCard.trailingAnchor.constraint(equalTo: platingCanvas.trailingAnchor, constant:0),
            walletTasteCard.widthAnchor.constraint(equalToConstant: DMTScale.w(168)),
            walletTasteCard.heightAnchor.constraint(equalToConstant: DMTScale.h(92)),

            walletBackdropView.topAnchor.constraint(equalTo: walletTasteCard.topAnchor),
            walletBackdropView.leadingAnchor.constraint(equalTo: walletTasteCard.leadingAnchor),
            walletBackdropView.trailingAnchor.constraint(equalTo: walletTasteCard.trailingAnchor),
            walletBackdropView.bottomAnchor.constraint(equalTo: walletTasteCard.bottomAnchor),

//            walletCaptionLabel.topAnchor.constraint(equalTo: walletTasteCard.topAnchor, constant: DMTScale.h(16)),
//            walletCaptionLabel.leadingAnchor.constraint(equalTo: walletTasteCard.leadingAnchor, constant: DMTScale.w(18)),
//            walletCaptionLabel.trailingAnchor.constraint(equalTo: walletTasteCard.trailingAnchor, constant: -DMTScale.w(18)),
            balfo.leadingAnchor.constraint(equalTo: walletTasteCard.leadingAnchor, constant: DMTScale.w(18)),
            balfo.widthAnchor.constraint(equalToConstant: 29),
            balfo.heightAnchor.constraint(equalToConstant: 21),
            balfo.centerYAnchor.constraint(equalTo: walletTasteCard.centerYAnchor, constant: 0),
            walletAmountLabel.leadingAnchor.constraint(equalTo: balfo.trailingAnchor, constant: DMTScale.w(8)),
            walletAmountLabel.centerYAnchor.constraint(equalTo: balfo.centerYAnchor, constant: 0),

            statsRail.topAnchor.constraint(equalTo: walletTasteCard.bottomAnchor, constant: DMTScale.h(12)),
            statsRail.trailingAnchor.constraint(equalTo: platingCanvas.trailingAnchor, constant: -DMTScale.w(16)),
            statsRail.widthAnchor.constraint(equalToConstant: DMTScale.w(168)),

            giftTasteCard.topAnchor.constraint(equalTo: profileNameLabel.bottomAnchor, constant: DMTScale.h(20)),
            giftTasteCard.leadingAnchor.constraint(equalTo: platingCanvas.leadingAnchor, constant: DMTScale.w(16)),
            giftTasteCard.trailingAnchor.constraint(equalTo: platingCanvas.trailingAnchor, constant: -DMTScale.w(16)),
            giftTasteCard.heightAnchor.constraint(equalToConstant: DMTScale.h(58)),

         

            segmentPlate.topAnchor.constraint(equalTo: giftTasteCard.bottomAnchor, constant: DMTScale.h(16)),
            segmentPlate.leadingAnchor.constraint(equalTo: platingCanvas.leadingAnchor, constant: DMTScale.w(16)),
            segmentPlate.widthAnchor.constraint(equalToConstant: DMTScale.w(172 + 30)),
            segmentPlate.heightAnchor.constraint(equalToConstant: DMTScale.h(40)),

            dynamicTasteButton.topAnchor.constraint(equalTo: segmentPlate.topAnchor, constant: DMTScale.h(4)),
            dynamicTasteButton.leadingAnchor.constraint(equalTo: segmentPlate.leadingAnchor, constant: DMTScale.w(4)),
            dynamicTasteButton.widthAnchor.constraint(equalToConstant: DMTScale.w(88)),
            dynamicTasteButton.bottomAnchor.constraint(equalTo: segmentPlate.bottomAnchor, constant: -DMTScale.h(4)),

            shortTasteButton.topAnchor.constraint(equalTo: segmentPlate.topAnchor, constant: DMTScale.h(4)),
            shortTasteButton.leadingAnchor.constraint(equalTo: dynamicTasteButton.trailingAnchor, constant: DMTScale.w(4)),
            shortTasteButton.bottomAnchor.constraint(equalTo: segmentPlate.bottomAnchor, constant: -DMTScale.h(4)),
            shortTasteButton.widthAnchor.constraint(equalToConstant: DMTScale.w(108)),
            emptyTasteView.centerXAnchor.constraint(equalTo: platingCanvas.centerXAnchor),
            emptyTasteView.topAnchor.constraint(equalTo: segmentPlate.bottomAnchor, constant: DMTScale.h(72)),
            emptyTasteView.widthAnchor.constraint(equalToConstant: DMTScale.w(120)),
            emptyTasteView.heightAnchor.constraint(equalToConstant: DMTScale.w(120))
        ])
    }

    private func fetchDigest() {
        Task { [weak self] in
            guard let self else { return }
            do {
                let nookDigestCopy = try await hearthService.fetchNookCourse()
                await MainActor.run {
                   
                    self.renderNookDigest(nookDigestCopy: nookDigestCopy)
                }
            } catch {
                await MainActor.run {
                    self.dmtServeNotice(title: DMTStringCellar.shared.serve("copy.profileUnavailableTitle"), message: error.localizedDescription)
                }
            }
        }
    }

    private func renderNookDigest(nookDigestCopy: DMTNookDigest) {
        self.nookDigestCopy = nookDigestCopy
        let localProfile = seatSession.session.flatMap { tasteLedger.profile(for: $0.email) }
        if let localAvatar = localProfile.flatMap({ tasteLedger.image(for: $0.avatarStamp) }), nookDigestCopy.avatarKey.isEmpty {
            profileTasteView.image = localAvatar
        } else {
            profileTasteView.dmtSetMealImage(
                source: nookDigestCopy.avatarKey,
                placeholder: localProfile.flatMap { tasteLedger.image(for: $0.avatarStamp) } ?? DMTMainArtworkFactory.avatarImage(for: nookDigestCopy.displayName)
            )
        }
        profileNameLabel.text = nookDigestCopy.displayName.isEmpty ? (localProfile?.nickname ?? "") : nookDigestCopy.displayName
        walletCaptionLabel.text = nookDigestCopy.walletTitle
        walletAmountLabel.text = " My Wallet    >"
        emptyTasteView.image = UIImage.dmtMealAsset(named: nookDigestCopy.emptyArtKey) ?? DMTMainArtworkFactory.sceneImage(for: nookDigestCopy.emptyArtKey, size: CGSize(width: 240, height: 240))

        statsRail.arrangedSubviews.forEach {
            statsRail.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        let items = [
            (DMTStringCellar.shared.serve("copy.followers"), "\(nookDigestCopy.followerCount)", 0),
            (DMTStringCellar.shared.serve("copy.following"), "\(nookDigestCopy.followingCount)", 1)
        ]
        for item in items {
            let shell = UIButton(type: .system)
            shell.tintColor = .clear
            shell.addTarget(self, action: #selector(handleStatsRailTap(_:)), for: .touchUpInside)
            shell.tag = item.2

            let stack = UIStackView()
            stack.axis = .vertical
            stack.alignment = .center
            stack.spacing = DMTScale.h(4)
            stack.translatesAutoresizingMaskIntoConstraints = false

            let valueLabel = UILabel()
            valueLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
            valueLabel.textColor = DMTPalette.ink
            valueLabel.text = item.1

            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
            label.textColor = DMTPalette.ink
            label.text = item.0

            stack.addArrangedSubview(valueLabel)
            stack.addArrangedSubview(label)
            shell.addSubview(stack)
            NSLayoutConstraint.activate([
                stack.centerXAnchor.constraint(equalTo: shell.centerXAnchor),
                stack.centerYAnchor.constraint(equalTo: shell.centerYAnchor)
            ])
            statsRail.addArrangedSubview(shell)
        }

        let dynamicTitle = nookDigestCopy.segmentTitles.first ?? DMTStringCellar.shared.serve("copy.dynamic")
        let videoTitle = nookDigestCopy.segmentTitles.dropFirst().first ?? DMTStringCellar.shared.serve("copy.shortVideo")
        dynamicTasteButton.setTitle(dynamicTitle, for: .normal)
        shortTasteButton.setTitle(videoTitle, for: .normal)
        styleProfileShelves(showDynamic: true)
    }

    @objc
    private func handleSpiceGearTap() {
        dmtOpenHearth(.settingCenter)
    }

    @objc
    private func handleDynamicShelfTap() {
        styleProfileShelves(showDynamic: true)
    }

    @objc
    private func handleShortShelfTap() {
        styleProfileShelves(showDynamic: false)
    }

    @objc
    private func handleEditTasteTap() {
        dmtOpenHearth(.editProfile)
    }

    @objc
    private func handleWalletTasteTap() {
        dmtOpenHearth(.walletCenter)
    }

    @objc
    private func handleGiftTasteTap() {
        guard let userID = nookDigestCopy?.userID, !userID.isEmpty else { return }
        dmtOpenHearth(.receivedGift(userID: userID))
    }

    @objc
    private func handleStatsRailTap(_ sender: UIButton) {
        if sender.tag == 0 {
            dmtOpenHearth(.fansList)
        } else {
            dmtOpenHearth(.followingList)
        }
    }

    private func styleProfileShelves(showDynamic: Bool) {
        dynamicTasteButton.backgroundColor = showDynamic ? DMTPalette.sunrise : .clear
        dynamicTasteButton.setTitleColor(showDynamic ? .white : DMTPalette.ink, for: .normal)
        shortTasteButton.backgroundColor = showDynamic ? .clear : DMTPalette.sunrise
        shortTasteButton.setTitleColor(showDynamic ? DMTPalette.ink : .white, for: .normal)
    }
}
