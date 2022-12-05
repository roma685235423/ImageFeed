//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Роман Бойко on 12/1/22.
//

import UIKit

class ProfileViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var loginNameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    
    @IBOutlet private weak var logoutButton: UIButton!
    
    @IBAction private func DidTapLogoutButton() {
        
    }
    
}

