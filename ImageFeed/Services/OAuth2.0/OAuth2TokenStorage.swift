//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Роман Бойко on 12/22/22.
//

import Foundation


final class OAuth2TokenStorage {
    
    private enum CodingKeys: String, CodingKey {
        case token, bearerToken
    }
    
    private let userDefaults = UserDefaults.standard
    
    var token: String? {
        get {
            return userDefaults.string(forKey: CodingKeys.token.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: CodingKeys.token.rawValue)
        }
    }
    var bearerToken: String? {
        get {
            return userDefaults.string(forKey: CodingKeys.bearerToken.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: CodingKeys.bearerToken.rawValue)
        }
    }
}
