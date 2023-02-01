//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Роман Бойко on 1/23/23.
//

import Foundation

fileprivate enum CodingKeys: String, CodingKey {
case id, width, height, created_at, description, liked_by_user, urls, photo
case raw, full, regular, small, thumb
}


struct PhotoResult: Decodable {
    let id: String
    let width: Int
    let height: Int
    let createdAt: String?
    let description: String?
    let isLiked: Bool
    let urls: UrlsResult
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.width = try container.decode(Int.self, forKey: .width)
        self.height = try container.decode(Int.self, forKey: .height)
        self.createdAt = try container.decode(String?.self, forKey: .created_at)
        self.description = try container.decode(String?.self, forKey: .description)
        self.isLiked = try container.decode(Bool.self, forKey: .liked_by_user)
        self.urls = try container.decode(UrlsResult.self, forKey: .urls)
    }
}


struct UrlsResult: Decodable {
    let thumbImageURL: String
    let largeImageURL: String
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.largeImageURL = try container.decode(String.self, forKey: .regular)
        self.thumbImageURL = try container.decode(String.self, forKey: .thumb)
    }
}

struct likeResult: Decodable {
    let photo: PhotoResult
    enum CodingKeys: CodingKey {
        case photo
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.photo = try container.decode(PhotoResult.self, forKey: .photo)
    }
}
