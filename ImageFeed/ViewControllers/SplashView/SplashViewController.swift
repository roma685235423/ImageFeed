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
    
    private let splashScreenView = UIImageView()
    private let oauth2Service = OAuth2Service()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    private let queue = DispatchQueue(label: "splash.vc.queue", qos: .unspecified)
    
    //MARK: - LifeCicle
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        configureSplashScreenLogo()
        view.backgroundColor = UIColor(named: "black")
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if  profileImageService.keychainWrapper.getBearerToken() != nil &&
                profileImageService.keychainWrapper.getAuthToken() != nil
        {
            let token = profileImageService.keychainWrapper.getBearerToken()!
            print("\n‼️4️⃣")
            UIBlockingProgressHUD.show()
            self.fetchProfile(token: token)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            guard let authViewController = storyboard.instantiateViewController(
                withIdentifier: "AuthViewControllerStoryboard"
            ) as? AuthViewController else {
                return
            }
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
        window.rootViewController = tabBarController
        DispatchQueue.main.async {
            print("\n5️⃣‼️")
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    
    private func configureSplashScreenLogo(){
        view.addSubview(splashScreenView)
        
        splashScreenView.translatesAutoresizingMaskIntoConstraints = false
        
        splashScreenView.image = UIImage(named: "vector")
        NSLayoutConstraint.activate([
            splashScreenView.centerXAnchor.constraint(equalTo: splashScreenView.superview!.centerXAnchor),
            splashScreenView.centerYAnchor.constraint(equalTo: splashScreenView.superview!.centerYAnchor)
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
            }
        }
    }
    
    
    private func fetchOAuthToken (_ code: String) {
        self.oauth2Service.fetchAuthToken(code: code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let bearerToken):
                DispatchQueue.main.async {
                    self.profileImageService.keychainWrapper.setBearerToken(token: bearerToken)
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
