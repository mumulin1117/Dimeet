import UIKit

final class DMTLoginViewController: UIViewController, UITextFieldDelegate {
    var onFinish: ((DMTSessionPayload) -> Void)?
    var onNeedSignUp: ((DMTLoginTicket) -> Void)?

    private let hearthService: DMTFeastService
    private let tasteLedger: DMTTasteProfileStore
    private let navCourseTitle: String
    private let courseScrollView = UIScrollView()
    private let platingCanvas = UIView()
    private let bannerTasteView = UIImageView.init(image: UIImage.dmtMealAsset(named: DMTPlateStamp.loginBanner))
    private let mascotPulseView = UIImageView.init(image: UIImage.dmtMealAsset(named: DMTPlateStamp.loginMascot))
    
    private let servingCard = UIView()
    private let emailPassField = DMTInputField()
    private let secretPassField = DMTInputField()
    private let pantryHintLabel = UILabel()
    private let servePassButton = DMTGlowButton()
    private let simmerSpinner = UIActivityIndicatorView(style: .medium)
    private var ctaCopy = DMTStringCellar.shared.serve("copy.confirm")

    init(hearthService: DMTFeastService, tasteLedger: DMTTasteProfileStore, navCourseTitle: String) {
        self.hearthService = hearthService
        self.tasteLedger = tasteLedger
        self.navCourseTitle = navCourseTitle
        super.init(nibName: nil, bundle: nil)
        title = navCourseTitle
    }

    required init?(coder: NSCoder) {
        nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        pantryHintLabel.isHidden = true
        view.backgroundColor = DMTPalette.cream
        navigationItem.largeTitleDisplayMode = .never
        composeLayout()
        configureKeyboardFlow()
        fetchLoginCopy()
    }

