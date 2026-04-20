import UIKit

final class DMTTasteNookViewController: UIViewController {
    private let service: DMTFeastService
    private let sessionStore: DMTSessionStore
    private let profileStore: DMTTasteProfileStore
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let gradientView = UIView()
    private let titleLabel = UILabel()
    private let settingsButton = UIButton(type: .system)
    private let avatarView = UIImageView()
    private let editButton = UIButton(type: .system)
    private let nameLabel = UILabel()
    private let walletCard = UIView()
    private let walletBackgroundView = UIImageView()
    private let walletTitleLabel = UILabel()
    private let walletValueLabel = UILabel()
    private let statsStack = UIStackView()
    private let giftCard = UIButton()
//    private let giftBackgroundView = UIImageView()
//    private let giftLabel = UILabel()
    private let segmentShell = UIView()
    private let dynamicButton = UIButton(type: .system)
    private let videoButton = UIButton(type: .system)
    private let emptyImageView = UIImageView()
  
//    private let spinner = UIActivityIndicatorView(style: .medium)

    init(service: DMTFeastService, sessionStore: DMTSessionStore, profileStore: DMTTasteProfileStore) {
        self.service = service
        self.sessionStore = sessionStore
        self.profileStore = profileStore
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
        fetchDigest()
    }

    private func configureLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        gradientView.translatesAutoresizingMaskIntoConstraints = false
        gradientView.layer.cornerRadius = DMTScale.r(32)
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 1, green: 0.83, blue: 0.49, alpha: 1).cgColor,
            UIColor(red: 1, green: 0.6, blue: 0.43, alpha: 1).cgColor,
            UIColor(red: 0.99, green: 0.75, blue: 0.76, alpha: 1).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientView.layer.insertSublayer(gradientLayer, at: 0)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .black)
        titleLabel.textColor = DMTPalette.ink
        titleLabel.text = "Me"

        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.tintColor = DMTPalette.ink
        settingsButton.setImage(UIImage(systemName: "gearshape.fill"), for: .normal)
        settingsButton.addTarget(self, action: #selector(handleSettingsTap), for: .touchUpInside)

        avatarView.translatesAutoresizingMaskIntoConstraints = false
        avatarView.layer.cornerRadius = DMTScale.r(34)
        avatarView.clipsToBounds = true
        avatarView.layer.borderWidth = 2
        avatarView.layer.borderColor = UIColor.white.cgColor
        avatarView.backgroundColor = UIColor.white.withAlphaComponent(0.4)

        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.setBackgroundImage(UIImage(named: "toppingExtraSide"), for: .normal)

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.systemFont(ofSize: 22, weight: .black)
        nameLabel.textColor = DMTPalette.ink

        walletCard.translatesAutoresizingMaskIntoConstraints = false
        walletCard.layer.cornerRadius = DMTScale.r(24)
        walletCard.clipsToBounds = true

        walletBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        walletBackgroundView.image = UIImage(named: "safeAreaInsets")
        walletBackgroundView.contentMode = .scaleToFill

        walletTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        walletTitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        walletTitleLabel.textColor = DMTPalette.ink

        walletValueLabel.translatesAutoresizingMaskIntoConstraints = false
        walletValueLabel.font = UIFont.systemFont(ofSize: 28, weight: .black)
        walletValueLabel.textColor = DMTPalette.ink

        statsStack.translatesAutoresizingMaskIntoConstraints = false
        statsStack.axis = .horizontal
        statsStack.distribution = .fillEqually

        giftCard.translatesAutoresizingMaskIntoConstraints = false
        giftCard.setBackgroundImage(UIImage(named: "longPressTime"), for: .normal)
        giftCard.clipsToBounds = true

     

        segmentShell.translatesAutoresizingMaskIntoConstraints = false
        segmentShell.backgroundColor = UIColor.white.withAlphaComponent(0.82)
        segmentShell.layer.cornerRadius = DMTScale.r(18)

        [dynamicButton, videoButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
            $0.layer.cornerRadius = DMTScale.r(16)
        }
        dynamicButton.addTarget(self, action: #selector(handleDynamicTap), for: .touchUpInside)
        videoButton.addTarget(self, action: #selector(handleVideoTap), for: .touchUpInside)

        emptyImageView.translatesAutoresizingMaskIntoConstraints = false
        emptyImageView.contentMode = .scaleAspectFit

        view.addSubview(scrollView)
      
        scrollView.addSubview(contentView)
        contentView.addSubview(gradientView)
        gradientView.addSubview(titleLabel)
        gradientView.addSubview(settingsButton)
        gradientView.addSubview(avatarView)
        gradientView.addSubview(editButton)
        gradientView.addSubview(nameLabel)
        gradientView.addSubview(walletCard)
        gradientView.addSubview(statsStack)
        gradientView.addSubview(giftCard)
        gradientView.addSubview(segmentShell)
        gradientView.addSubview(emptyImageView)
       
        walletCard.addSubview(walletBackgroundView)
        walletCard.addSubview(walletTitleLabel)
        walletCard.addSubview(walletValueLabel)
       
        segmentShell.addSubview(dynamicButton)
        segmentShell.addSubview(videoButton)

        scrollView.dmtPinEdges(to: view)

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            gradientView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: DMTScale.h(4)),
            gradientView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DMTScale.w(10)),
            gradientView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DMTScale.w(10)),
            gradientView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -DMTScale.h(120)),

            titleLabel.topAnchor.constraint(equalTo: gradientView.topAnchor, constant: DMTScale.h(14)),
            titleLabel.centerXAnchor.constraint(equalTo: gradientView.centerXAnchor),

            settingsButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            settingsButton.trailingAnchor.constraint(equalTo: gradientView.trailingAnchor, constant: -DMTScale.w(16)),
            settingsButton.widthAnchor.constraint(equalToConstant: DMTScale.w(34)),
            settingsButton.heightAnchor.constraint(equalToConstant: DMTScale.w(34)),

            avatarView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: DMTScale.h(18)),
            avatarView.leadingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: DMTScale.w(16)),
            avatarView.widthAnchor.constraint(equalToConstant: DMTScale.w(68)),
            avatarView.heightAnchor.constraint(equalToConstant: DMTScale.w(68)),

            editButton.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: -DMTScale.h(10)),
            editButton.leadingAnchor.constraint(equalTo: avatarView.leadingAnchor, constant: DMTScale.w(8)),
            editButton.widthAnchor.constraint(equalToConstant: DMTScale.w(52)),
            editButton.heightAnchor.constraint(equalToConstant: DMTScale.h(24)),

            nameLabel.topAnchor.constraint(equalTo: editButton.bottomAnchor, constant: DMTScale.h(12)),
            nameLabel.leadingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: DMTScale.w(16)),
            nameLabel.widthAnchor.constraint(equalToConstant: DMTScale.w(170)),

            walletCard.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: DMTScale.h(14)),
            walletCard.trailingAnchor.constraint(equalTo: gradientView.trailingAnchor, constant: -DMTScale.w(16)),
            walletCard.widthAnchor.constraint(equalToConstant: DMTScale.w(168)),
            walletCard.heightAnchor.constraint(equalToConstant: DMTScale.h(92)),

            walletBackgroundView.topAnchor.constraint(equalTo: walletCard.topAnchor),
            walletBackgroundView.leadingAnchor.constraint(equalTo: walletCard.leadingAnchor),
            walletBackgroundView.trailingAnchor.constraint(equalTo: walletCard.trailingAnchor),
            walletBackgroundView.bottomAnchor.constraint(equalTo: walletCard.bottomAnchor),

            walletTitleLabel.topAnchor.constraint(equalTo: walletCard.topAnchor, constant: DMTScale.h(16)),
            walletTitleLabel.leadingAnchor.constraint(equalTo: walletCard.leadingAnchor, constant: DMTScale.w(18)),
            walletTitleLabel.trailingAnchor.constraint(equalTo: walletCard.trailingAnchor, constant: -DMTScale.w(18)),

            walletValueLabel.leadingAnchor.constraint(equalTo: walletCard.leadingAnchor, constant: DMTScale.w(18)),
            walletValueLabel.bottomAnchor.constraint(equalTo: walletCard.bottomAnchor, constant: -DMTScale.h(14)),

            statsStack.topAnchor.constraint(equalTo: walletCard.bottomAnchor, constant: DMTScale.h(12)),
            statsStack.trailingAnchor.constraint(equalTo: gradientView.trailingAnchor, constant: -DMTScale.w(16)),
            statsStack.widthAnchor.constraint(equalToConstant: DMTScale.w(168)),

            giftCard.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: DMTScale.h(20)),
            giftCard.leadingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: DMTScale.w(16)),
            giftCard.trailingAnchor.constraint(equalTo: gradientView.trailingAnchor, constant: -DMTScale.w(16)),
            giftCard.heightAnchor.constraint(equalToConstant: DMTScale.h(48)),

         

            segmentShell.topAnchor.constraint(equalTo: giftCard.bottomAnchor, constant: DMTScale.h(16)),
            segmentShell.leadingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: DMTScale.w(16)),
            segmentShell.widthAnchor.constraint(equalToConstant: DMTScale.w(172)),
            segmentShell.heightAnchor.constraint(equalToConstant: DMTScale.h(40)),

            dynamicButton.topAnchor.constraint(equalTo: segmentShell.topAnchor, constant: DMTScale.h(4)),
            dynamicButton.leadingAnchor.constraint(equalTo: segmentShell.leadingAnchor, constant: DMTScale.w(4)),
            dynamicButton.widthAnchor.constraint(equalToConstant: DMTScale.w(88)),
            dynamicButton.bottomAnchor.constraint(equalTo: segmentShell.bottomAnchor, constant: -DMTScale.h(4)),

            videoButton.topAnchor.constraint(equalTo: segmentShell.topAnchor, constant: DMTScale.h(4)),
            videoButton.leadingAnchor.constraint(equalTo: dynamicButton.trailingAnchor, constant: DMTScale.w(4)),
            videoButton.trailingAnchor.constraint(equalTo: segmentShell.trailingAnchor, constant: -DMTScale.w(4)),
            videoButton.bottomAnchor.constraint(equalTo: segmentShell.bottomAnchor, constant: -DMTScale.h(4)),

            emptyImageView.centerXAnchor.constraint(equalTo: gradientView.centerXAnchor),
            emptyImageView.topAnchor.constraint(equalTo: segmentShell.bottomAnchor, constant: DMTScale.h(72)),
            emptyImageView.widthAnchor.constraint(equalToConstant: DMTScale.w(120)),
            emptyImageView.heightAnchor.constraint(equalToConstant: DMTScale.w(120)),
