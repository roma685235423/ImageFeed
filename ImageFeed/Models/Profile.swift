//
//  Profile.swift
//  ImageFeed
//
//  Created by Роман Бойко on 1/3/23.
//

import Foundation

struct Profile {
    let username: String
    let name: String
    let loginName: String
    let bio: String
    
    init(username: String, name: String, loginName: String, bio: String) {
        self.username = username
        self.name = name
        self.loginName = loginName
        self.bio = bio
    }
}