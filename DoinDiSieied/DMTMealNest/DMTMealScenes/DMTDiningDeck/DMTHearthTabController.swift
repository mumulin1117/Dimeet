import UIKit

final class DMTHearthTabController: UITabBarController {
    init(hearthService: DMTFeastService, seatSession: DMTSessionStore, tasteLedger: DMTTasteProfileStore) {
        super.init(nibName: nil, bundle: nil)

        let roomsController = UINavigationController(rootViewController:DMTMealRoomsViewController(hearthService: hearthService))
        let buzzController = UINavigationController(rootViewController: DMTBiteFeedViewController(hearthService: hearthService))
        let mateController = UINavigationController(rootViewController: DMTMealMateViewController(hearthService: hearthService))
        let nookController = UINavigationController(rootViewController: DMTTasteNookViewController(hearthService: hearthService, seatSession: seatSession, tasteLedger: tasteLedger))

        roomsController.tabBarItem = UITabBarItem(title: "", image: UIImage.dmtMealAsset(named: DMTPlateStamp.tabRooms)?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage.dmtMealAsset(named: DMTPlateStamp.tabRoomsSelected)?.withRenderingMode(.alwaysOriginal))
        buzzController.tabBarItem = UITabBarItem(title: "", image: UIImage.dmtMealAsset(named: DMTPlateStamp.tabBuzz)?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage.dmtMealAsset(named: DMTPlateStamp.tabBuzzSelected)?.withRenderingMode(.alwaysOriginal))
        mateController.tabBarItem = UITabBarItem(title: "", image: UIImage.dmtMealAsset(named: DMTPlateStamp.tabMate)?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage.dmtMealAsset(named: DMTPlateStamp.tabMateSelected)?.withRenderingMode(.alwaysOriginal))
        nookController.tabBarItem = UITabBarItem(title: "", image: UIImage.dmtMealAsset(named: DMTPlateStamp.tabNook)?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage.dmtMealAsset(named: DMTPlateStamp.tabNookSelected)?.withRenderingMode(.alwaysOriginal))

        viewControllers = [roomsController, buzzController, mateController, nookController]
        configureTabBar()
    }

    required init?(coder: NSCoder) {
        nil
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabBar.layer.cornerRadius = DMTScale.r(22)
        tabBar.layer.masksToBounds = true
    }

    private func configureTabBar() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 0.08, green: 0.08, blue: 0.09, alpha: 1)
        appearance.shadowColor = .clear

        let itemAppearance = appearance.stackedLayoutAppearance
        itemAppearance.normal.iconColor = UIColor(red: 0.68, green: 0.53, blue: 0.88, alpha: 1)
        itemAppearance.selected.iconColor = UIColor.black
        itemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]
        itemAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.clear]
        itemAppearance.normal.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 20)
        itemAppearance.selected.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 20)

        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.itemWidth = DMTScale.w(66)
        tabBar.itemPositioning = .centered
        tabBar.selectionIndicatorImage = selectionIndicatorImage()
        tabBar.tintColor = UIColor.black
        tabBar.unselectedItemTintColor = UIColor(red: 0.68, green: 0.53, blue: 0.88, alpha: 1)
    }

    private func selectionIndicatorImage() -> UIImage? {
        let indicatorSize = CGSize(width: DMTScale.w(56), height: DMTScale.h(40))
        let renderer = UIGraphicsImageRenderer(size: indicatorSize)
        return renderer.image { context in
            let rect = CGRect(origin: .zero, size: indicatorSize)
            UIColor(red: 1, green: 0.91, blue: 0.19, alpha: 1).setFill()
            UIBezierPath(roundedRect: rect, cornerRadius: indicatorSize.height / 2).fill()
            UIColor(red: 1, green: 0.91, blue: 0.19, alpha: 1).setStroke()
            UIBezierPath(roundedRect: rect.insetBy(dx: 1, dy: 1), cornerRadius: indicatorSize.height / 2).stroke()
        }.resizableImage(withCapInsets: UIEdgeInsets(top: indicatorSize.height / 2, left: indicatorSize.width / 2, bottom: indicatorSize.height / 2, right: indicatorSize.width / 2))
    }
}
