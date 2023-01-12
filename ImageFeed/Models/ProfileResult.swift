//
//  ProfileResult.swift
//  ImageFeed
//
//  Created by Роман Бойко on 1/3/23.
//

import Foundation

enum CodingKeysForProfileResult: String, CodingKey {
    case username, first_name, last_name, bio
}

struct ProfileResult: Codable {
    let userName: String?
    let firstName: String?
    let lastName: String?
    let bio: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeysForProfileResult.self)
        userName = try container.decode(String?.self, forKey: .username)
        firstName = try container.decode(String?.self, forKey: .first_name)
        lastName = try container.decode(String?.self, forKey: .last_name)
        bio = try container.decode(String?.self, forKey: .bio)
    }
}

