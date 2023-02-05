import Foundation

final class ProfileImageService {
    
    //MARK: - Enumerations
    
    private enum NetworkError: Error {
        case codeError
    }
    
    //MARK: - Properties
    
    private let userImagesURLString  = "https://api.unsplash.com/me"
    static let shared = ProfileImageService()
    private var profileImageUrl: String? = nil
    private let session = URLSession.shared
    private var task: URLSessionTask?
    var keychainWrapper = KeychainAuthStorage()
    let queueProfileImage = DispatchQueue(label: "profileImage.service.queue", qos: .userInitiated)
    
    private (set) var avatarURL: String?
    
    
    //MARK: - Notification
    
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    
    //MARK: - Methods
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        
        guard let token = keychainWrapper.getBearerToken() else { return }
        let request = self.makeRequest(username: username, token: token)
        let task = session.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            guard let self = self else { return }
            NotificationCenter.default.post(
                name: ProfileImageService.didChangeNotification,
                object: self,
                userInfo: ["URL": self.profileImageUrl ?? ""]
            )
            self.queueProfileImage.async {
                switch result {
                case .success(let result):
                    DispatchQueue.main.async {
                        self.profileImageUrl = result.profileImage.medium
                        completion(.success(result.profileImage.medium))
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                    return
                }
            }
        }
        task.resume()
    }
}


//MARK: - Extension

extension ProfileImageService {
    private func makeRequest (username: String, token: String) -> URLRequest {
        let url = URL(string: self.userImagesURLString)!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    
    func setAvatarUrlString(avatarUrl: String) {
        self.avatarURL = avatarUrl
    }
}