    private func composeLayout() {
        bannerTasteView.contentMode = .scaleToFill
        
        courseScrollView.translatesAutoresizingMaskIntoConstraints = false
        platingCanvas.translatesAutoresizingMaskIntoConstraints = false
        bannerTasteView.translatesAutoresizingMaskIntoConstraints = false

        mascotPulseView.translatesAutoresizingMaskIntoConstraints = false
        mascotPulseView.backgroundColor = UIColor.white.withAlphaComponent(0.16)
        mascotPulseView.layer.cornerRadius = DMTScale.r(32)

       

        servingCard.translatesAutoresizingMaskIntoConstraints = false
        servingCard.backgroundColor = .white
        servingCard.layer.cornerRadius = DMTScale.r(28)
        servingCard.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        pantryHintLabel.translatesAutoresizingMaskIntoConstraints = false
        pantryHintLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        pantryHintLabel.textColor = DMTPalette.cloudInk
        pantryHintLabel.numberOfLines = 0

        servePassButton.translatesAutoresizingMaskIntoConstraints = false
        servePassButton.addTarget(self, action: #selector(handlePassServeTap), for: .touchUpInside)

        simmerSpinner.translatesAutoresizingMaskIntoConstraints = false
        simmerSpinner.hidesWhenStopped = true
        simmerSpinner.color = .white

        view.addSubview(courseScrollView)
        courseScrollView.addSubview(platingCanvas)
        platingCanvas.addSubview(bannerTasteView)
        bannerTasteView.addSubview(mascotPulseView)
       
        platingCanvas.addSubview(servingCard)
        servingCard.addSubview(emailPassField)
        servingCard.addSubview(secretPassField)
        servingCard.addSubview(pantryHintLabel)
        servingCard.addSubview(servePassButton)
        servePassButton.addSubview(simmerSpinner)

        courseScrollView.contentInsetAdjustmentBehavior = .never
        NSLayoutConstraint.activate([
            courseScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            courseScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            courseScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            courseScrollView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),

            platingCanvas.topAnchor.constraint(equalTo: courseScrollView.topAnchor),
            platingCanvas.leadingAnchor.constraint(equalTo: courseScrollView.leadingAnchor),
            platingCanvas.trailingAnchor.constraint(equalTo: courseScrollView.trailingAnchor),
            platingCanvas.bottomAnchor.constraint(equalTo: courseScrollView.bottomAnchor),
            platingCanvas.widthAnchor.constraint(equalTo: courseScrollView.widthAnchor),

            bannerTasteView.topAnchor.constraint(equalTo: platingCanvas.topAnchor),
            bannerTasteView.leadingAnchor.constraint(equalTo: platingCanvas.leadingAnchor),
            bannerTasteView.trailingAnchor.constraint(equalTo: platingCanvas.trailingAnchor),
            bannerTasteView.heightAnchor.constraint(equalToConstant: DMTScale.h(390)),

            mascotPulseView.centerXAnchor.constraint(equalTo: bannerTasteView.centerXAnchor),
            mascotPulseView.centerYAnchor.constraint(equalTo: bannerTasteView.centerYAnchor, constant: DMTScale.h(-8)),
            mascotPulseView.widthAnchor.constraint(equalToConstant: DMTScale.w(120)),
            mascotPulseView.heightAnchor.constraint(equalToConstant: DMTScale.w(120)),

            servingCard.topAnchor.constraint(equalTo: bannerTasteView.bottomAnchor, constant: -DMTScale.h(54)),
            servingCard.leadingAnchor.constraint(equalTo: platingCanvas.leadingAnchor),
            servingCard.trailingAnchor.constraint(equalTo: platingCanvas.trailingAnchor),
            servingCard.bottomAnchor.constraint(equalTo: platingCanvas.bottomAnchor),

            emailPassField.topAnchor.constraint(equalTo: servingCard.topAnchor, constant: DMTScale.h(32)),
            emailPassField.leadingAnchor.constraint(equalTo: servingCard.leadingAnchor, constant: DMTScale.w(20)),
            emailPassField.trailingAnchor.constraint(equalTo: servingCard.trailingAnchor, constant: -DMTScale.w(20)),

            secretPassField.topAnchor.constraint(equalTo: emailPassField.bottomAnchor, constant: DMTScale.h(20)),
            secretPassField.leadingAnchor.constraint(equalTo: servingCard.leadingAnchor, constant: DMTScale.w(20)),
            secretPassField.trailingAnchor.constraint(equalTo: servingCard.trailingAnchor, constant: -DMTScale.w(20)),

            pantryHintLabel.topAnchor.constraint(equalTo: secretPassField.bottomAnchor, constant: DMTScale.h(12)),
            pantryHintLabel.leadingAnchor.constraint(equalTo: servingCard.leadingAnchor, constant: DMTScale.w(20)),
            pantryHintLabel.trailingAnchor.constraint(equalTo: servingCard.trailingAnchor, constant: -DMTScale.w(20)),

            servePassButton.topAnchor.constraint(equalTo: pantryHintLabel.bottomAnchor, constant: DMTScale.h(22)),
            servePassButton.leadingAnchor.constraint(equalTo: servingCard.leadingAnchor, constant: DMTScale.w(20)),
            servePassButton.trailingAnchor.constraint(equalTo: servingCard.trailingAnchor, constant: -DMTScale.w(20)),
            servePassButton.heightAnchor.constraint(equalToConstant: DMTScale.h(54)),
            servePassButton.bottomAnchor.constraint(equalTo: servingCard.bottomAnchor, constant: -DMTScale.h(38)),

            simmerSpinner.centerXAnchor.constraint(equalTo: servePassButton.centerXAnchor),
            simmerSpinner.centerYAnchor.constraint(equalTo: servePassButton.centerYAnchor)
        ])
    }

    private func configureKeyboardFlow() {
        dmtSeasonKeyboardFlow(in: courseScrollView)
        emailPassField.entryField.delegate = self
        emailPassField.entryField.returnKeyType = .next
        emailPassField.entryField.enablesReturnKeyAutomatically = true
        secretPassField.entryField.delegate = self
        secretPassField.entryField.returnKeyType = .done
        secretPassField.entryField.enablesReturnKeyAutomatically = true
    }

