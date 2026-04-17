import UIKit

final class DMTWelcomeViewController: UIViewController {
    var onShowSignIn: (() -> Void)?
    var onShowSignUp: (() -> Void)?
    var onShowAgreement: (() -> Void)?

    private let service: DMTFeastService
    private let heroView = UIImageView.init(image: UIImage.init(named: "aromaSenseScope"))
//    private let eyebrowLabel = UILabel()
//    private let titleLabel = UILabel()
//    private let subtitleLabel = UILabel()
//    private let symbolShell = UIView()
//    private let symbolView = UIImageView(image: UIImage(systemName: "fork.knife.circle.fill"))
    private let eulaButton = UIButton()
    private let panelView = UIView()
    private let primaryButton = DMTGlowButton()
    private let secondaryButton = UIButton()
    private let consentButton = UIButton()
    private let consentLabel = UILabel()
//    private let activityView = UIActivityIndicatorView(style: .medium)

    private var welcomeDeck: DMTWelcomeDeck?
    private var consentGranted = false {
        didSet {
            let imageName = consentGranted ? "bitterCoreModulesel" : "bitterCoreModule"
            consentButton.setImage(UIImage(named: imageName), for: .normal)
            primaryButton.isEnabled = consentGranted
            secondaryButton.isEnabled = consentGranted
            secondaryButton.alpha = consentGranted ? 1 : 0.5
        }
    }

