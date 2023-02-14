import Foundation

protocol ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func avatarURLEqualNil() -> Bool
    func profileEqualNil() -> Bool
    func fetchProfileImageURL()
    func cleanCurrentSessionContext()
    func getAvatarURL() -> URL?
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    // MARK: - Properties
    weak var view: ProfileViewControllerProtocol?
    var helper: ProfileViewHelperProtocol
    private let queue = DispatchQueue(label: "profile.vc.queue", qos: .unspecified)
    
    
    // MARK: - Methods
    func viewDidLoad() {
        view?.configureProfileDetails()
        checkTokenAndFetchProfile()
    }
    
    
    func cleanCurrentSessionContext() {
        helper.cleanCurrentSessionContext()
    }
    
    func getAvatarURL() -> URL? {
        helper.getAvatarURL()
    }
    
    func avatarURLEqualNil() -> Bool {
        helper.avatarURLEqualNil()
    }
    
    func profileEqualNil() -> Bool {
        helper.profileEqualNil()
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
    
    private func checkTokenAndFetchProfile() {
        if let token = helper.getBearerToken() {
            helper.fetchProfile(token: token) { [weak self] result in
                guard let self = self else { return }
                switch result{
                case .success(let profile):
                    self.queue.async {
                        self.helper.setProfile(profile: profile)
                        self.view?.updateProfileDetails(profile: profile)
                    }
                    self.queue.async {
                        self.fetchProfileImageURL()
                    }
                    self.view?.removeProfileGradients()
                case .failure:
                    self.view?.showDefaultAlert()
                }
            }
        }
    }
    
    init(helper: ProfileViewHelperProtocol) {
        self.helper = helper
    }
}