    private func fetchLoginCopy() {
        Task { [weak self] in
            guard let self else { return }
            do {
                let bundle = try await hearthService.fetchWelcomeBundle()
                await MainActor.run {
                    self.renderLoginCopy(bundle.DMTshilogin)
                }
            } catch {
                await MainActor.run {
                    self.dmtServeNotice(title: DMTStringCellar.shared.serve("copy.signalLostTitle"), message: error.localizedDescription)
                }
            }
        }
    }

    private func renderLoginCopy(_ deck: DMTLoginDeck) {
        title = navCourseTitle
        ctaCopy = deck.ctaCopy
        emailPassField.renderFieldCopy(title: deck.DMTshiemailTitle, placeholder: deck.emailPlaceholder)
        emailPassField.entryField.keyboardType = .emailAddress
        emailPassField.entryField.textContentType = .username
        secretPassField.renderFieldCopy(title: deck.passwordTitle, placeholder: deck.passwordPlaceholder, isSecure: true)
        secretPassField.entryField.textContentType = .password
        pantryHintLabel.text = deck.hintLine
        servePassButton.setTitle(deck.ctaCopy, for: .normal)
    }

    @objc
    private func handlePassServeTap() {
        view.endEditing(true)
        let email = tasteLedger.normalizedEmail(emailPassField.text)
        let password = secretPassField.text.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !email.isEmpty, !password.isEmpty else {
            dmtServeNotice(title: DMTStringCellar.shared.serve("copy.missingTastePassTitle"), message: DMTStringCellar.shared.serve("copy.missingTastePassMessage"))
            return
        }

        setPassLoadingState(true)

        let passTicket = DMTLoginTicket(email: email, password: password)

        if tasteLedger.isTestAccount(email: email, password: password) {
            tasteLedger.ensureTestProfile()
            pourLoginSignal(passTicket: passTicket)
            return
        }

        if tasteLedger.canDirectLogin(email: email, password: password) {
            pourLoginSignal(passTicket: passTicket)
            return
        }

        if tasteLedger.hasPasswordMismatch(email: email, password: password) {
            setPassLoadingState(false)
            dmtServeNotice(title: DMTStringCellar.shared.serve("copy.tastePassFailedTitle"), message: DMTStringCellar.shared.serve("copy.passwordMismatchMessage"))
            return
        }

        setPassLoadingState(false)
        onNeedSignUp?(passTicket)
    }

    private func pourLoginSignal(passTicket: DMTLoginTicket) {
        Task { [weak self] in
            guard let self else { return }
            do {
                let payload = try await hearthService.login(email: passTicket.email, password: passTicket.password)
                await MainActor.run {
                    self.setPassLoadingState(false)
                    self.onFinish?(payload)
                }
            } catch {
                await MainActor.run {
                    self.setPassLoadingState(false)
                    self.dmtServeNotice(title: DMTStringCellar.shared.serve("copy.tastePassFailedTitle"), message: error.localizedDescription)
                }
            }
        }
    }

    private func setPassLoadingState(_ isLoading: Bool) {
        servePassButton.isEnabled = !isLoading
        if isLoading {
            servePassButton.setTitle(nil, for: .normal)
            simmerSpinner.startAnimating()
        } else {
            simmerSpinner.stopAnimating()
            servePassButton.setTitle(ctaCopy, for: .normal)
        }
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        let hostedField: UIView
        if textField === emailPassField.entryField {
            hostedField = emailPassField
        } else {
            hostedField = secretPassField
        }

        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.dmtRevealKeyboardCourse(hostedField, in: self.courseScrollView)
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === emailPassField.entryField {
            secretPassField.entryField.becomeFirstResponder()
            return false
        }

        handlePassServeTap()
        return false
    }
}
