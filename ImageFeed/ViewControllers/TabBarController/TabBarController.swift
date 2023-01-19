//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Роман Бойко on 1/19/23.
//

import Foundation
import UIKit


final class TabBarController: UITabBarController {
    
    let profileViewController = ProfileViewController()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        let imagesListViewController = storyboard.instantiateViewController(
            withIdentifier: "ImagesListViewController"
        )
        
        profileViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "profile_active"),
            selectedImage: nil
        )
        profileViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}