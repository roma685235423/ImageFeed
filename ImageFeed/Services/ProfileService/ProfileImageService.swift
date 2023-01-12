//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Роман Бойко on 1/8/23.
//

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
    
    private let token = OAuth2TokenStorage().bearerToken
    
    let queueProfileImage = DispatchQueue(label: "profileImage.service.queue", qos: .userInitiated)
    
    //MARK: - Singleton
    private (set) var avatarURL: String?
    
    
    //MARK: - Notification
    static let DidChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    
    //MARK: - Methods
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        
        guard let token = token else { return }
        
        let request = self.makeRequest(username: username, token: token)
        let task = session.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            guard let self = self else { return }
            self.queueProfileImage.async {
                switch result {
                case .success(let result):
                    self.profileImageUrl = result.profileImage.small
                    completion(.success(result.profileImage.small))
                case .failure(let error):
                    completion(.failure(error))
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
        
        let usernameURLString = userImagesURLString
        let url = URL(string: usernameURLString)!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func setAvatarUrlString(avatarUrl: String) {
        self.avatarURL = avatarUrl
    }
}
