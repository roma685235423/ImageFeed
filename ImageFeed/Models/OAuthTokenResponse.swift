//
//  OAuthTokenResponse.swift
//  ImageFeed
//
//  Created by Роман Бойко on 12/19/22.
//

import Foundation


enum CodingKeys: String, CodingKey {
    case access_token, token_type, scope, created_at
}

struct OAuthTokenResponseBody: Codable {
    let access_token: String
    let token_type: String
    let scope: String
    let created_at: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        access_token = try container.decode(String.self, forKey: .access_token)
        token_type = try container.decode(String.self, forKey: .token_type)
        scope = try container.decode(String.self, forKey: .scope)
        created_at = try container.decode(String.self, forKey: .created_at)
    }
}
