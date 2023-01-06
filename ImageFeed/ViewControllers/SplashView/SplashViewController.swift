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
    
    
    //MARK: - LifeCicle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let token = tokenStorage.bearerToken ?? "nil"
        if tokenStorage.token != nil {
                self.fetchProfile(token: token)
            switchToTabBarController()
        } else {
            performSegue(withIdentifier: ShowAuthenticationScreenSegueIdentifier, sender: nil)
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
        UIBlockingProgressHUD.show()
        dismiss(animated: true) { [weak self] in
                guard let self = self else { return }
                self.fetchOAuthToken(code)
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    private func fetchOAuthToken (_ code: String) {
        oauth2Service.fetchAuthToken(code: code) { result in
                switch result {
                case .success(let token):
                    self.fetchProfile(token: token)
                case .failure:
                    UIBlockingProgressHUD.dismiss()
                    // TODO: Sprint 11 Показать ошибку
                    break
            }
        }
    }
    
    private func fetchProfile (token: String) {
        profileService.fetchProfile(token) {[weak self] result in
                guard let self = self else {return}
                switch result {
                case .success(let profile):
                    self.profileService.profile = profile
                    UIBlockingProgressHUD.dismiss()
                    self.switchToTabBarController()
                    return
                case .failure:
                    UIBlockingProgressHUD.dismiss()
                    // TODO: Sprint 11 Показать ошибку
                    break
            }
        }
    }
}

