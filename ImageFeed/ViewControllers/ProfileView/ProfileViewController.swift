import UIKit
import Kingfisher


protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfileViewPresenterProtocol? { get set }
    func configureProfileDetails()
    func updateAvatar()
    func showDefaultAlert()
    func removeProfileGradients()
    func updateProfileDetails(profile: Profile)
}

class ProfileViewController: UIViewController & ProfileViewControllerProtocol {
    //MARK: - Layout
    private var avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    private let loginNameLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    private var avatarImageViewGradient = CAGradientLayer()
    private var nameLabelGradient = CAGradientLayer()
    private var loginNameLabelGradient = CAGradientLayer()
    private var descriptionLabelGradient = CAGradientLayer()
    
    var presenter: ProfileViewPresenterProtocol?
    
    // MARK: - Life Cycle
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        presenter?.view = self
        presenter?.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.backgroundColor = UIColor(named: "black")
        configureProfileImageGradient()
        configureProfileLabelsGradients()
    }
}


// MARK: - Extensions
extension ProfileViewController {
    
    func configureProfileImageGradient() {
        guard let presenter = presenter else { return }
        if presenter.avatarURLEqualNil() {
            avatarImageView.configureGragient(
                gradient: avatarImageViewGradient,
                cornerRadius: 35,
                size: CGSize(width: 70, height: 70),
                position: .center)
        }
    }
    
    func configureProfileLabelsGradients() {
        guard let presenter = presenter else { return }
        if presenter.profileEqualNil() {
            self.nameLabel.configureGragient(
                gradient: self.nameLabelGradient,
                cornerRadius: 9,
                size: CGSize(width: 223, height: 18),
                position: .bottom
            )
            self.loginNameLabel.configureGragient(
                gradient: self.loginNameLabelGradient,
                cornerRadius: 9,
                size: CGSize(width: 89, height: 18),
                position: .center
            )
            self.descriptionLabel.configureGragient(
                gradient: self.descriptionLabelGradient,
                cornerRadius: 9,
                size: CGSize(width: 67, height: 18),
                position: .top
            )
        }
    }
    
    // This method is responsible for upload user avatar.
    func updateAvatar() {
        DispatchQueue.main.async {
            guard let url = self.presenter?.getAvatarURL() else { return }
            self.avatarImageView.configureGragient(
                gradient: self.avatarImageViewGradient,
                cornerRadius: 35,
                size: self.avatarImageView.frame.size,
                position: .top
            )
            let processor = RoundCornerImageProcessor(cornerRadius: 35,backgroundColor: .clear)
            self.avatarImageView.kf.setImage(with: url,
                                             options: [.processor(processor),
                                                       .cacheSerializer(FormatIndicatedCacheSerializer.png)],
                                             completionHandler: { [weak self] result in
                guard let self = self else { return }
                switch result{
                case .success:
                    self.avatarImageView.removeGradient(gradient: self.avatarImageViewGradient)
                case .failure:
                    self.avatarImageView.image = UIImage(named: "userpick_placeholder")
                    self.avatarImageView.removeGradient(gradient: self.avatarImageViewGradient)
                }
            }
            )
        }
    }
    
    func updateProfileDetails(profile: Profile) {
        DispatchQueue.main.async {
            self.nameLabel.text = profile.name
            self.loginNameLabel.text = profile.loginName
            self.descriptionLabel.text = profile.bio
        }
    }
    
    func showDefaultAlert() {
        self.showDefaultAlertPresenter()
    }
    
    func removeProfileGradients() {
        descriptionLabel.removeGradient(gradient: descriptionLabelGradient)
        nameLabel.removeGradient(gradient: nameLabelGradient)
        loginNameLabel.removeGradient(gradient: loginNameLabelGradient)
    }
    func configureProfileDetails() {
        configureAvatarImageView()
        configureNameLabel()
        configureLoginNameLabel()
        configureDescriptionLabel()
        configureLogoutButon()
    }
}



extension ProfileViewController {
    // This method is responsible for configure user profile avatar.
    private func configureAvatarImageView() {
        view.addSubview(self.avatarImageView)
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.image = UIImage(named: "userpick_placeholder")
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
        nameLabel.text = "-"
        nameLabel.textColor = UIColor(named: "white")
        nameLabel.font = UIFont(name: "YSDisplay-Medium", size: 23.0)
        nameLabel.accessibilityIdentifier = "Name Lastname"
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),
        ])
    }
    
    // This method is responsible for configure user login name label.
    private func configureLoginNameLabel() {
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginNameLabel)
        loginNameLabel.text = "-"
        loginNameLabel.textColor = UIColor(named: "gray")
        loginNameLabel.font = UIFont.systemFont(ofSize: 13.0)
        loginNameLabel.accessibilityIdentifier = "@username"
        NSLayoutConstraint.activate([
            loginNameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8)
        ])
    }
    
    // This method is responsible for configure user profile description label.
    private func configureDescriptionLabel() {
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        descriptionLabel.text = "-"
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
        logoutButton.accessibilityIdentifier = "logout button"
        NSLayoutConstraint.activate([
            logoutButton.widthAnchor.constraint(equalToConstant: 20),
            logoutButton.heightAnchor.constraint(equalToConstant: 22),
            logoutButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            logoutButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -26)
        ])
    }
    
    
    @objc
    private func didTapLogoutButton() {
        let alert = UIAlertController(
            title: "Пока, пока!",
            message: "Уверены, что хотите выйти?",
            preferredStyle: .alert
        )
        let noAction = UIAlertAction(title: "Нет", style: .cancel)
        let yesAction = UIAlertAction(title: "Да", style: .default){[weak self] _ in
            guard let self = self else { return }
            self.cleanCurrentSessionContext()
            guard let window = UIApplication.shared.windows.first else {fatalError("Impossible to create window")}
            window.rootViewController = SplashViewController()
            window.makeKeyAndVisible()
        }
        alert.addAction(noAction)
        alert.addAction(yesAction)
        alert.restorationIdentifier = "Bye bye!"
        present(alert, animated: true)
    }
    
    
    private func cleanCurrentSessionContext() {
        WebViewViewController.clean()
        presenter?.cleanCurrentSessionContext()
    }
}
