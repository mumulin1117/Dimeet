import UIKit

enum APPPREFIXBackgroundSceneInstaller {
    @discardableResult
    static func install(imageNamed: String, on view: UIView) -> UIImageView {
        let imageView = UIImageView(image: UIImage(named: imageNamed))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        view.addSubview(imageView)
        view.sendSubviewToBack(imageView)

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        return imageView
    }
}
