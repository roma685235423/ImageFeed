import Foundation

protocol ProfileViewHelperProtocol {
    func fetchProfileImageURL(completion: @escaping (Result <String, Error>) -> Void)
    func fetchProfile (token: String, completion: @escaping (Result<Profile, Error>) -> Void)
    func avatarURLEqualNil() -> Bool
    func profileEqualNil() -> Bool
    func getBearerToken() -> String?
    func setProfile(profile: Profile)
    func cleanCurrentSessionContext()
    func getNewProfileDetails() -> Profile?
    func getAvatarURL() -> URL?
}

class ProfileViewHelper: ProfileViewHelperProtocol {
    func setProfile(profile: Profile) {
        profileService.setProfile(profile: profile)
    }
    
    // MARK: - Properties
    let profileImageService = ProfileImageService.shared
    var profileImageServiceObserver: NSObjectProtocol?
    let imagesListViewController = ImagesListViewController.shared
    let profileService = ProfileService.shared
    
    // MARK: - Methods
    func fetchProfile (token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        profileService.fetchProfile(token) { result in
            switch result {
            case .success(let profile):
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    func fetchProfileImageURL(completion: @escaping (Result <String, Error>) -> Void) {
        ProfileImageService.shared.fetchProfileImageURL(
            username: self.profileService.profile?.username ?? "NIL") {[weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let avatarURL):
                    self.profileImageService.setAvatarUrlString(avatarUrl: avatarURL)
                    completion(.success(avatarURL))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func getAvatarURL() -> URL? {
        if let profileImageURL = profileImageService.avatarURL {
            return URL(string: profileImageURL)
        }
        return nil
    }
    
    func avatarURLEqualNil() -> Bool {
        profileImageService.avatarURL == nil
    }
    
    func profileEqualNil() -> Bool {
        profileService.profile == nil
    }
    
    func getBearerToken() -> String? {
        profileImageService.keychainWrapper.getBearerToken()
    }
    
    func getNewProfileDetails() -> Profile? {
        profileService.getProfile()
    }
    
    func cleanCurrentSessionContext() {
        profileImageService.keychainWrapper.cleanTokensStorage()
        imagesListViewController.imagesListService.cleanPhotos()
        imagesListViewController.cleanPhotos()
        profileService.cleanProfile()
        profileImageService.cleanAvatarUrl()
    }
}
