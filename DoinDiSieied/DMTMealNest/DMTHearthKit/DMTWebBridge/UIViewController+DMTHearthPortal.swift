import UIKit

extension UIViewController {
    func dmtOpenHearth(_ route: DMTHearthPortalRoute, title: String? = nil, hidesTabBar: Bool = true) {
        let controller = DMTHearthPortalViewController(portalRoute: route, title: title)
        controller.hidesBottomBarWhenPushed = hidesTabBar
        navigationController?.pushViewController(controller, animated: true)
    }

    func dmtPresentGuestSheet(userID: String, anchor: UIView? = nil) {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Homepage", style: .default) { [weak self] _ in
            self?.dmtOpenHearth(.userHomepage(userID: userID))
        })
        sheet.addAction(UIAlertAction(title: "Chat", style: .default) { [weak self] _ in
            self?.dmtOpenHearth(.directMessage(userID: userID, videoCall: false))
        })
        sheet.addAction(UIAlertAction(title: "Video Call", style: .default) { [weak self] _ in
            self?.dmtOpenHearth(.directMessage(userID: userID, videoCall: true))
        })
        sheet.addAction(UIAlertAction(title: "Report", style: .destructive) { [weak self] _ in
            self?.dmtOpenHearth(.reportCenter)
        })
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        if let popover = sheet.popoverPresentationController, let anchor {
            popover.sourceView = anchor
            popover.sourceRect = anchor.bounds
        }

        present(sheet, animated: true)
    }
}
