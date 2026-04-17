import UIKit

final class DMTHearthTabController: UITabBarController {
    init(service: DMTFeastService, sessionStore: DMTSessionStore, profileStore: DMTTasteProfileStore) {
        super.init(nibName: nil, bundle: nil)

        let roomsController = UINavigationController(rootViewController: DMTMealRoomsViewController(service: service))
        let buzzController = UINavigationController(rootViewController: DMTBiteFeedViewController(service: service))
        let mateController = UINavigationController(rootViewController: DMTMealMateViewController(service: service))
        let nookController = UINavigationController(rootViewController: DMTTasteNookViewController(service: service, sessionStore: sessionStore, profileStore: profileStore))

        roomsController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), selectedImage: UIImage(systemName: "house.fill"))
        buzzController.tabBarItem = UITabBarItem(title: "Clip", image: UIImage(systemName: "record.circle.fill"), selectedImage: UIImage(systemName: "record.circle.fill"))
        mateController.tabBarItem = UITabBarItem(title: "Discover", image: UIImage(systemName: "heart.circle.fill"), selectedImage: UIImage(systemName: "heart.circle.fill"))
        nookController.tabBarItem = UITabBarItem(title: "Me", image: UIImage(systemName: "person.crop.circle.fill"), selectedImage: UIImage(systemName: "person.crop.circle.fill"))

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
