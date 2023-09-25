import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        view.tintColor = .label

        let paddingTop: CGFloat = 10.0
        tabBar.frame = .init(
            x: tabBar.frame.origin.x,
            y: tabBar.frame.origin.y - paddingTop,
            width: tabBar.frame.width,
            height: tabBar.frame.height + paddingTop
        )
    }
}
