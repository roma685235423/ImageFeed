import Foundation
import UIKit

final class TabBarController: UITabBarController {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let profileViewController = ProfileViewController()
        let profileViewHelper = ProfileViewHelper()
        let profileViewPresenter = ProfileViewPresenter(helper: profileViewHelper)
        profileViewController.presenter = profileViewPresenter
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        guard let imagesListViewController = storyboard.instantiateViewController(
            withIdentifier: "ImagesListViewController"
        ) as? ImagesListViewController else {
            return
        }
        imagesListViewController.presenter = ImagesListPresenter(imagesListService: ImagesListService())
        
        profileViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "profile_active"),
            selectedImage: nil
        )
        profileViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
