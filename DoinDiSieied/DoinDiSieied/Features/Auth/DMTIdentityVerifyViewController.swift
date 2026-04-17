import UIKit

final class DMTIdentityVerifyViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var onFinish: ((DMTSessionPayload) -> Void)?

    private let service: DMTFeastService
    private let profileStore: DMTTasteProfileStore
    private var draft: DMTSignUpDraft
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let headerView = DMTGradientView(colors: [UIColor(red: 0.53, green: 0.14, blue: 1, alpha: 1), UIColor(red: 1, green: 0.03, blue: 0.74, alpha: 1)], startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 1, y: 1))
    private let shieldView = UIImageView(image: UIImage(systemName: "checkmark.shield.fill"))
    private let cardView = UIView()
    private let introLabel = UILabel()
    private let previewShell = UIView()
    private let previewImageView = UIImageView()
    private let frameView = UIImageView(image: UIImage(systemName: "viewfinder"))
    private let captionLabel = UILabel()
    private let actionButton = DMTGlowButton()
    private let spinner = UIActivityIndicatorView(style: .medium)
    private var buttonTitle = "Take a Selfie"

    init(service: DMTFeastService, draft: DMTSignUpDraft, profileStore: DMTTasteProfileStore) {
        self.service = service
        self.draft = draft
        self.profileStore = profileStore
        super.init(nibName: nil, bundle: nil)
        title = "Verify Your Identity"
    }

    required init?(coder: NSCoder) {
        nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = DMTPalette.paper
        configureLayout()
        loadDeck()
    }

    private func configureLayout() {
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        headerView.translatesAutoresizingMaskIntoConstraints = false

        shieldView.translatesAutoresizingMaskIntoConstraints = false
        shieldView.tintColor = UIColor.white.withAlphaComponent(0.95)
        shieldView.contentMode = .scaleAspectFit

        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = DMTScale.r(28)

        introLabel.translatesAutoresizingMaskIntoConstraints = false
        introLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        introLabel.textColor = DMTPalette.cloudInk
        introLabel.numberOfLines = 0
        introLabel.textAlignment = .center

        previewShell.translatesAutoresizingMaskIntoConstraints = false
        previewShell.backgroundColor = DMTPalette.paper
        previewShell.layer.cornerRadius = DMTScale.r(22)
        previewShell.clipsToBounds = true

        previewImageView.translatesAutoresizingMaskIntoConstraints = false
        previewImageView.contentMode = .scaleAspectFill
        previewImageView.image = makeVerifyPlaceholder()

        frameView.translatesAutoresizingMaskIntoConstraints = false
        frameView.tintColor = DMTPalette.cloudInk.withAlphaComponent(0.65)
        frameView.contentMode = .scaleAspectFit

        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        captionLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        captionLabel.textColor = DMTPalette.cloudInk
        captionLabel.numberOfLines = 0
        captionLabel.textAlignment = .center

        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.addTarget(self, action: #selector(handleSelfie), for: .touchUpInside)

        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        spinner.color = .white

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(headerView)
        headerView.addSubview(shieldView)
        contentView.addSubview(cardView)
        cardView.addSubview(introLabel)
        cardView.addSubview(previewShell)
        previewShell.addSubview(previewImageView)
        previewShell.addSubview(frameView)
        cardView.addSubview(captionLabel)
        cardView.addSubview(actionButton)
        actionButton.addSubview(spinner)

        scrollView.dmtPinEdges(to: view)
        previewImageView.dmtPinEdges(to: previewShell)

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            headerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: DMTScale.h(290)),

            shieldView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            shieldView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor, constant: DMTScale.h(-6)),
            shieldView.widthAnchor.constraint(equalToConstant: DMTScale.w(112)),
            shieldView.heightAnchor.constraint(equalToConstant: DMTScale.w(112)),

            cardView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -DMTScale.h(28)),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            introLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: DMTScale.h(24)),
            introLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: DMTScale.w(24)),
            introLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -DMTScale.w(24)),

            previewShell.topAnchor.constraint(equalTo: introLabel.bottomAnchor, constant: DMTScale.h(18)),
            previewShell.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            previewShell.widthAnchor.constraint(equalToConstant: DMTScale.w(144)),
            previewShell.heightAnchor.constraint(equalToConstant: DMTScale.w(144)),

            frameView.centerXAnchor.constraint(equalTo: previewShell.centerXAnchor),
            frameView.centerYAnchor.constraint(equalTo: previewShell.centerYAnchor),
            frameView.widthAnchor.constraint(equalToConstant: DMTScale.w(88)),
            frameView.heightAnchor.constraint(equalToConstant: DMTScale.w(88)),

            captionLabel.topAnchor.constraint(equalTo: previewShell.bottomAnchor, constant: DMTScale.h(18)),
            captionLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: DMTScale.w(26)),
            captionLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -DMTScale.w(26)),

            actionButton.topAnchor.constraint(equalTo: captionLabel.bottomAnchor, constant: DMTScale.h(28)),
            actionButton.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: DMTScale.w(24)),
            actionButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -DMTScale.w(24)),
            actionButton.heightAnchor.constraint(equalToConstant: DMTScale.h(54)),
            actionButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -DMTScale.h(34)),

            spinner.centerXAnchor.constraint(equalTo: actionButton.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: actionButton.centerYAnchor)
        ])
    }

    private func loadDeck() {
        Task { [weak self] in
            guard let self else { return }
            do {
                let bundle = try await service.fetchAuthBundle()
                await MainActor.run {
                    self.title = bundle.verify.title
                    self.buttonTitle = bundle.verify.buttonTitle
                    self.introLabel.text = bundle.verify.intro
                    self.captionLabel.text = bundle.verify.caption
                    self.actionButton.setTitle(bundle.verify.buttonTitle, for: .normal)
                }
            } catch {
                await MainActor.run {
                    self.dmtShowNotice(title: "Signal Lost", message: error.localizedDescription)
                }
            }
        }
    }

    @objc
    private func handleSelfie() {
        let picker = UIImagePickerController()
        picker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
            picker.cameraDevice = .front
        } else {
            picker.sourceType = .photoLibrary
        }
        present(picker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = (info[.editedImage] ?? info[.originalImage]) as? UIImage ?? makeVerifyPlaceholder()
        draft.verifyImage = image
        previewImageView.image = image
        frameView.isHidden = true
        picker.dismiss(animated: true) { [weak self] in
            self?.showEntryController()
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    private func showEntryController() {
        let controller = DMTWelcomeAboardViewController(service: service, draft: draft, profileStore: profileStore)
        controller.onFinish = { [weak self] payload in
            self?.onFinish?(payload)
        }
        navigationController?.pushViewController(controller, animated: true)
    }

    private func makeVerifyPlaceholder() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 240, height: 240))
        return renderer.image { context in
            DMTPalette.paper.setFill()
            context.cgContext.fill(CGRect(x: 0, y: 0, width: 240, height: 240))
            let symbol = UIImage(systemName: "person.crop.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 90, weight: .ultraLight))?
                .withTintColor(DMTPalette.cloudInk.withAlphaComponent(0.72), renderingMode: .alwaysOriginal)
            symbol?.draw(in: CGRect(x: 75, y: 75, width: 90, height: 90))
        }
    }
}
