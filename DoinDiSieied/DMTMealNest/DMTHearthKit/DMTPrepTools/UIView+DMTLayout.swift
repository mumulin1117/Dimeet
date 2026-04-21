import UIKit

extension UIView {
    func dmtPinCourseEdges(to view: UIView, inset: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.topAnchor, constant: inset.top),
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset.left),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset.right),
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -inset.bottom)
        ])
    }
}
