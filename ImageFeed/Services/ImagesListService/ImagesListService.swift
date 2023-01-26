//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Роман Бойко on 1/23/23.
//

import Foundation

final class ImagesListService {
    
    // MARK: - Properties
    
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    
    private let keychain = ProfileImageService.shared.keychainWrapper
    
    private let randomPhotoURLString  = "https://api.unsplash.com/photos"
    private let session = URLSession.shared
    private var task: URLSessionTask?
    
    static let shared = ImagesListService()
    
    
    //MARK: - Notification
    
    static let didChangeNontification = Notification.Name("ImagesListServiceDidChange")
    
    
    //MARK: - Methods
    
    func fetchPhotosNextPage() {
        
        assert(Thread.isMainThread)
        if task != nil { return }
        guard let token = keychain.getBearerToken() else { return }
        
        let nextPage = self.lastLoadedPage == nil
        ? 1
        : self.lastLoadedPage! + 1
        
        
        let request = makeRequest(token: token, nextPage: nextPage)
        let task = self.session.objectTask(for: request) { [weak self]
            (result: Result<[PhotoResult], Error>) in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let result):
                    self.lastLoadedPage = nextPage
                    self.addNewPhotosToArray(photoResults: result)
                    self.task = nil
                case .failure(let error):
                    print("‼️\n\(error)\n❌")
                    return
                }
            }
        }
        self.task = task
        task.resume()
    }
}


//MARK: - Extension

extension ImagesListService {
    
    private func makeRequest(token: String, nextPage: Int) -> URLRequest {
        
        var urlComponents = URLComponents(string: self.randomPhotoURLString)!
        urlComponents.queryItems = [
            //URLQueryItem(name: "per_page", value: "10"),        // per_page — количество фотографий на одной странице
            URLQueryItem(name: "page", value: "\(nextPage)")    // page — номер страницы
        ]
        
        guard let url = urlComponents.url else { fatalError("Failed to create URL") }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        print("\n‼️🔔\nrequest is: \(request)")
        return request
    }
    
    
    private func convertPhotoResultToPhoto(result: PhotoResult) -> Photo {
        let size = CGSize(width: Double(result.width), height: Double(result.height))
        let createdAt = Formater().stringToDate(stringForConvertation: result.createdAt)
        
        let photo = Photo(
            id: result.id,
            size: size,
            createdAt: createdAt,
            welcomeDescription: result.description,
            thumbImageURL: result.urls.thumbImageURL,
            largeImageURL: result.urls.largeImageURL,
            isLiked: result.isLiked
        )
        return photo
    }
    
    
    private func addNewPhotosToArray(photoResults: [PhotoResult]) {
        for photoResult in photoResults {
            let photo = self.convertPhotoResultToPhoto(result: photoResult)
            self.photos.append(photo)
        }
        NotificationCenter.default.post(
            name: ImagesListService.didChangeNontification,
            object: self
        )
    }
    
    
}
