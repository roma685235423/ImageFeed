import Foundation

public protocol ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func avatarURLEqualNil() -> Bool
    func profileEqualNil() -> Bool
    func updateAvatar()
    func fetchProfileImageURL()
    func cleanCurrentSessionContext()
    func getName() -> String?
    func getLoginName() -> String?
    func getBio() -> String?
    func getAvatarURL() -> URL?
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    // MARK: - Properties
    weak var view: ProfileViewControllerProtocol?
    var helper: ProfileViewHelperProtocol
    private let queue = DispatchQueue(label: "profile.vc.queue", qos: .unspecified)
    
    
    // MARK: - Methods
    func cleanCurrentSessionContext() {
        helper.cleanCurrentSessionContext()
    }
    
    func fetchProfileImageURL() {
        helper.fetchProfileImageURL(completion: { [weak self] result in
            guard let self = self else { return }
            switch result{
            case .success:
                self.view?.updateAvatar()
            case .failure:
                self.view?.showDefaultAlert()
            }
        })
    }
    
    func getAvatarURL() -> URL? {
        helper.getAvatarURL()
    }
    
    func updateAvatar() {
        view?.updateAvatar()
    }
    
    func getName() -> String? {
        helper.getNewProfileDetails()?.name
    }
    
    func getLoginName() -> String? {
        helper.getNewProfileDetails()?.loginName
    }
    
    func getBio() -> String? {
        helper.getNewProfileDetails()?.bio
    }
    
    
    func avatarURLEqualNil() -> Bool {
        helper.avatarURLEqualNil()
    }
    
    
    func profileEqualNil() -> Bool {
        helper.profileEqualNil()
    }
    
    
    func viewDidLoad() {
        configureProfileDetails()
        checkTokenAndFetchProfile()
    }
    
    func removeProfileGradients() {
        view?.removeProfileGradients()
    }
    
    func getNewProfileDetails() -> Profile? {
        self.helper.getNewProfileDetails()
    }
    
    private func checkTokenAndFetchProfile() {
        if let token = helper.getBearerToken() {
            helper.fetchProfile(token: token) { [weak self] result in
                guard let self = self else { return }
                switch result{
                case .success(let profile):
                    self.queue.async {
                        self.helper.setProfile(profile: profile)
                        self.view?.updateProfileDetails()
                    }
                    self.queue.async {
                        self.fetchProfileImageURL()
                    }
                    self.removeProfileGradients()
                case .failure:
                    self.view?.showDefaultAlert()
                }
            }
        }
    }
    
    private func configureProfileDetails() {
        view?.configureAvatarImageView()
        view?.configureNameLabel()
        view?.configureLoginNameLabel()
        view?.configureDescriptionLabel()
        view?.configureLogoutButon()
    }
    
    init(helper: ProfileViewHelperProtocol) {
        self.helper = helper
    }
}
