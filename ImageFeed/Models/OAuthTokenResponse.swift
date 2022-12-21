//
//  OAuthTokenResponse.swift
//  ImageFeed
//
//  Created by Роман Бойко on 12/19/22.
//

import Foundation


enum CodingCase: String, CodingKey {
    case accessToken, typeOfToken, scope, createdAt
}

struct OAuthTokenResponseBody: Codable {
    let accessToken: String
    let typeOfToken: String
    let scope: String
    let createdAt: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        accessToken = try container.decode(String.self, forKey: .accessToken)
        typeOfToken = try container.decode(String.self, forKey: .typeOfToken)
        scope = try container.decode(String.self, forKey: .scope)
        createdAt = try container.decode(String.self, forKey: .createdAt)
    }
}
