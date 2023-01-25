//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Роман Бойко on 1/3/23.
//

import Foundation

final class ProfileService {
    
    //MARK: - Enumerations
    private enum NetworkError: Error {
        case codeError
    }
    
    //MARK: - Properties
    fileprivate let profileInfoURLString = "https://api.unsplash.com/me"
    private let session = URLSession.shared
    private var task: URLSessionTask?
    private var lastToken: String?
    private(set) var profile: Profile?
    
    
    //MARK: - Singleton
    static let shared = ProfileService()
    
    
    
    //MARK: - Methods
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        
        assert(Thread.isMainThread)
        if lastToken == token { return }
        task?.cancel()
        lastToken = token
        
        let request = self.makeRequest(token: token)
        let task = self.session.objectTask(for: request) { [weak self]
            (result: Result<ProfileResult, Error>) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let jsonData):
                    self.profile = self.convertProfileResultToProfile(profileResult: jsonData)
                    guard let profile = self.profile else {return}
                    completion(.success(profile))
                    self.task = nil
                    return
                case .failure(let error):
                    completion(.failure(error))
                    self.lastToken = nil
                    return
                }
            }
        }
        self.task = task
        task.resume()
    }
}



//MARK: - Extensions
extension ProfileService {
    
    private func convertProfileResultToProfile(profileResult: ProfileResult) -> Profile {
        return Profile(
            username: profileResult.userName ?? "",
            name: (profileResult.firstName ?? "") + " " + (profileResult.lastName ?? ""),
            loginName: "@" + (profileResult.userName ?? ""),
            bio: profileResult.bio ?? ""
        )
    }
    
    private func makeRequest (token: String) -> URLRequest {
        
        let url = URL(string: profileInfoURLString)!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func setProfile (profile: Profile) {
        self.profile = profile
    }
}
