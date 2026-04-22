import UIKit

extension UIViewController {
    func dmtSeasonKeyboardFlow(in scrollView: UIScrollView) {
        scrollView.keyboardDismissMode = .interactive
        scrollView.alwaysBounceVertical = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dmtCloseKeyboardCourse))
        gesture.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(gesture)
        view.keyboardLayoutGuide.followsUndockedKeyboard = true
    }

    func dmtRevealKeyboardCourse(_ hostedView: UIView, in scrollView: UIScrollView) {
        let revealRect = hostedView.convert(hostedView.bounds, to: scrollView).insetBy(dx: 0, dy: -DMTScale.h(20))
        scrollView.scrollRectToVisible(revealRect, animated: true)
    }

    @objc
    private func dmtCloseKeyboardCourse() {
        view.endEditing(true)
    }
}
