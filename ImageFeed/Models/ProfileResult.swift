//
//  ProfileResult.swift
//  ImageFeed
//
//  Created by Роман Бойко on 1/3/23.
//

import Foundation

fileprivate enum CodingKeys: String, CodingKey {
    case username, first_name, last_name, bio
}


struct ProfileResult: Decodable {
    let userName: String?
    let firstName: String?
    let lastName: String?
    let bio: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userName = try container.decode(String?.self, forKey: .username)
        self.firstName = try container.decode(String?.self, forKey: .first_name)
        self.lastName = try container.decode(String?.self, forKey: .last_name)
        self.bio = try container.decode(String?.self, forKey: .bio)
    }
}

