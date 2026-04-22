import UIKit

final class DMTWelcomeViewController: UIViewController, UITextViewDelegate {
    var onShowSignIn: (() -> Void)?
    var onShowSignUp: (() -> Void)?

    private let hearthService: DMTFeastService
    private let welcomeSplashView = UIImageView.init(image: UIImage.dmtMealAsset(named: DMTPlateStamp.welcomeSplash))
//    private let houseNoteButton = UIButton()
    private let welcomeActionPlate = UIView()
    private let freshSeatButton = DMTGlowButton()
    private let returnSeatButton = UIButton()
    private let consentMarkButton = UIButton()
    private let consentCopyView = UITextView()

    private var welcomeCourse: DMTWelcomeDeck?
    private var hasConsentStamp = false {
        didSet {
            let imageName = hasConsentStamp ? DMTPlateStamp.consentOn : DMTPlateStamp.consentOff
            consentMarkButton.setImage(UIImage.dmtMealAsset(named: imageName), for: .normal)
            freshSeatButton.isEnabled = hasConsentStamp
            returnSeatButton.isEnabled = hasConsentStamp
            returnSeatButton.alpha = hasConsentStamp ? 1 : 0.5
        }
    }

    init(hearthService: DMTFeastService) {
        self.hearthService = hearthService
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = ""
       
        let welcomeGlowLayer = CAGradientLayer()
        welcomeGlowLayer.colors = [UIColor(red: 1, green: 0.6, blue: 0.47, alpha: 0).cgColor, UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor]
        welcomeGlowLayer.locations = [0, 1]
        welcomeGlowLayer.frame = view.bounds
        welcomeGlowLayer.startPoint = CGPoint(x: 0.5, y: 0)
        welcomeGlowLayer.endPoint = CGPoint(x: 1, y: 1)
        view.layer.addSublayer(welcomeGlowLayer)
        
        composeLayout()
        fetchWelcomeCopy()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private func composeLayout() {
        welcomeSplashView.contentMode = .scaleAspectFill
        welcomeSplashView.translatesAutoresizingMaskIntoConstraints = false
        welcomeSplashView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        welcomeSplashView.layer.cornerRadius = DMTScale.r(36)
//        houseNoteButton.setImage(UIImage.dmtMealAsset(named: DMTPlateStamp.houseNoteSeal), for: .normal)
//        houseNoteButton.translatesAutoresizingMaskIntoConstraints = false
//     
//        houseNoteButton.addTarget(self, action: #selector(handleHouseNoteTap), for: .touchUpInside)

        welcomeActionPlate.translatesAutoresizingMaskIntoConstraints = false
        welcomeActionPlate.backgroundColor = .clear
        welcomeActionPlate.layer.cornerRadius = DMTScale.r(28)
        welcomeActionPlate.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        freshSeatButton.translatesAutoresizingMaskIntoConstraints = false
        freshSeatButton.addTarget(self, action: #selector(handleFreshSeatTap), for: .touchUpInside)

        returnSeatButton.translatesAutoresizingMaskIntoConstraints = false
        returnSeatButton.backgroundColor = DMTPalette.blush
        returnSeatButton.setTitleColor(DMTPalette.sunrise, for: .normal)
        returnSeatButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        returnSeatButton.layer.cornerRadius = DMTScale.r(22)
        returnSeatButton.addTarget(self, action: #selector(handleKnownSeatTap), for: .touchUpInside)

        consentMarkButton.translatesAutoresizingMaskIntoConstraints = false
        consentMarkButton.tintColor = DMTPalette.sunrise
        consentMarkButton.addTarget(self, action: #selector(handleConsentToggle), for: .touchUpInside)
        
        consentCopyView.translatesAutoresizingMaskIntoConstraints = false
        consentCopyView.backgroundColor = .clear
        consentCopyView.delegate = self
        consentCopyView.isEditable = false
        consentCopyView.isScrollEnabled = false
        consentCopyView.isSelectable = true
        consentCopyView.textContainerInset = .zero
        consentCopyView.textContainer.lineFragmentPadding = 0
        consentCopyView.linkTextAttributes = [
            .foregroundColor: DMTPalette.sunrise,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        consentCopyView.tintColor = DMTPalette.sunrise

        view.addSubview(welcomeSplashView)
//        welcomeSplashView.addSubview(houseNoteButton)
        view.addSubview(welcomeActionPlate)
        welcomeActionPlate.addSubview(freshSeatButton)
        welcomeActionPlate.addSubview(returnSeatButton)
        welcomeActionPlate.addSubview(consentMarkButton)
        welcomeActionPlate.addSubview(consentCopyView)

        NSLayoutConstraint.activate([
            welcomeSplashView.topAnchor.constraint(equalTo: view.topAnchor),
            welcomeSplashView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            welcomeSplashView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            welcomeSplashView.heightAnchor.constraint(equalToConstant: DMTScale.h(379)),

//            houseNoteButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: DMTScale.h(14)),
//            houseNoteButton.trailingAnchor.constraint(equalTo: welcomeSplashView.trailingAnchor, constant: -DMTScale.w(18)),
//            houseNoteButton.widthAnchor.constraint(equalToConstant: 80),
//            houseNoteButton.heightAnchor.constraint(equalToConstant: 36),

            welcomeActionPlate.topAnchor.constraint(equalTo: welcomeSplashView.bottomAnchor, constant: -DMTScale.h(64)),
            welcomeActionPlate.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: DMTScale.w(20)),
            welcomeActionPlate.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -DMTScale.w(20)),
            welcomeActionPlate.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant:0),

        
            consentMarkButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: DMTScale.h(-32)),
            consentMarkButton.leadingAnchor.constraint(equalTo: welcomeActionPlate.leadingAnchor, constant: DMTScale.w(18)),
            consentMarkButton.widthAnchor.constraint(equalToConstant: DMTScale.w(24)),
            consentMarkButton.heightAnchor.constraint(equalToConstant: DMTScale.w(24)),

            consentCopyView.centerYAnchor.constraint(equalTo: consentMarkButton.centerYAnchor),
            consentCopyView.leadingAnchor.constraint(equalTo: consentMarkButton.trailingAnchor, constant: DMTScale.w(10)),
            consentCopyView.trailingAnchor.constraint(equalTo: welcomeActionPlate.trailingAnchor, constant: -DMTScale.w(18)),
            consentCopyView.heightAnchor.constraint(equalToConstant: DMTScale.h(52)),
            
            returnSeatButton.bottomAnchor.constraint(equalTo: consentMarkButton.topAnchor, constant: DMTScale.h(-72)),
            returnSeatButton.leadingAnchor.constraint(equalTo: welcomeActionPlate.leadingAnchor, constant: DMTScale.w(18)),
            returnSeatButton.trailingAnchor.constraint(equalTo: welcomeActionPlate.trailingAnchor, constant: -DMTScale.w(18)),
            returnSeatButton.heightAnchor.constraint(equalToConstant: DMTScale.h(54)),
            
            freshSeatButton.bottomAnchor.constraint(equalTo: returnSeatButton.topAnchor, constant: DMTScale.h(-16)),
            freshSeatButton.leadingAnchor.constraint(equalTo: welcomeActionPlate.leadingAnchor, constant: DMTScale.w(18)),
            freshSeatButton.trailingAnchor.constraint(equalTo: welcomeActionPlate.trailingAnchor, constant: -DMTScale.w(18)),
            freshSeatButton.heightAnchor.constraint(equalToConstant: DMTScale.h(54)),

           

        ])

        hasConsentStamp = false
    }

    private func fetchWelcomeCopy() {
        Task { [weak self] in
            guard let self else { return }
            do {
                let bundle = try await hearthService.fetchWelcomeBundle()
                await MainActor.run {
                    self.welcomeCourse = bundle.DMTshiwelcome
                    self.renderWelcomeCopy(bundle.DMTshiwelcome)
                }
            } catch {
                await MainActor.run {
                    self.dmtServeNotice(title: DMTStringCellar.shared.serve("copy.signalLostTitle"), message: error.localizedDescription)
                }
            }
        }
    }

    private func renderWelcomeCopy(_ deck: DMTWelcomeDeck) {
//        houseNoteButton.setTitle(DMTStringCellar.shared.serve("copy.eula"), for: .normal)
        freshSeatButton.setTitle(deck.primaryTitle, for: .normal)
        returnSeatButton.setTitle(deck.secondaryTitle, for: .normal)
        renderConsentCopy()
    }

    private func renderConsentCopy() {
        let leadCopy = DMTStringCellar.shared.serve("copy.welcomeConsentLead")
        let termsCopy = DMTStringCellar.shared.serve("copy.welcomeConsentTerms")
        let middleCopy = DMTStringCellar.shared.serve("copy.welcomeConsentMiddle")
        let privacyCopy = DMTStringCellar.shared.serve("copy.welcomeConsentPrivacy")
        let tailCopy = DMTStringCellar.shared.serve("copy.welcomeConsentTail")

        let platedCopy = NSMutableAttributedString(
            string: leadCopy,
            attributes: [
                .font: UIFont.systemFont(ofSize: 13, weight: .medium),
                .foregroundColor: DMTPalette.cloudInk
            ]
        )

        platedCopy.append(
            NSAttributedString(
                string: termsCopy,
                attributes: [
                    .font: UIFont.systemFont(ofSize: 13, weight: .semibold),
                    .foregroundColor: DMTPalette.sunrise,
                    .link: URL(string: "dmtwelcome://terms")!
                ]
            )
        )
        platedCopy.append(
            NSAttributedString(
                string: middleCopy,
                attributes: [
                    .font: UIFont.systemFont(ofSize: 13, weight: .medium),
                    .foregroundColor: DMTPalette.cloudInk
                ]
            )
        )
        platedCopy.append(
            NSAttributedString(
                string: privacyCopy,
                attributes: [
                    .font: UIFont.systemFont(ofSize: 13, weight: .semibold),
                    .foregroundColor: DMTPalette.sunrise,
                    .link: URL(string: "dmtwelcome://privacy")!
                ]
            )
        )
        platedCopy.append(
            NSAttributedString(
                string: tailCopy,
                attributes: [
                    .font: UIFont.systemFont(ofSize: 13, weight: .medium),
                    .foregroundColor: DMTPalette.cloudInk
                ]
            )
        )

        consentCopyView.attributedText = platedCopy
    }

    @objc
    private func handleHouseNoteTap() {
        dmtOpenHearth(.userAgreement, title: nil, hidesTabBar: true)
    }

    @objc
    private func handleFreshSeatTap() {
        guard hasConsentStamp else { return }
        onShowSignUp?()
    }

    @objc
    private func handleKnownSeatTap() {
        guard hasConsentStamp else { return }
        onShowSignIn?()
    }

    @objc
    private func handleConsentToggle() {
        hasConsentStamp.toggle()
    }

    func textView(
        _ textView: UITextView,
        shouldInteractWith url: URL,
        in characterRange: NSRange,
        interaction: UITextItemInteraction
    ) -> Bool {
        switch url.host {
        case "terms":
            dmtOpenHearth(.userAgreement, title: nil, hidesTabBar: true)
        case "privacy":
            dmtOpenHearth(.privacyPolicy, title: nil, hidesTabBar: true)
        default:
            break
        }
        return false
    }
}
