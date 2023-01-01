//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Роман Бойко on 12/19/22.
//

import Foundation


class OAuth2Service {
    
    //MARK: - Enumerations
    private enum NetworkError: Error {
        case codeError
    }
    
    
    //MARK: - Properties
    let unsplashAuthorizePostURLString = "https://unsplash.com/oauth/token"
    
    
    //MARK: - Methods
    func fetchAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void){
        var urlComponents = URLComponents(string: self.unsplashAuthorizePostURLString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: constants.AccessKey),
            URLQueryItem(name: "client_secret", value: constants.SecretKey),
            URLQueryItem(name: "redirect_uri", value: constants.RedirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let task  = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let response = response as? HTTPURLResponse,
                   response.statusCode < 200 || response.statusCode >= 300 {
                    completion(.failure(NetworkError.codeError))
                    return
                }
                
                guard let data = data else { return }
                
                do {
                    let jsonData = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                    completion(.success(jsonData.accessToken))
                } catch let error {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}

