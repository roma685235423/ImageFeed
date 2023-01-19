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
    
    private var splashScreenView = UIImageView()
    
    private let ShowAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    private let oauth2Service = OAuth2Service()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    private let queue = DispatchQueue(label: "splash.vc.queue", qos: .unspecified)
    let lastErroCode = Int()
    
    //MARK: - LifeCicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSplashScreenLogo()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.profileImageService.keychainWrapper.getBearerToken() != nil &&
            self.profileImageService.keychainWrapper.getAuthToken() != nil {
            
            let token = profileImageService.keychainWrapper.getBearerToken() ?? "nil"
            UIBlockingProgressHUD.show()
            self.fetchProfile(token: token)
        } else {
                let authViewController = AuthViewController()
                authViewController.delegate = self
                authViewController.modalPresentationStyle = .fullScreen
                present(authViewController, animated: false)
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
    
    
    private func configureSplashScreenLogo(){
        view.addSubview(splashScreenView)
        
        splashScreenView.translatesAutoresizingMaskIntoConstraints = false
        
        splashScreenView.image = UIImage(named: "vector")
        NSLayoutConstraint.activate([
            splashScreenView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            splashScreenView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}



//MARK: - Extensions

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
                self.profileImageService.keychainWrapper.setBearerToken(token: bearerToken)
                DispatchQueue.main.async {
                    self.fetchProfile(token: bearerToken)
                }
            case .failure:
                self.showAlert()
                return
            }
        }
    }
    
    
    private func fetchProfile (token: String) {
        profileService.fetchProfile(token) {[weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let profile):
                self.queue.sync {
                    self.profileService.setProfile(profile: profile)
                }
                self.queue.sync {
                    ProfileImageService.shared.fetchProfileImageURL(
                        username: self.profileService.profile?.username ?? "NIL") { result in
                            switch result {
                            case .success(let avatarURL):
                                DispatchQueue.main.async {
                                    self.profileImageService.setAvatarUrlString(avatarUrl: avatarURL)
                                }
                            case .failure:
                                return
                            }
                        }
                }
                self.switchToTabBarController()
                return
                
            case .failure:
                self.showAlert()
                return
            }
        }
    }
    
    func showAlert() {
        let alerModel = AlertModel(title: "Что-то пошло не так(",
                                   message: "Не удалось войти в систему",
                                   buttonText: "Ок"
        ){
            self.viewDidAppear(false)
        }
        DispatchQueue.main.async {
            let alertPresenter = AlertPresenter()
            alertPresenter.show(in: self, model: alerModel)
            UIBlockingProgressHUD.dismiss()
        }
    }
}
