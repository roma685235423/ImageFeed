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

    fileprivate let profileInfoURLString = "https://api.unsplash.com/me"
    private let session = URLSession.shared
    private var task: URLSessionTask?
    private var lastToken: String?
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        
        assert(Thread.isMainThread)
        if lastToken == token { return }
        task?.cancel()
        lastToken = token
        
        let request = self.makeRequest(token: token)
        let task = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    self.lastToken = nil
                    return
                }
                if let response = response as? HTTPURLResponse,
                   response.statusCode < 200 || response.statusCode > 299 {
                    completion(.failure(NetworkError.codeError))
                    self.lastToken = nil
                    return
                }
                
                guard let data = data else { return }
                
                do {
                    let jsonData = try JSONDecoder().decode(ProfileResult.self, from: data)
                    let profile = self.convertProfileResultToProfile(profileResult: jsonData)
                    completion(.success(profile))
                    self.task = nil
                } catch let error {
                    completion(.failure(error))
                    self.lastToken = nil
                }
            }
        }
        self.task = task
        task.resume()
    }
}



extension ProfileService {
    
    func convertProfileResultToProfile(profileResult: ProfileResult) -> Profile {
        return Profile(
            username: profileResult.userName,
            name: profileResult.firstName + " " + profileResult.lastName,
            loginName: "@" + profileResult.userName,
            bio: profileResult.bio
        )
    }
    
    func makeRequest (token: String) -> URLRequest {
        
        let url = URL(string: profileInfoURLString)!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
}
