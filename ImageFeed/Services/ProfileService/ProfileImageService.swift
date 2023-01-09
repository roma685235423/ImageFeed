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
    
    //MARK: - Singleton
    private (set) var avatarURL: String?
    
    
    //MARK: - Notification
    static let DidChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    
    //MARK: - Methods
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        
        assert(Thread.isMainThread)
        if profileImageUrl != nil { return }
        task?.cancel()
        guard let token = token else { return }
        
        let request = self.makeRequest(username: username, token: token)
        let task = session.dataTask(with: request) { data, response, error in
            NotificationCenter.default
                .post(name: ProfileImageService.DidChangeNotification,
                      object: self,
                      userInfo: ["URL": self.profileImageUrl as Any]
                )
            DispatchQueue.main.async {
                
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let response = response as? HTTPURLResponse,
                   response.statusCode < 200 || response.statusCode > 299 {
                    completion(.failure(NetworkError.codeError))
                    return
                }
                
                guard let data = data else { return }
                
                do {
                    let jsonData = try JSONDecoder().decode(UserResult.self, from: data)
                    let avatarURL = jsonData.profileImage.medium
                    completion(.success(avatarURL))
                    
                    print("\n✅🆒\nSUCCESS: \(avatarURL)\n")
                    self.task = nil
                } catch let error {
                    completion(.failure(error))
                }
            }
        }
        self.task = task
        task.resume()
    }
}


//MARK: - Extension
extension ProfileImageService {
    
    func makeRequest (username: String, token: String) -> URLRequest {
        
        let usernameURLString = userImagesURLString
        let url = URL(string: usernameURLString)!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        print(request)
        return request
    }
    
    func setAvatarUrlString(avatarUrl: String) {
        self.avatarURL = avatarUrl
    }
}
