import UIKit

final class DMTRoomDetailViewController: UIViewController {
    private let service: DMTFeastService
    private let roomID: String
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let stackView = UIStackView()
    private let spinner = UIActivityIndicatorView(style: .large)

    init(service: DMTFeastService, roomID: String) {
        self.service = service
        self.roomID = roomID
        super.init(nibName: nil, bundle: nil)
        title = "Room"
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
                let detail = try await service.fetchRoomDetail(id: roomID)
                await MainActor.run {
                    self.spinner.stopAnimating()
                    self.apply(detail: detail)
                }
            } catch {
                await MainActor.run {
                    self.spinner.stopAnimating()
                    self.dmtShowNotice(title: "Room Missing", message: error.localizedDescription)
                }
            }
        }
    }

    private func apply(detail: DMTRoomDetail) {
        title = detail.title
        stackView.arrangedSubviews.forEach {
            stackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        stackView.addArrangedSubview(makeCard(title: detail.title, lines: [detail.hostLine, detail.summary]))
        stackView.addArrangedSubview(makeTokenCard(title: "Current Plates", entries: detail.currentPlates))
        stackView.addArrangedSubview(makeTokenCard(title: "Table Prompts", entries: detail.tablePrompts))
    }

    private func makeCard(title: String, lines: [String]) -> UIView {
        let shell = UIView()
        shell.translatesAutoresizingMaskIntoConstraints = false
        shell.backgroundColor = .white
        shell.layer.cornerRadius = DMTScale.r(24)

        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = DMTPalette.ink
        titleLabel.numberOfLines = 0
        titleLabel.text = title

        shell.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: shell.topAnchor, constant: DMTScale.h(20)),
            titleLabel.leadingAnchor.constraint(equalTo: shell.leadingAnchor, constant: DMTScale.w(18)),
            titleLabel.trailingAnchor.constraint(equalTo: shell.trailingAnchor, constant: -DMTScale.w(18))
        ])

        var previous = titleLabel
        for line in lines {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            label.textColor = DMTPalette.cloudInk
            label.numberOfLines = 0
            label.text = line
            shell.addSubview(label)

            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: DMTScale.h(12)),
                label.leadingAnchor.constraint(equalTo: shell.leadingAnchor, constant: DMTScale.w(18)),
                label.trailingAnchor.constraint(equalTo: shell.trailingAnchor, constant: -DMTScale.w(18))
            ])

            previous = label
        }

        NSLayoutConstraint.activate([
            previous.bottomAnchor.constraint(equalTo: shell.bottomAnchor, constant: -DMTScale.h(20))
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