//
//            emptyLabel.topAnchor.constraint(equalTo: emptyImageView.bottomAnchor, constant: DMTScale.h(12)),
//            emptyLabel.centerXAnchor.constraint(equalTo: gradientView.centerXAnchor),
//            emptyLabel.bottomAnchor.constraint(equalTo: gradientView.bottomAnchor, constant: -DMTScale.h(180)),
//
//            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

      
//        gradientLayer.frame = gradientView.bounds
    }

    private func fetchDigest() {
        Task { [weak self] in
            guard let self else { return }
            do {
                let digest = try await service.fetchNookDigest()
                await MainActor.run {
                   
                    self.apply(digest: digest)
                }
            } catch {
                await MainActor.run {
                   
                    self.dmtShowNotice(title: "Profile Unavailable", message: error.localizedDescription)
                }
            }
        }
    }

    private func apply(digest: DMTNookDigest) {
        let localProfile = sessionStore.session.flatMap { profileStore.profile(for: $0.email) }
        if let localAvatar = localProfile.flatMap({ profileStore.image(for: $0.avatarStamp) }), digest.avatarKey.isEmpty {
            avatarView.image = localAvatar
        } else {
            avatarView.dmtSetMealImage(
                source: digest.avatarKey,
                placeholder: localProfile.flatMap { profileStore.image(for: $0.avatarStamp) } ?? DMTMainArtworkFactory.avatarImage(for: digest.displayName)
            )
        }
        nameLabel.text = digest.displayName.isEmpty ? (localProfile?.nickname ?? "") : digest.displayName
        walletTitleLabel.text = digest.walletTitle
        walletValueLabel.text = "\(digest.walletBalance)"
        
        emptyImageView.image = UIImage(named: digest.emptyArtKey) ?? DMTMainArtworkFactory.sceneImage(for: digest.emptyArtKey, size: CGSize(width: 240, height: 240))
//        emptyLabel.text = digest.emptyTitle

        statsStack.arrangedSubviews.forEach {
            statsStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        let items = [
            ("Followers", "\(digest.followerCount)"),
            ("Following", "\(digest.followingCount)")
        ]
        for item in items {
            let shell = UIStackView()
            shell.axis = .vertical
            shell.alignment = .center
            shell.spacing = DMTScale.h(4)

            let valueLabel = UILabel()
            valueLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
            valueLabel.textColor = DMTPalette.ink
            valueLabel.text = item.1

            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
            label.textColor = DMTPalette.ink
            label.text = item.0

            shell.addArrangedSubview(valueLabel)
            shell.addArrangedSubview(label)
            statsStack.addArrangedSubview(shell)
        }

        let dynamicTitle = digest.segmentTitles.first ?? "Dynamic"
        let videoTitle = digest.segmentTitles.dropFirst().first ?? "Short Video"
        dynamicButton.setTitle(dynamicTitle, for: .normal)
        videoButton.setTitle(videoTitle, for: .normal)
        styleSegments(showDynamic: true)
    }

    @objc
    private func handleSettingsTap() {
        let alert = UIAlertController(title: "Settings", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Log out", style: .destructive) { [weak self] _ in
            self?.sessionStore.clear()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }

    @objc
    private func handleDynamicTap() {
        styleSegments(showDynamic: true)
    }

    @objc
    private func handleVideoTap() {
        styleSegments(showDynamic: false)
    }

    private func styleSegments(showDynamic: Bool) {
        dynamicButton.backgroundColor = showDynamic ? DMTPalette.sunrise : .clear
        dynamicButton.setTitleColor(showDynamic ? .white : DMTPalette.ink, for: .normal)
        videoButton.backgroundColor = showDynamic ? .clear : DMTPalette.sunrise
        videoButton.setTitleColor(showDynamic ? DMTPalette.ink : .white, for: .normal)
    }
}
