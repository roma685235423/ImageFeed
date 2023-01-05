//
//  OAuthTokenResponse.swift
//  ImageFeed
//
//  Created by Роман Бойко on 12/19/22.
//

import Foundation


fileprivate enum CodingKeysForResponseBody: String, CodingKey {
    case access_token, token_type, scope, created_at
}

struct OAuthTokenResponseBody: Codable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeysForResponseBody.self)
        self.accessToken = try container.decode(String.self, forKey: .access_token)
        self.tokenType = try container.decode(String.self, forKey: .token_type)
        self.scope = try container.decode(String.self, forKey: .scope)
        self.createdAt = try container.decode(Int.self, forKey: .created_at)
    }
}
