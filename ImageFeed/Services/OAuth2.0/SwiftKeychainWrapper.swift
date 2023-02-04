//
//  SwiftKeychainWrapper.swift
//  ImageFeed
//
//  Created by Роман Бойко on 1/18/23.
//

import Foundation
import SwiftKeychainWrapper

final class KeychainAuthStorage {
    
    private let keychain = KeychainWrapper.standard
    
    func setAuthToken(token: String?){
        guard let token = token else { return }
        let isSuccess = keychain.set(token, forKey: "Auth token")
        guard isSuccess else {
            return
        }
    }
    
    func getAuthToken() -> String? {
        return keychain.string(forKey: "Auth token")
    }
    
    func setBearerToken(token: String?){
        guard let token = token else { return }
        let isSuccess = keychain.set(token, forKey: "Bearer token")
        guard isSuccess else {
            return
        }
    }
    
    func getBearerToken() -> String? {
        return keychain.string(forKey: "Bearer token")
    }
    
    func cleanTokensStorage() {
        keychain.removeObject(forKey: "Auth token")
        keychain.removeObject(forKey: "Bearer token")
    }
}
