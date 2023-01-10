//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Роман Бойко on 12/23/22.
//

import UIKit
import ProgressHUD

class SplashViewController: UIViewController {
    
    //MARK: - Properties
    
    private let ShowAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    private let tokenStorage = OAuth2TokenStorage()
    private let oauth2Service = OAuth2Service()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    //MARK: - LifeCicle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let token = tokenStorage.bearerToken ?? "nil"
        
        if tokenStorage.bearerToken != nil && tokenStorage.token != nil {
            UIBlockingProgressHUD.show()
            DispatchQueue.main.async {
                self.fetchProfile(token: token)
            }
        } else {
            performSegue(withIdentifier: ShowAuthenticationScreenSegueIdentifier, sender: nil)
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    
    
    //MARK: - Methods
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration")}
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
}



//MARK: - Extensions

extension SplashViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowAuthenticationScreenSegueIdentifier {
            guard
                
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else {fatalError("Failed to prepare for \(ShowAuthenticationScreenSegueIdentifier)")}
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}


extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true) { [weak self] in
            DispatchQueue.main.async {
                UIBlockingProgressHUD.show()
                guard let self = self else { return }
                self.fetchOAuthToken(code)
            }
        }
    }
    
    private func fetchOAuthToken (_ code: String) {
        self.oauth2Service.fetchAuthToken(code: code) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let bearerToken):
                    self.fetchProfile(token: bearerToken)
                case .failure:
                    self.showAlertPresenter()
                    break
                }
            }
        }
    }
    
    private func fetchProfile (token: String) {
        profileService.fetchProfile(token) {[weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let profile):
                DispatchQueue.main.async {
                    self.profileService.setProfile(profile: profile)
                    UIBlockingProgressHUD.dismiss()
                    self.switchToTabBarController()
                }
                ProfileImageService.shared.fetchProfileImageURL(
                    username: self.profileService.profile?.username ?? "NIL") { result in
                        switch result {
                        case .success(let avatarURL):
                            self.profileImageService.setAvatarUrlString(avatarUrl: avatarURL)
                        case .failure:
                            self.showAlertPresenter()
                            return
                        }
                    }
                self.switchToTabBarController()
                return
            case .failure:
                self.showAlertPresenter()
                break
            }
        }
    }
    
    private func showAlertPresenter() {
        SplashViewAlertPresenter().show(in: self)
    }
}
