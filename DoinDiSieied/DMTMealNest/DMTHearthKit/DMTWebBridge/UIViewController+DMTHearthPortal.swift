import UIKit

extension UIViewController {
    func dmtOpenPortal(_ route: DMTHearthPortalRoute, title: String? = nil, hidesTabBar: Bool = true) {
        let controller = DMTHearthPortalViewController(route: route, title: title)
        controller.hidesBottomBarWhenPushed = hidesTabBar
        navigationController?.pushViewController(controller, animated: true)
    }

    func dmtPresentProfileSheet(userID: String, anchor: UIView? = nil) {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Homepage", style: .default) { [weak self] _ in
            self?.dmtOpenPortal(.userHomepage(userID: userID))
        })
        sheet.addAction(UIAlertAction(title: "Chat", style: .default) { [weak self] _ in
            self?.dmtOpenPortal(.directMessage(userID: userID, videoCall: false))
        })
        sheet.addAction(UIAlertAction(title: "Video Call", style: .default) { [weak self] _ in
            self?.dmtOpenPortal(.directMessage(userID: userID, videoCall: true))
        })
        sheet.addAction(UIAlertAction(title: "Report", style: .destructive) { [weak self] _ in
            self?.dmtOpenPortal(.reportCenter)
        })
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        if let popover = sheet.popoverPresentationController, let anchor {
            popover.sourceView = anchor
            popover.sourceRect = anchor.bounds
        }

        present(sheet, animated: true)
    }
}