    init(service: DMTFeastService) {
        self.service = service
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = ""
       
        let setingcover = CAGradientLayer()
        setingcover.colors = [UIColor(red: 1, green: 0.6, blue: 0.47, alpha: 0).cgColor, UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor]
        setingcover.locations = [0, 1]
        setingcover.frame = view.bounds
        setingcover.startPoint = CGPoint(x: 0.5, y: 0)
        setingcover.endPoint = CGPoint(x: 1, y: 1)
        view.layer.addSublayer(setingcover)
        
        configureLayout()
        loadDeck()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private func configureLayout() {
        heroView.contentMode = .scaleAspectFill
        heroView.translatesAutoresizingMaskIntoConstraints = false
        heroView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        heroView.layer.cornerRadius = DMTScale.r(36)
        eulaButton.setImage(UIImage.init(named: "allooELUA"), for: .normal)
        eulaButton.translatesAutoresizingMaskIntoConstraints = false
     
        eulaButton.addTarget(self, action: #selector(showAgreement), for: .touchUpInside)

//        symbolShell.translatesAutoresizingMaskIntoConstraints = false
//        symbolShell.backgroundColor = UIColor.white.withAlphaComponent(0.18)
//        symbolShell.layer.cornerRadius = DMTScale.r(42)

//        symbolView.translatesAutoresizingMaskIntoConstraints = false
//        symbolView.tintColor = .white
//        symbolView.contentMode = .scaleAspectFit
//
//        eyebrowLabel.translatesAutoresizingMaskIntoConstraints = false
//        eyebrowLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
//        eyebrowLabel.textColor = UIColor.white.withAlphaComponent(0.92)
//
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        titleLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
//        titleLabel.textColor = .white
//        titleLabel.numberOfLines = 0
//
//        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
//        subtitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
//        subtitleLabel.textColor = UIColor.white.withAlphaComponent(0.9)
//        subtitleLabel.numberOfLines = 0

        panelView.translatesAutoresizingMaskIntoConstraints = false
        panelView.backgroundColor = .clear
        panelView.layer.cornerRadius = DMTScale.r(28)
        panelView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        primaryButton.translatesAutoresizingMaskIntoConstraints = false
        primaryButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)

        secondaryButton.translatesAutoresizingMaskIntoConstraints = false
        secondaryButton.backgroundColor = DMTPalette.blush
        secondaryButton.setTitleColor(DMTPalette.sunrise, for: .normal)
        secondaryButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        secondaryButton.layer.cornerRadius = DMTScale.r(22)
        secondaryButton.addTarget(self, action: #selector(handleSignIn), for: .touchUpInside)

        consentButton.translatesAutoresizingMaskIntoConstraints = false
        consentButton.tintColor = DMTPalette.sunrise
        consentButton.addTarget(self, action: #selector(toggleConsent), for: .touchUpInside)
        
        consentLabel.translatesAutoresizingMaskIntoConstraints = false
        consentLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        consentLabel.textColor = DMTPalette.cloudInk
        consentLabel.numberOfLines = 0

//        activityView.translatesAutoresizingMaskIntoConstraints = false
//        activityView.color = .white
//        activityView.startAnimating()

        view.addSubview(heroView)
        heroView.addSubview(eulaButton)
//        heroView.addSubview(symbolShell)
//        symbolShell.addSubview(symbolView)
//        heroView.addSubview(eyebrowLabel)
//        heroView.addSubview(titleLabel)
//        heroView.addSubview(subtitleLabel)
//        heroView.addSubview(activityView)
        view.addSubview(panelView)
        panelView.addSubview(primaryButton)
        panelView.addSubview(secondaryButton)
        panelView.addSubview(consentButton)
        panelView.addSubview(consentLabel)

        NSLayoutConstraint.activate([
            heroView.topAnchor.constraint(equalTo: view.topAnchor),
            heroView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            heroView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            heroView.heightAnchor.constraint(equalToConstant: DMTScale.h(379)),

            eulaButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: DMTScale.h(14)),
            eulaButton.trailingAnchor.constraint(equalTo: heroView.trailingAnchor, constant: -DMTScale.w(18)),
            eulaButton.widthAnchor.constraint(equalToConstant: 80),
            eulaButton.heightAnchor.constraint(equalToConstant: 36),
            
            
//            symbolShell.topAnchor.constraint(equalTo: eulaButton.bottomAnchor, constant: DMTScale.h(38)),
//            symbolShell.leadingAnchor.constraint(equalTo: heroView.leadingAnchor, constant: DMTScale.w(28)),
//            symbolShell.widthAnchor.constraint(equalToConstant: DMTScale.w(84)),
//            symbolShell.heightAnchor.constraint(equalToConstant: DMTScale.w(84)),

//            symbolView.centerXAnchor.constraint(equalTo: symbolShell.centerXAnchor),
//            symbolView.centerYAnchor.constraint(equalTo: symbolShell.centerYAnchor),
//            symbolView.widthAnchor.constraint(equalToConstant: DMTScale.w(44)),
//            symbolView.heightAnchor.constraint(equalToConstant: DMTScale.w(44)),
//
//            eyebrowLabel.topAnchor.constraint(equalTo: symbolShell.bottomAnchor, constant: DMTScale.h(26)),
//            eyebrowLabel.leadingAnchor.constraint(equalTo: heroView.leadingAnchor, constant: DMTScale.w(28)),
//            eyebrowLabel.trailingAnchor.constraint(equalTo: heroView.trailingAnchor, constant: -DMTScale.w(28)),
//
//            titleLabel.topAnchor.constraint(equalTo: eyebrowLabel.bottomAnchor, constant: DMTScale.h(12)),
//            titleLabel.leadingAnchor.constraint(equalTo: heroView.leadingAnchor, constant: DMTScale.w(28)),
//            titleLabel.trailingAnchor.constraint(equalTo: heroView.trailingAnchor, constant: -DMTScale.w(28)),
//
//            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: DMTScale.h(14)),
//            subtitleLabel.leadingAnchor.constraint(equalTo: heroView.leadingAnchor, constant: DMTScale.w(28)),
//            subtitleLabel.trailingAnchor.constraint(equalTo: heroView.trailingAnchor, constant: -DMTScale.w(28)),

//            activityView.topAnchor.constraint(equalTo: heroView.bottomAnchor, constant: DMTScale.h(18)),
//            activityView.leadingAnchor.constraint(equalTo: heroView.leadingAnchor, constant: DMTScale.w(28)),
//
//
            panelView.topAnchor.constraint(equalTo: heroView.bottomAnchor, constant: -DMTScale.h(64)),
            panelView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: DMTScale.w(20)),
            panelView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -DMTScale.w(20)),
            panelView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant:0),

        
            consentButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: DMTScale.h(-32)),
            consentButton.leadingAnchor.constraint(equalTo: panelView.leadingAnchor, constant: DMTScale.w(18)),
            consentButton.widthAnchor.constraint(equalToConstant: DMTScale.w(24)),
            consentButton.heightAnchor.constraint(equalToConstant: DMTScale.w(24)),

            consentLabel.centerYAnchor.constraint(equalTo: consentButton.centerYAnchor),
            consentLabel.leadingAnchor.constraint(equalTo: consentButton.trailingAnchor, constant: DMTScale.w(10)),
            consentLabel.trailingAnchor.constraint(equalTo: panelView.trailingAnchor, constant: -DMTScale.w(18)),
            
            secondaryButton.bottomAnchor.constraint(equalTo: consentButton.topAnchor, constant: DMTScale.h(-72)),
            secondaryButton.leadingAnchor.constraint(equalTo: panelView.leadingAnchor, constant: DMTScale.w(18)),
            secondaryButton.trailingAnchor.constraint(equalTo: panelView.trailingAnchor, constant: -DMTScale.w(18)),
            secondaryButton.heightAnchor.constraint(equalToConstant: DMTScale.h(54)),
            
            primaryButton.bottomAnchor.constraint(equalTo: secondaryButton.topAnchor, constant: DMTScale.h(-16)),
            primaryButton.leadingAnchor.constraint(equalTo: panelView.leadingAnchor, constant: DMTScale.w(18)),
            primaryButton.trailingAnchor.constraint(equalTo: panelView.trailingAnchor, constant: -DMTScale.w(18)),
            primaryButton.heightAnchor.constraint(equalToConstant: DMTScale.h(54)),

           

        ])

        consentGranted = false
    }

    private func loadDeck() {
        Task { [weak self] in
            guard let self else { return }
            do {
                let bundle = try await service.fetchAuthBundle()
                await MainActor.run {
                    self.welcomeDeck = bundle.welcome
                    self.applyDeck(bundle.welcome)
                }
            } catch {
                await MainActor.run {
//                    self.activityView.stopAnimating()
                    self.dmtShowNotice(title: "Signal Lost", message: error.localizedDescription)
                }
            }
        }
    }

    private func applyDeck(_ deck: DMTWelcomeDeck) {
//        activityView.stopAnimating()
//        eyebrowLabel.text = deck.eyebrow
//        titleLabel.text = deck.title
//        subtitleLabel.text = deck.subtitle
        eulaButton.setTitle(deck.eulaTitle, for: .normal)
        primaryButton.setTitle(deck.primaryTitle, for: .normal)
        secondaryButton.setTitle(deck.secondaryTitle, for: .normal)
        consentLabel.text = deck.agreementHint
    }

    @objc
    private func showAgreement() {
        onShowAgreement?()
    }

    @objc
    private func handleSignUp() {
        guard consentGranted else { return }
        onShowSignUp?()
    }

    @objc
    private func handleSignIn() {
        guard consentGranted else { return }
        onShowSignIn?()
    }

    @objc
    private func toggleConsent() {
        consentGranted.toggle()
    }
}
