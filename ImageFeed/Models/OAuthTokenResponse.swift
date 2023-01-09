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
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        accessToken = try container.decode(String.self, forKey: .accessToken)
        tokenType = try container.decode(String.self, forKey: .tokenType)
        scope = try container.decode(String.self, forKey: .scope)
        createdAt = try container.decode(Int.self, forKey: .createdAt)
    }
}
