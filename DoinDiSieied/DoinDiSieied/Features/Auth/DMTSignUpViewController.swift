import UIKit

final class DMTSignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var onFinish: ((DMTSessionPayload) -> Void)?

    private let service: DMTFeastService
    private let ticket: DMTLoginTicket
    private let profileStore: DMTTasteProfileStore
    private let preferredTitle: String
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let heroImageView = UIImageView.init(image: UIImage.init(named: "mealVibeContext"))
    private let avatarButton = UIButton(type: .custom)
    private let plusBadge = UIImageView(image: UIImage(systemName: "plus"))
    private let cardView = UIView()
    private let nicknameField = DMTInputField()
    private let bioField = DMTInputField()
    private let ageField = DMTInputField()
    private let confirmButton = DMTGlowButton()
    private let spinner = UIActivityIndicatorView(style: .medium)
    private let birthPicker = UIDatePicker()
    private var selectedBirthMonth = 0
    private var selectedBirthYear = 0
    private var selectedAvatar: UIImage?
    private var buttonTitle = "Next"

    init(service: DMTFeastService, ticket: DMTLoginTicket, profileStore: DMTTasteProfileStore, preferredTitle: String) {
        self.service = service
        self.ticket = ticket
        self.profileStore = profileStore
        self.preferredTitle = preferredTitle
        super.init(nibName: nil, bundle: nil)
        title = preferredTitle
    }

    required init?(coder: NSCoder) {
        nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = DMTPalette.paper
        navigationItem.largeTitleDisplayMode = .never
        configureLayout()
        configureBirthPicker()
        applyPlaceholderAvatar()
        loadDeck()
    }

    private func configureLayout() {
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        heroImageView.translatesAutoresizingMaskIntoConstraints = false
        heroImageView.image = makeHeroPlaceholder()
        heroImageView.contentMode = .scaleAspectFill
        heroImageView.clipsToBounds = true
        heroImageView.layer.cornerRadius = DMTScale.r(28)

        avatarButton.translatesAutoresizingMaskIntoConstraints = false
        avatarButton.backgroundColor = .white
        avatarButton.layer.cornerRadius = DMTScale.r(40)
        avatarButton.clipsToBounds = true
        avatarButton.imageView?.contentMode = .scaleAspectFill
        avatarButton.addTarget(self, action: #selector(pickAvatar), for: .touchUpInside)

        plusBadge.translatesAutoresizingMaskIntoConstraints = false
        plusBadge.tintColor = DMTPalette.lavender.withAlphaComponent(0.95)
        plusBadge.contentMode = .scaleAspectFit

        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = DMTScale.r(28)

        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.addTarget(self, action: #selector(handleConfirm), for: .touchUpInside)

        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        spinner.color = .white

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(heroImageView)
        contentView.addSubview(avatarButton)
        avatarButton.addSubview(plusBadge)
        contentView.addSubview(cardView)
        cardView.addSubview(nicknameField)
        cardView.addSubview(bioField)
        cardView.addSubview(ageField)
        cardView.addSubview(confirmButton)
        confirmButton.addSubview(spinner)

        scrollView.dmtPinEdges(to: view)

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            heroImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant:0),
            heroImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DMTScale.w(0)),
            heroImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DMTScale.w(0)),
            heroImageView.heightAnchor.constraint(equalToConstant: DMTScale.h(214)),

            avatarButton.centerXAnchor.constraint(equalTo: heroImageView.centerXAnchor),
            avatarButton.bottomAnchor.constraint(equalTo: heroImageView.bottomAnchor, constant: DMTScale.h(38)),
            avatarButton.widthAnchor.constraint(equalToConstant: DMTScale.w(80)),
            avatarButton.heightAnchor.constraint(equalToConstant: DMTScale.w(80)),

            plusBadge.centerXAnchor.constraint(equalTo: avatarButton.centerXAnchor),
            plusBadge.centerYAnchor.constraint(equalTo: avatarButton.centerYAnchor),
            plusBadge.widthAnchor.constraint(equalToConstant: DMTScale.w(22)),
            plusBadge.heightAnchor.constraint(equalToConstant: DMTScale.w(22)),

            cardView.topAnchor.constraint(equalTo: heroImageView.bottomAnchor, constant: DMTScale.h(18)),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            nicknameField.topAnchor.constraint(equalTo: cardView.topAnchor, constant: DMTScale.h(56)),
            nicknameField.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: DMTScale.w(22)),
            nicknameField.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -DMTScale.w(22)),

            bioField.topAnchor.constraint(equalTo: nicknameField.bottomAnchor, constant: DMTScale.h(18)),
            bioField.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: DMTScale.w(22)),
            bioField.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -DMTScale.w(22)),

            ageField.topAnchor.constraint(equalTo: bioField.bottomAnchor, constant: DMTScale.h(18)),
            ageField.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: DMTScale.w(22)),
            ageField.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -DMTScale.w(22)),

            confirmButton.topAnchor.constraint(equalTo: ageField.bottomAnchor, constant: DMTScale.h(30)),
            confirmButton.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: DMTScale.w(22)),
            confirmButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -DMTScale.w(22)),
            confirmButton.heightAnchor.constraint(equalToConstant: DMTScale.h(54)),
            confirmButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -DMTScale.h(34)),

            spinner.centerXAnchor.constraint(equalTo: confirmButton.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: confirmButton.centerYAnchor)
        ])
    }

    private func configureBirthPicker() {
        birthPicker.datePickerMode = .date
        birthPicker.preferredDatePickerStyle = .wheels
        birthPicker.maximumDate = Calendar.current.date(byAdding: .year, value: -18, to: Date())
        birthPicker.minimumDate = Calendar.current.date(byAdding: .year, value: -70, to: Date())
        birthPicker.locale = .current

        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.items = [
            UIBarButtonItem(systemItem: .flexibleSpace),
            UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(applyBirthSelection))
        ]

        ageField.entryField.inputView = birthPicker
        ageField.entryField.inputAccessoryView = toolbar
        ageField.entryField.tintColor = .clear
    }

    private func loadDeck() {
        Task { [weak self] in
            guard let self else { return }
            do {
                let bundle = try await service.fetchAuthBundle()
                await MainActor.run {
                    self.applyDeck(bundle.signUp)
                }
            } catch {
                await MainActor.run {
                    self.dmtShowNotice(title: "Signal Lost", message: error.localizedDescription)
                }
            }
        }
    }

    private func applyDeck(_ deck: DMTSignUpDeck) {
        title = preferredTitle
        buttonTitle = deck.buttonTitle
        nicknameField.apply(title: deck.nicknameTitle, placeholder: deck.nicknamePlaceholder)
        bioField.apply(title: deck.bioTitle, placeholder: deck.bioPlaceholder)
        ageField.apply(title: deck.ageTitle, placeholder: deck.agePlaceholder)
        confirmButton.setTitle(deck.buttonTitle, for: .normal)
    }

    private func applyPlaceholderAvatar() {
        let avatar = makeAvatarPlaceholder()
        avatarButton.setBackgroundImage(avatar, for: .normal)
    }

    @objc
    private func pickAvatar() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }

    @objc
    private func applyBirthSelection() {
        let components = Calendar.current.dateComponents([.month, .year], from: birthPicker.date)
        selectedBirthMonth = components.month ?? 1
        selectedBirthYear = components.year ?? 2000

        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        ageField.entryField.text = formatter.string(from: birthPicker.date)
        ageField.entryField.resignFirstResponder()
    }

    @objc
    private func handleConfirm() {
        let nickname = nicknameField.text.trimmingCharacters(in: .whitespacesAndNewlines)
        let bio = bioField.text.trimmingCharacters(in: .whitespacesAndNewlines)
        let birthLine = ageField.text.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !nickname.isEmpty, !bio.isEmpty, !birthLine.isEmpty else {
            dmtShowNotice(title: "Incomplete Table Card", message: "Fill in nickname, bio, and your birth month before continuing.")
            return
        }

        setLoading(true)

        let draft = DMTSignUpDraft(
            ticket: ticket,
            nickname: nickname,
            bio: bio,
            birthMonth: selectedBirthMonth == 0 ? 1 : selectedBirthMonth,
            birthYear: selectedBirthYear == 0 ? 2000 : selectedBirthYear,
            birthLine: birthLine,
            avatarImage: selectedAvatar,
            verifyImage: nil
        )

        setLoading(false)

        let verifyController = DMTIdentityVerifyViewController(service: service, draft: draft, profileStore: profileStore)
        verifyController.onFinish = { [weak self] payload in
            self?.onFinish?(payload)
        }
        navigationController?.pushViewController(verifyController, animated: true)
    }

    private func setLoading(_ isLoading: Bool) {
        confirmButton.isEnabled = !isLoading
        if isLoading {
            confirmButton.setTitle(nil, for: .normal)
            spinner.startAnimating()
        } else {
            spinner.stopAnimating()
            confirmButton.setTitle(buttonTitle, for: .normal)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = (info[.editedImage] ?? info[.originalImage]) as? UIImage
        if let image {
            selectedAvatar = image
            avatarButton.setBackgroundImage(image, for: .normal)
            plusBadge.isHidden = true
        }
        picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    private func makeHeroPlaceholder() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 720, height: 420))
        return renderer.image { context in
            let colors = [DMTPalette.peach.cgColor, UIColor.white.cgColor] as CFArray
            let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors, locations: [0, 1])!
            context.cgContext.drawLinearGradient(gradient, start: .zero, end: CGPoint(x: 720, y: 420), options: [])
            let symbol = UIImage(systemName: "person.crop.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 170, weight: .light))?
                .withTintColor(UIColor.white.withAlphaComponent(0.92), renderingMode: .alwaysOriginal)
            symbol?.draw(in: CGRect(x: 275, y: 108, width: 170, height: 170))
        }
    }

    private func makeAvatarPlaceholder() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 200, height: 200))
        return renderer.image { context in
            UIColor.white.setFill()
            context.cgContext.fill(CGRect(x: 0, y: 0, width: 200, height: 200))
            let symbol = UIImage(systemName: "person.crop.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 88, weight: .light))?
                .withTintColor(DMTPalette.peach, renderingMode: .alwaysOriginal)
            symbol?.draw(in: CGRect(x: 56, y: 56, width: 88, height: 88))
        }
    }
}
