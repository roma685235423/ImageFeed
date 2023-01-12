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
    
    private let queue = DispatchQueue(label: "splash.vc.queue", qos: .unspecified)
    
    //MARK: - LifeCicle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let token = tokenStorage.bearerToken ?? "nil"
            if self.tokenStorage.bearerToken != nil && self.tokenStorage.token != nil {
                UIBlockingProgressHUD.show()
                DispatchQueue.main.async { [weak self] in
                    self?.fetchProfile(token: token)
                }
            } else {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.performSegue(withIdentifier: self.ShowAuthenticationScreenSegueIdentifier, sender: nil)
                }
            }
        }
    
    
    
    //MARK: - Methods
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration")}
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        UIBlockingProgressHUD.dismiss()
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
            guard let self = self else { return }
                self.fetchOAuthToken(code)
                UIBlockingProgressHUD.show()
            }
        }
    }
    
    private func fetchOAuthToken (_ code: String) {
        self.oauth2Service.fetchAuthToken(code: code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let bearerToken):
                DispatchQueue.main.async {
                    self.fetchProfile(token: bearerToken)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlertPresenter()
                    print("\n‼️🟥1️⃣\nErrorr is:\n\(error)\n")
                }
                break
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
                    ProfileImageService.shared.fetchProfileImageURL(
                        username: self.profileService.profile?.username ?? "NIL") { result in
                            switch result {
                            case .success(let avatarURL):
                                self.profileImageService.setAvatarUrlString(avatarUrl: avatarURL)
                            case .failure(let error):
                                print("\n‼️🟥2️⃣\nErrorr is:\n\(error)\n")
                                self.showAlertPresenter()
                                return
                            }
                        }
                    self.switchToTabBarController()
                    return
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print("\n‼️🟥3️⃣\nErrorr is:\n\(error)\n")
                    self.showAlertPresenter()
                }
                return
            }
        }
    }
    
    private func showAlertPresenter() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            SplashViewAlertPresenter().show(in: self)
            UIBlockingProgressHUD.dismiss()
            
        }
    }
}
