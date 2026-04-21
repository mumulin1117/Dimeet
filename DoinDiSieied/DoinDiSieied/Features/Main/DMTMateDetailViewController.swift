import UIKit

final class DMTMateDetailViewController: UIViewController {
    private let service: DMTFeastService
    private let promptID: String
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let stackView = UIStackView()
    private let spinner = UIActivityIndicatorView(style: .large)

    init(service: DMTFeastService, promptID: String) {
        self.service = service
        self.promptID = promptID
        super.init(nibName: nil, bundle: nil)
        title = "Mate Reply"
    }

    required init?(coder: NSCoder) {
        nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = DMTPalette.cream
        configureLayout()
        fetchReply()
    }

    private func configureLayout() {
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = DMTScale.h(14)

        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()

        view.addSubview(scrollView)
        view.addSubview(spinner)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)

        scrollView.dmtPinEdges(to: view)

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            stackView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: DMTScale.h(24)),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DMTScale.w(20)),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DMTScale.w(20)),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -DMTScale.h(28)),

            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func fetchReply() {
        Task { [weak self] in
            guard let self else { return }
            do {
                let reply = try await service.fetchMateReply(id: promptID)
                await MainActor.run {
                    self.spinner.stopAnimating()
                    self.apply(reply: reply)
                }
            } catch {
                await MainActor.run {
                    self.spinner.stopAnimating()
                    self.dmtShowNotice(title: "Mate Reply Missing", message: error.localizedDescription)
                }
            }
        }
    }

    private func apply(reply: DMTMateReply) {
        title = reply.title
        stackView.arrangedSubviews.forEach {
            stackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        let introCard = UIView()
        introCard.translatesAutoresizingMaskIntoConstraints = false
        introCard.backgroundColor = .white
        introCard.layer.cornerRadius = DMTScale.r(24)

        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        titleLabel.textColor = DMTPalette.ink
        titleLabel.text = reply.title

        let leadLabel = UILabel()
        leadLabel.translatesAutoresizingMaskIntoConstraints = false
        leadLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        leadLabel.textColor = DMTPalette.cloudInk
        leadLabel.numberOfLines = 0
        leadLabel.text = reply.lead

        introCard.addSubview(titleLabel)
        introCard.addSubview(leadLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: introCard.topAnchor, constant: DMTScale.h(18)),
            titleLabel.leadingAnchor.constraint(equalTo: introCard.leadingAnchor, constant: DMTScale.w(18)),
            titleLabel.trailingAnchor.constraint(equalTo: introCard.trailingAnchor, constant: -DMTScale.w(18)),

            leadLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: DMTScale.h(10)),
            leadLabel.leadingAnchor.constraint(equalTo: introCard.leadingAnchor, constant: DMTScale.w(18)),
            leadLabel.trailingAnchor.constraint(equalTo: introCard.trailingAnchor, constant: -DMTScale.w(18)),
            leadLabel.bottomAnchor.constraint(equalTo: introCard.bottomAnchor, constant: -DMTScale.h(20))
        ])

        stackView.addArrangedSubview(introCard)

        for line in reply.replies {
            let bubble = UIView()
            bubble.translatesAutoresizingMaskIntoConstraints = false
            bubble.backgroundColor = .white
            bubble.layer.cornerRadius = DMTScale.r(22)

            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            label.textColor = DMTPalette.ink
            label.numberOfLines = 0
            label.text = line

            bubble.addSubview(label)
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: bubble.topAnchor, constant: DMTScale.h(16)),
                label.leadingAnchor.constraint(equalTo: bubble.leadingAnchor, constant: DMTScale.w(16)),
                label.trailingAnchor.constraint(equalTo: bubble.trailingAnchor, constant: -DMTScale.w(16)),
                label.bottomAnchor.constraint(equalTo: bubble.bottomAnchor, constant: -DMTScale.h(16))
            ])

            stackView.addArrangedSubview(bubble)
        }
    }
}
