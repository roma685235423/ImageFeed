//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Роман Бойко on 12/1/22.
//

import UIKit
import Kingfisher

class ProfileViewController: UIViewController {
    
    //MARK: - UI elements
    private var avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    private let loginNameLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let profileImageService = ProfileImageService.shared
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(forName: ProfileImageService.DidChangeNotification,
                         object: nil,
                         queue: .main
            ){[weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
        self.updateAvatar()
        
        guard let profile = ProfileService.shared.profile else {
            return
        }
        self.updateProfileDetails(profile: profile)
    }
}



// MARK: - Extension
extension ProfileViewController {
    
    // This method is responsible for configure user profile avatar.
    private func configureAvatarImageView() {
        view.addSubview(self.avatarImageView)
        
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            avatarImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 76)
        ])
    }
    
    // This method is responsible for configure user name label.
    private func configureNameLabel() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        nameLabel.text = "Name"
        nameLabel.textColor = UIColor(named: "white")
        nameLabel.font = UIFont(name: "YSDisplay-Medium", size: 23.0)
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),
        ])
    }
    
    // This method is responsible for configure user login name label.
    private func configureLoginNameLabel() {
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginNameLabel)
        
        loginNameLabel.text = "@username"
        loginNameLabel.textColor = UIColor(named: "gray")
        loginNameLabel.font = UIFont.systemFont(ofSize: 13.0)
        
        NSLayoutConstraint.activate([
            loginNameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8)
        ])
    }
    
    // This method is responsible for configure user profile description label.
    private func configureDescriptionLabel() {
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        
        descriptionLabel.textColor = UIColor(named: "white")
        descriptionLabel.font = UIFont.systemFont(ofSize: 13.0)
        
        descriptionLabel.minimumScaleFactor = 0.5
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
        
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: loginNameLabel.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    // This method is responsible for configure logout button.
    private func configureLogoutButon() {
        let logoutButton: UIButton
        let logoutButtonImage = UIImage(named: "logout")
        
        guard let unwrappedImage = logoutButtonImage else { return }
        
        logoutButton = UIButton.systemButton(with: unwrappedImage, target: self, action: #selector(Self.didTapLogoutButton))
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        logoutButton.tintColor = UIColor(named: "red")
        
        NSLayoutConstraint.activate([
            logoutButton.widthAnchor.constraint(equalToConstant: 20),
            logoutButton.heightAnchor.constraint(equalToConstant: 22),
            logoutButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            logoutButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -26)
        ])
    }
    
    // This method is responsible for upload user avatar.
    private func updateAvatar() {
        DispatchQueue.main.async {
            guard
                
                let profileImageURL = ProfileImageService.shared.avatarURL,
                let url = URL(string: profileImageURL)
            else { return }
            
            let processor = RoundCornerImageProcessor(cornerRadius: 35,backgroundColor: .clear)
            
            self.avatarImageView.kf.indicatorType = .activity
            self.avatarImageView.kf.setImage(with: url,
                                        placeholder: UIImage(named: "userpick_placeholder"),
                                        options: [.processor(processor),
                                                  .cacheSerializer(FormatIndicatedCacheSerializer.png)])
        }
        
    }
    
    
    
    @objc
    private func didTapLogoutButton() {
        
    }
}




extension ProfileViewController {
    
    private func updateProfileDetails(profile: Profile) {
        
        configureAvatarImageView()
        configureNameLabel()
        configureLoginNameLabel()
        configureDescriptionLabel()
        configureLogoutButon()
        
        self.nameLabel.text = profile.name
        self.loginNameLabel.text = profile.loginName
        self.descriptionLabel.text = profile.bio
        
    }
}

