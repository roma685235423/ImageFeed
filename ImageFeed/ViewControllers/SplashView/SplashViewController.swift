import UIKit

class SplashViewController: UIViewController {
    
    //MARK: - Properties
    private let splashScreenView = UIImageView()
    private let oauth2Service = OAuth2Service()
    private let profileImageService = ProfileImageService.shared
    
    
    //MARK: - Life Cicle
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
        bearerTokenAvailabilityCheck()
    }
    
    
    //MARK: - Methods
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration")}
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
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
    
    private func bearerTokenAvailabilityCheck() {
        if profileImageService.keychainWrapper.getBearerToken() != nil{
            self.switchToTabBarController()
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            guard let authViewController = storyboard.instantiateViewController(
                withIdentifier: "AuthViewControllerStoryboard"
            ) as? AuthViewController else {
                return
            }
            authViewController.delegate = self
            authViewController.modalPresentationStyle = .overFullScreen
            present(authViewController, animated: false)
        }
    }
    
    func showAlert(error: String) {
        let alerModel = AlertModel(
            title: "Что-то пошло не так(",
            message: "Не удалось войти в систему\n\(error)",
            buttonText: "Ок"
        ){
            self.bearerTokenAvailabilityCheck()
        }
        DispatchQueue.main.async {
            self.showCustomAlertPresenter(model: alerModel) 
            UIBlockingProgressHUD.dismiss()
        }
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
        UIBlockingProgressHUD.show()
        self.oauth2Service.fetchAuthToken(code: code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let bearerToken):
                DispatchQueue.main.async {
                    self.profileImageService.keychainWrapper.setBearerToken(token: bearerToken)
                    self.switchToTabBarController()
                }
            case .failure(let error):
                self.showAlert(error: error.localizedDescription)
                return
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
}
