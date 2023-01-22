//
//  UserResult.swift
//  ImageFeed
//
//  Created by Роман Бойко on 1/8/23.
//

import Foundation

fileprivate enum CodingKeys: String, CodingKey {
    case profile_image, small, medium, large
    
}


struct UserResult: Decodable {
    let profileImage: ProfileImages
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.profileImage = try container.decode(ProfileImages.self, forKey: .profile_image)
    }
}



struct ProfileImages: Decodable {
    
    let small: String
    let medium: String
    let large: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.small = try container.decode(String.self, forKey: .small)
        self.medium = try container.decode(String.self, forKey: .medium)
        self.large = try container.decode(String.self, forKey: .large)
    }
}
