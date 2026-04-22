import UIKit

final class DMTIdentityVerifyViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var onFinish: ((DMTSessionPayload) -> Void)?

    private let hearthService: DMTFeastService
    private let tasteLedger: DMTTasteProfileStore
    private var draft: DMTSignUpDraft
    private let courseScrollView = UIScrollView()
    private let platingCanvas = UIView()
    private let headerView = DMTGradientView(colors: [UIColor(red: 0.53, green: 0.14, blue: 1, alpha: 1), UIColor(red: 1, green: 0.03, blue: 0.74, alpha: 1)], startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 1, y: 1))
    private let shieldView = UIImageView(image: UIImage(systemName: "checkmark.shield.fill"))
    private let servingCard = UIView()
    private let introLabel = UILabel()
    private let previewShell = UIView()
    private let previewImageView = UIImageView()
    private let frameView = UIImageView(image: UIImage(systemName: "viewfinder"))
    private let captionLabel = UILabel()
    private let actionButton = DMTGlowButton()
    private let simmerSpinner = UIActivityIndicatorView(style: .medium)
    private var ctaCopy = DMTStringCellar.shared.serve("copy.takeSelfie")

    init(hearthService: DMTFeastService, draft: DMTSignUpDraft, tasteLedger: DMTTasteProfileStore) {
        self.hearthService = hearthService
        self.draft = draft
        self.tasteLedger = tasteLedger
        super.init(nibName: nil, bundle: nil)
        title = DMTStringCellar.shared.serve("copy.verifyIdentity")
    }

    required init?(coder: NSCoder) {
        nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = DMTPalette.paper
        composeLayout()
        fetchDeckCopy()
    }

    private func composeLayout() {
        courseScrollView.contentInsetAdjustmentBehavior = .never
        courseScrollView.translatesAutoresizingMaskIntoConstraints = false
        platingCanvas.translatesAutoresizingMaskIntoConstraints = false
        headerView.translatesAutoresizingMaskIntoConstraints = false

        shieldView.translatesAutoresizingMaskIntoConstraints = false
        shieldView.tintColor = UIColor.white.withAlphaComponent(0.95)
        shieldView.contentMode = .scaleAspectFit

        servingCard.translatesAutoresizingMaskIntoConstraints = false
        servingCard.backgroundColor = .white
        servingCard.layer.cornerRadius = DMTScale.r(28)

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

        simmerSpinner.translatesAutoresizingMaskIntoConstraints = false
        simmerSpinner.hidesWhenStopped = true
        simmerSpinner.color = .white

        view.addSubview(courseScrollView)
        courseScrollView.addSubview(platingCanvas)
        platingCanvas.addSubview(headerView)
        headerView.addSubview(shieldView)
        platingCanvas.addSubview(servingCard)
        servingCard.addSubview(introLabel)
        servingCard.addSubview(previewShell)
        previewShell.addSubview(previewImageView)
        previewShell.addSubview(frameView)
        servingCard.addSubview(captionLabel)
        servingCard.addSubview(actionButton)
        actionButton.addSubview(simmerSpinner)

        courseScrollView.dmtPinCourseEdges(to: view)
        previewImageView.dmtPinCourseEdges(to: previewShell)

        NSLayoutConstraint.activate([
            platingCanvas.topAnchor.constraint(equalTo: courseScrollView.topAnchor),
            platingCanvas.leadingAnchor.constraint(equalTo: courseScrollView.leadingAnchor),
            platingCanvas.trailingAnchor.constraint(equalTo: courseScrollView.trailingAnchor),
            platingCanvas.bottomAnchor.constraint(equalTo: courseScrollView.bottomAnchor),
            platingCanvas.widthAnchor.constraint(equalTo: courseScrollView.widthAnchor),

            headerView.topAnchor.constraint(equalTo: platingCanvas.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: platingCanvas.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: platingCanvas.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: DMTScale.h(290)),

            shieldView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            shieldView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor, constant: DMTScale.h(-6)),
            shieldView.widthAnchor.constraint(equalToConstant: DMTScale.w(112)),
            shieldView.heightAnchor.constraint(equalToConstant: DMTScale.w(112)),

            servingCard.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -DMTScale.h(28)),
            servingCard.leadingAnchor.constraint(equalTo: platingCanvas.leadingAnchor),
            servingCard.trailingAnchor.constraint(equalTo: platingCanvas.trailingAnchor),
            servingCard.bottomAnchor.constraint(equalTo: platingCanvas.bottomAnchor),

            introLabel.topAnchor.constraint(equalTo: servingCard.topAnchor, constant: DMTScale.h(24)),
            introLabel.leadingAnchor.constraint(equalTo: servingCard.leadingAnchor, constant: DMTScale.w(24)),
            introLabel.trailingAnchor.constraint(equalTo: servingCard.trailingAnchor, constant: -DMTScale.w(24)),

            previewShell.topAnchor.constraint(equalTo: introLabel.bottomAnchor, constant: DMTScale.h(18)),
            previewShell.centerXAnchor.constraint(equalTo: servingCard.centerXAnchor),
            previewShell.widthAnchor.constraint(equalToConstant: DMTScale.w(144)),
            previewShell.heightAnchor.constraint(equalToConstant: DMTScale.w(144)),

            frameView.centerXAnchor.constraint(equalTo: previewShell.centerXAnchor),
            frameView.centerYAnchor.constraint(equalTo: previewShell.centerYAnchor),
            frameView.widthAnchor.constraint(equalToConstant: DMTScale.w(88)),
            frameView.heightAnchor.constraint(equalToConstant: DMTScale.w(88)),

            captionLabel.topAnchor.constraint(equalTo: previewShell.bottomAnchor, constant: DMTScale.h(18)),
            captionLabel.leadingAnchor.constraint(equalTo: servingCard.leadingAnchor, constant: DMTScale.w(26)),
            captionLabel.trailingAnchor.constraint(equalTo: servingCard.trailingAnchor, constant: -DMTScale.w(26)),

            actionButton.topAnchor.constraint(equalTo: captionLabel.bottomAnchor, constant: DMTScale.h(28)),
            actionButton.leadingAnchor.constraint(equalTo: servingCard.leadingAnchor, constant: DMTScale.w(24)),
            actionButton.trailingAnchor.constraint(equalTo: servingCard.trailingAnchor, constant: -DMTScale.w(24)),
            actionButton.heightAnchor.constraint(equalToConstant: DMTScale.h(54)),
            actionButton.bottomAnchor.constraint(equalTo: servingCard.bottomAnchor, constant: -DMTScale.h(34)),

            simmerSpinner.centerXAnchor.constraint(equalTo: actionButton.centerXAnchor),
            simmerSpinner.centerYAnchor.constraint(equalTo: actionButton.centerYAnchor)
        ])
    }

    private func fetchDeckCopy() {
        Task { [weak self] in
            guard let self else { return }
            do {
                let bundle = try await hearthService.fetchWelcomeBundle()
                await MainActor.run {
                    self.title = bundle.DMTshiverify.DMTshititle
                    self.ctaCopy = bundle.DMTshiverify.ctaCopy
                    self.introLabel.text = bundle.DMTshiverify.intro
                    self.captionLabel.text = bundle.DMTshiverify.caption
                    self.actionButton.setTitle(bundle.DMTshiverify.ctaCopy, for: .normal)
                }
            } catch {
                await MainActor.run {
                    self.dmtServeNotice(title: DMTStringCellar.shared.serve("copy.signalLostTitle"), message: error.localizedDescription)
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
        let controller = DMTWelcomeAboardViewController(hearthService: hearthService, draft: draft, tasteLedger: tasteLedger)
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
