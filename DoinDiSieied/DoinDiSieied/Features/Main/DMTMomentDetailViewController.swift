import UIKit

final class DMTMomentDetailViewController: UIViewController {
    private let service: DMTFeastService
    private let momentID: String
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let stackView = UIStackView()
    private let spinner = UIActivityIndicatorView(style: .large)

    init(service: DMTFeastService, momentID: String) {
        self.service = service
        self.momentID = momentID
        super.init(nibName: nil, bundle: nil)
        title = "Moment"
    }

    required init?(coder: NSCoder) {
        nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = DMTPalette.cream
        configureLayout()
        fetchDetail()
    }

    private func configureLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = DMTScale.h(18)

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

    private func fetchDetail() {
        Task { [weak self] in
            guard let self else { return }
            do {
                let detail = try await service.fetchMomentDetail(id: momentID)
                await MainActor.run {
                    self.spinner.stopAnimating()
                    self.apply(detail: detail)
                }
            } catch {
                await MainActor.run {
                    self.spinner.stopAnimating()
                    self.dmtShowNotice(title: "Moment Missing", message: error.localizedDescription)
                }
            }
        }
    }

    private func apply(detail: DMTMomentDetail) {
        title = detail.dish
        stackView.arrangedSubviews.forEach {
            stackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        stackView.addArrangedSubview(makeIntroCard(title: detail.dish, author: detail.author, story: detail.story))
        stackView.addArrangedSubview(makeTokenCard(title: "Mood Tags", entries: detail.tags))
        stackView.addArrangedSubview(makeTokenCard(title: "Pairing Ideas", entries: detail.pairings))
    }

    private func makeIntroCard(title: String, author: String, story: String) -> UIView {
        let shell = UIView()
        shell.translatesAutoresizingMaskIntoConstraints = false
        shell.backgroundColor = .white
        shell.layer.cornerRadius = DMTScale.r(24)

        let authorLabel = UILabel()
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        authorLabel.textColor = DMTPalette.sunrise
        authorLabel.text = author

        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        titleLabel.textColor = DMTPalette.ink
        titleLabel.numberOfLines = 0
        titleLabel.text = title

        let storyLabel = UILabel()
        storyLabel.translatesAutoresizingMaskIntoConstraints = false
        storyLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        storyLabel.textColor = DMTPalette.cloudInk
        storyLabel.numberOfLines = 0
        storyLabel.text = story

        shell.addSubview(authorLabel)
        shell.addSubview(titleLabel)
        shell.addSubview(storyLabel)

        NSLayoutConstraint.activate([
            authorLabel.topAnchor.constraint(equalTo: shell.topAnchor, constant: DMTScale.h(18)),
            authorLabel.leadingAnchor.constraint(equalTo: shell.leadingAnchor, constant: DMTScale.w(18)),
            authorLabel.trailingAnchor.constraint(equalTo: shell.trailingAnchor, constant: -DMTScale.w(18)),

            titleLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: DMTScale.h(8)),
            titleLabel.leadingAnchor.constraint(equalTo: shell.leadingAnchor, constant: DMTScale.w(18)),
            titleLabel.trailingAnchor.constraint(equalTo: shell.trailingAnchor, constant: -DMTScale.w(18)),

            storyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: DMTScale.h(12)),
            storyLabel.leadingAnchor.constraint(equalTo: shell.leadingAnchor, constant: DMTScale.w(18)),
            storyLabel.trailingAnchor.constraint(equalTo: shell.trailingAnchor, constant: -DMTScale.w(18)),
            storyLabel.bottomAnchor.constraint(equalTo: shell.bottomAnchor, constant: -DMTScale.h(20))
        ])

        return shell
    }

    private func makeTokenCard(title: String, entries: [String]) -> UIView {
        let shell = UIView()
        shell.translatesAutoresizingMaskIntoConstraints = false
        shell.backgroundColor = .white
        shell.layer.cornerRadius = DMTScale.r(24)

        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = DMTPalette.ink
        titleLabel.text = title

        let tokens = UIStackView()
        tokens.translatesAutoresizingMaskIntoConstraints = false
        tokens.axis = .vertical
        tokens.spacing = DMTScale.h(12)

        shell.addSubview(titleLabel)
        shell.addSubview(tokens)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: shell.topAnchor, constant: DMTScale.h(18)),
            titleLabel.leadingAnchor.constraint(equalTo: shell.leadingAnchor, constant: DMTScale.w(18)),
            titleLabel.trailingAnchor.constraint(equalTo: shell.trailingAnchor, constant: -DMTScale.w(18)),

            tokens.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: DMTScale.h(16)),
            tokens.leadingAnchor.constraint(equalTo: shell.leadingAnchor, constant: DMTScale.w(18)),
            tokens.trailingAnchor.constraint(equalTo: shell.trailingAnchor, constant: -DMTScale.w(18)),
            tokens.bottomAnchor.constraint(equalTo: shell.bottomAnchor, constant: -DMTScale.h(18))
        ])

        for entry in entries {
            let tag = DMTTagView(fillColor: DMTPalette.paper, textColor: DMTPalette.ink)
            tag.apply(text: entry)
            tokens.addArrangedSubview(tag)
        }

        return shell
    }
}
