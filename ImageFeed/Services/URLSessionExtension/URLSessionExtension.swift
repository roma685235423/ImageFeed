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
        
        let task = self.dataTask(with: request, completionHandler: { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    //print("\n‼️❌🚨\nerror = \(error)")
                    return
                }
                if let response = response as? HTTPURLResponse,
                   response.statusCode < 200 || response.statusCode > 299 {
                    //print("\n‼️❌\nresponse = \(response)")
                    completion(.failure(NetworkError.incorrectStatusCode(code: response.statusCode)))
                    return
                }
                guard let data = data else { return }
                print("\n↔️\ndata; \(String(data: data, encoding: .utf8))")
                do {
                    let decodedObject = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decodedObject))
                    print("\n✅🟢\ndecodedObject = \(decodedObject)\nType is: \(type(of: decodedObject))\n")
                } catch {
                    completion(.failure(NetworkError.decodeError))
                    print("\n‼️❌⭕️\nNetworkError.decodeError = \(NetworkError.decodeError)")
                }
            }
        })
        return task
    }
}
