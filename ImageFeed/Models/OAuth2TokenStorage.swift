//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Роман Бойко on 12/22/22.
//

import Foundation

protocol OAuth2TokenStorageDelegate {
    var token: String {get set}
}

final class OAuth2TokenStorage:OAuth2TokenStorageDelegate {
    
    private enum Keys: String {
        case token
    }
    
    var token: String {
        get {
            return UserDefaults.standard.string(forKey: Keys.token.rawValue) ?? ""
        }
        set {
            return UserDefaults.standard.set(newValue, forKey: Keys.token.rawValue)
        }
    }
    
}
