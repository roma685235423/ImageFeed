//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Роман Бойко on 12/19/22.
//

import Foundation

protocol OAuth2ServiceDelegate {
    func fetchAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void)
}


class OAuth2Service: OAuth2ServiceDelegate {
    func fetchAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void){
        
        let session = URLSession()
        
    }
}
