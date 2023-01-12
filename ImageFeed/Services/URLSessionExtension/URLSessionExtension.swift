//
//  URLSessionExtension.swift
//  ImageFeed
//
//  Created by Роман Бойко on 1/9/23.
//

import Foundation


extension URLSession {
    
        //MARK: - Generic method
        func objectTask<T: Decodable> (
            for request: URLRequest,
            completion: @escaping (Result<T, Error>) -> Void
        ) -> URLSessionTask {
            
            let task = dataTask(with: request, completionHandler: { (data, response, error) in
                
                if let error = error {
                    print("\n‼️1️⃣\nError is: \(error)")
                    DispatchQueue.main.async {
                        completion(.failure(error))
                        return
                    }
                }
                DispatchQueue.main.async {
                if let response = response as? HTTPURLResponse,
                   response.statusCode < 200 || response.statusCode > 299 {
                    print("\n‼️❕\nCode is: \(response.statusCode)")
                        ("\n🟥🔔\networkError: \(NetworkError.incorrectStatusCode(code: response.statusCode))")
                        completion(.failure(NetworkError.incorrectStatusCode(code: response.statusCode)))
                        return
                    }
                }
                
                guard let data = data else {
                    print("\n‼️2️⃣\nError is: We are don't have data")
                    return  }
                
                do {
                    let decodedObject = try JSONDecoder().decode(T.self, from: data)
                    DispatchQueue.main.async {
                        print("\n‼️✅\nDecode object: \(decodedObject)")
                        completion(.success(decodedObject))
                    }
                } catch let error {
                    print("\n‼️❇️\nError is: \(error)")
                    DispatchQueue.main.async {
                        completion(.failure(NetworkError.decodeError))
                    }
                }
            })
            return task
        }
    }
