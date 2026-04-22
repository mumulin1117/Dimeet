import UIKit

final class DMTSignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    var onFinish: ((DMTSessionPayload) -> Void)?

    private let hearthService: DMTFeastService
    private let passTicket: DMTLoginTicket
    private let tasteLedger: DMTTasteProfileStore
    private let navCourseTitle: String
    private let courseScrollView = UIScrollView()
    private let platingCanvas = UIView()
    private let profileCoverView = UIImageView.init(image: UIImage.dmtMealAsset(named: DMTPlateStamp.signUpCover))
    private let facePlateButton = UIButton(type: .custom)
    private let avatarPlusBadge = UIImageView(image: UIImage(systemName: "plus"))
    private let servingCard = UIView()
    private let nicknamePlateField = DMTInputField()
    private let bioPlateField = DMTInputField()
    private let agePlateField = DMTInputField()
    private let nextCourseButton = DMTGlowButton()
    private let simmerSpinner = UIActivityIndicatorView(style: .medium)
    private let birthdayWheel = UIDatePicker()
    private var pickedBirthMonth = 0
    private var pickedBirthYear = 0
    private var pickedAvatarPhoto: UIImage?
    private var ctaCopy = DMTStringCellar.shared.serve("copy.next")

    init(hearthService: DMTFeastService, passTicket: DMTLoginTicket, tasteLedger: DMTTasteProfileStore, navCourseTitle: String) {
        self.hearthService = hearthService
        self.passTicket = passTicket
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
        view.backgroundColor = DMTPalette.paper
        navigationItem.largeTitleDisplayMode = .never
        composeLayout()
        configureKeyboardFlow()
        configureBirthPicker()
        primePlaceholderAvatar()
        fetchSignUpCopy()
    }

    private func composeLayout() {
        courseScrollView.contentInsetAdjustmentBehavior = .never
        courseScrollView.translatesAutoresizingMaskIntoConstraints = false
        platingCanvas.translatesAutoresizingMaskIntoConstraints = false

        profileCoverView.translatesAutoresizingMaskIntoConstraints = false
        profileCoverView.image = makeHeroPlaceholder()
        profileCoverView.contentMode = .scaleAspectFill
        profileCoverView.clipsToBounds = true
        profileCoverView.layer.cornerRadius = DMTScale.r(28)

        facePlateButton.translatesAutoresizingMaskIntoConstraints = false
        facePlateButton.backgroundColor = .white
        facePlateButton.layer.cornerRadius = DMTScale.r(40)
        facePlateButton.clipsToBounds = true
        facePlateButton.imageView?.contentMode = .scaleAspectFill
        facePlateButton.addTarget(self, action: #selector(handleAvatarPick), for: .touchUpInside)

        avatarPlusBadge.translatesAutoresizingMaskIntoConstraints = false
        avatarPlusBadge.tintColor = DMTPalette.lavender.withAlphaComponent(0.95)
        avatarPlusBadge.contentMode = .scaleAspectFit

        servingCard.translatesAutoresizingMaskIntoConstraints = false
        servingCard.backgroundColor = .white
        servingCard.layer.cornerRadius = DMTScale.r(28)

        nextCourseButton.translatesAutoresizingMaskIntoConstraints = false
        nextCourseButton.addTarget(self, action: #selector(handleNextCourseTap), for: .touchUpInside)

        simmerSpinner.translatesAutoresizingMaskIntoConstraints = false
        simmerSpinner.hidesWhenStopped = true
        simmerSpinner.color = .white

        view.addSubview(courseScrollView)
        courseScrollView.addSubview(platingCanvas)
        platingCanvas.addSubview(profileCoverView)
        platingCanvas.addSubview(facePlateButton)
        facePlateButton.addSubview(avatarPlusBadge)
        platingCanvas.addSubview(servingCard)
        servingCard.addSubview(nicknamePlateField)
        servingCard.addSubview(bioPlateField)
        servingCard.addSubview(agePlateField)
        servingCard.addSubview(nextCourseButton)
        nextCourseButton.addSubview(simmerSpinner)

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

            profileCoverView.topAnchor.constraint(equalTo: platingCanvas.topAnchor, constant:0),
            profileCoverView.leadingAnchor.constraint(equalTo: platingCanvas.leadingAnchor, constant: DMTScale.w(0)),
            profileCoverView.trailingAnchor.constraint(equalTo: platingCanvas.trailingAnchor, constant: -DMTScale.w(0)),
            profileCoverView.heightAnchor.constraint(equalToConstant: DMTScale.h(214)),

            facePlateButton.centerXAnchor.constraint(equalTo: profileCoverView.centerXAnchor),
            facePlateButton.bottomAnchor.constraint(equalTo: profileCoverView.bottomAnchor, constant: DMTScale.h(38)),
            facePlateButton.widthAnchor.constraint(equalToConstant: DMTScale.w(80)),
            facePlateButton.heightAnchor.constraint(equalToConstant: DMTScale.w(80)),

            avatarPlusBadge.centerXAnchor.constraint(equalTo: facePlateButton.centerXAnchor),
            avatarPlusBadge.centerYAnchor.constraint(equalTo: facePlateButton.centerYAnchor),
            avatarPlusBadge.widthAnchor.constraint(equalToConstant: DMTScale.w(22)),
            avatarPlusBadge.heightAnchor.constraint(equalToConstant: DMTScale.w(22)),

            servingCard.topAnchor.constraint(equalTo: profileCoverView.bottomAnchor, constant: DMTScale.h(18)),
            servingCard.leadingAnchor.constraint(equalTo: platingCanvas.leadingAnchor),
            servingCard.trailingAnchor.constraint(equalTo: platingCanvas.trailingAnchor),
            servingCard.bottomAnchor.constraint(equalTo: platingCanvas.bottomAnchor),

            nicknamePlateField.topAnchor.constraint(equalTo: servingCard.topAnchor, constant: DMTScale.h(56)),
            nicknamePlateField.leadingAnchor.constraint(equalTo: servingCard.leadingAnchor, constant: DMTScale.w(22)),
            nicknamePlateField.trailingAnchor.constraint(equalTo: servingCard.trailingAnchor, constant: -DMTScale.w(22)),

            bioPlateField.topAnchor.constraint(equalTo: nicknamePlateField.bottomAnchor, constant: DMTScale.h(18)),
            bioPlateField.leadingAnchor.constraint(equalTo: servingCard.leadingAnchor, constant: DMTScale.w(22)),
            bioPlateField.trailingAnchor.constraint(equalTo: servingCard.trailingAnchor, constant: -DMTScale.w(22)),

            agePlateField.topAnchor.constraint(equalTo: bioPlateField.bottomAnchor, constant: DMTScale.h(18)),
            agePlateField.leadingAnchor.constraint(equalTo: servingCard.leadingAnchor, constant: DMTScale.w(22)),
            agePlateField.trailingAnchor.constraint(equalTo: servingCard.trailingAnchor, constant: -DMTScale.w(22)),

            nextCourseButton.topAnchor.constraint(equalTo: agePlateField.bottomAnchor, constant: DMTScale.h(30)),
            nextCourseButton.leadingAnchor.constraint(equalTo: servingCard.leadingAnchor, constant: DMTScale.w(22)),
            nextCourseButton.trailingAnchor.constraint(equalTo: servingCard.trailingAnchor, constant: -DMTScale.w(22)),
            nextCourseButton.heightAnchor.constraint(equalToConstant: DMTScale.h(54)),
            nextCourseButton.bottomAnchor.constraint(equalTo: servingCard.bottomAnchor, constant: -DMTScale.h(34)),

            simmerSpinner.centerXAnchor.constraint(equalTo: nextCourseButton.centerXAnchor),
            simmerSpinner.centerYAnchor.constraint(equalTo: nextCourseButton.centerYAnchor)
        ])
    }

    private func configureKeyboardFlow() {
        dmtSeasonKeyboardFlow(in: courseScrollView)
        nicknamePlateField.entryField.delegate = self
        nicknamePlateField.entryField.returnKeyType = .next
        nicknamePlateField.entryField.enablesReturnKeyAutomatically = true
        bioPlateField.entryField.delegate = self
        bioPlateField.entryField.returnKeyType = .next
        bioPlateField.entryField.enablesReturnKeyAutomatically = true
        agePlateField.entryField.delegate = self
        agePlateField.entryField.returnKeyType = .done
    }

    private func configureBirthPicker() {
        birthdayWheel.datePickerMode = .date
        birthdayWheel.preferredDatePickerStyle = .wheels
        birthdayWheel.maximumDate = Calendar.current.date(byAdding: .year, value: -18, to: Date())
        birthdayWheel.minimumDate = Calendar.current.date(byAdding: .year, value: -70, to: Date())
        birthdayWheel.locale = .current

        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.items = [
            UIBarButtonItem(systemItem: .flexibleSpace),
            UIBarButtonItem(title: DMTStringCellar.shared.serve("copy.done"), style: .done, target: self, action: #selector(commitBirthWheel))
        ]

        agePlateField.entryField.inputView = birthdayWheel
        agePlateField.entryField.inputAccessoryView = toolbar
        agePlateField.entryField.tintColor = .clear
    }

    private func fetchSignUpCopy() {
        Task { [weak self] in
            guard let self else { return }
            do {
                let bundle = try await hearthService.fetchWelcomeBundle()
                await MainActor.run {
                    self.renderSignUpCopy(bundle.DMTshisignUp)
                }
            } catch {
                await MainActor.run {
                    self.dmtServeNotice(title: DMTStringCellar.shared.serve("copy.signalLostTitle"), message: error.localizedDescription)
                }
            }
        }
    }

    private func renderSignUpCopy(_ deck: DMTSignUpDeck) {
        title = navCourseTitle
        ctaCopy = deck.ctaCopy
        nicknamePlateField.renderFieldCopy(title: deck.nicknameTitle, placeholder: deck.nicknamePlaceholder)
        bioPlateField.renderFieldCopy(title: deck.bioTitle, placeholder: deck.bioPlaceholder)
        agePlateField.renderFieldCopy(title: deck.ageTitle, placeholder: deck.agePlaceholder)
        nextCourseButton.setTitle(deck.ctaCopy, for: .normal)
    }

    private func primePlaceholderAvatar() {
        let avatar = makeAvatarPlaceholder()
        facePlateButton.setBackgroundImage(avatar, for: .normal)
    }

    @objc
    private func handleAvatarPick() {
        view.endEditing(true)
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }

    @objc
    private func commitBirthWheel() {
        let components = Calendar.current.dateComponents([.month, .year], from: birthdayWheel.date)
        pickedBirthMonth = components.month ?? 1
        pickedBirthYear = components.year ?? 2000

        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        agePlateField.entryField.text = formatter.string(from: birthdayWheel.date)
        agePlateField.entryField.resignFirstResponder()
    }

    @objc
    private func handleNextCourseTap() {
        view.endEditing(true)
        let nickname = nicknamePlateField.text.trimmingCharacters(in: .whitespacesAndNewlines)
        let bio = bioPlateField.text.trimmingCharacters(in: .whitespacesAndNewlines)
        let birthLine = agePlateField.text.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !nickname.isEmpty, !bio.isEmpty, !birthLine.isEmpty else {
            dmtServeNotice(title: DMTStringCellar.shared.serve("copy.incompleteTableCardTitle"), message: DMTStringCellar.shared.serve("copy.incompleteTableCardMessage"))
            return
        }

        setSignUpLoadingState(true)

        let draft = DMTSignUpDraft(
            ticket: passTicket,
            nickname: nickname,
            bio: bio,
            birthMonth: pickedBirthMonth == 0 ? 1 : pickedBirthMonth,
            birthYear: pickedBirthYear == 0 ? 2000 : pickedBirthYear,
            birthLine: birthLine,
            avatarImage: pickedAvatarPhoto,
            verifyImage: nil
        )

        setSignUpLoadingState(false)

        let verifyController = DMTIdentityVerifyViewController(hearthService: hearthService, draft: draft, tasteLedger: tasteLedger)
        verifyController.onFinish = { [weak self] payload in
            self?.onFinish?(payload)
        }
        navigationController?.pushViewController(verifyController, animated: true)
    }

    private func setSignUpLoadingState(_ isLoading: Bool) {
        nextCourseButton.isEnabled = !isLoading
        if isLoading {
            nextCourseButton.setTitle(nil, for: .normal)
            simmerSpinner.startAnimating()
        } else {
            simmerSpinner.stopAnimating()
            nextCourseButton.setTitle(ctaCopy, for: .normal)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = (info[.editedImage] ?? info[.originalImage]) as? UIImage
        if let image {
            pickedAvatarPhoto = image
            facePlateButton.setBackgroundImage(image, for: .normal)
            avatarPlusBadge.isHidden = true
        }
        picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        let hostedField: UIView
        if textField === nicknamePlateField.entryField {
            hostedField = nicknamePlateField
        } else if textField === bioPlateField.entryField {
            hostedField = bioPlateField
        } else {
            hostedField = agePlateField
        }

        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.dmtRevealKeyboardCourse(hostedField, in: self.courseScrollView)
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === nicknamePlateField.entryField {
            bioPlateField.entryField.becomeFirstResponder()
            return false
        }

        if textField === bioPlateField.entryField {
            agePlateField.entryField.becomeFirstResponder()
            return false
        }

        view.endEditing(true)
        return false
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
