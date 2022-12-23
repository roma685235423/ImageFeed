//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Роман Бойко on 12/22/22.
//

import Foundation


final class OAuth2TokenStorage {
    
    private enum Keys: String {
        case token
    }
    
    private let userDefaults = UserDefaults.standard
    
    var token: String {
        get {
            return userDefaults.string(forKey: Keys.token.rawValue) ?? ""
        }
        set {
            userDefaults.set(newValue, forKey: Keys.token.rawValue)
        }
    }
}
