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
    private let getPhotosURLString  = "https://api.unsplash.com/photos"
    private let session = URLSession.shared
    private var task: URLSessionTask?
    
    private let keychain = ProfileImageService.shared.keychainWrapper
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
                case .failure:
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
        var urlComponents = URLComponents(string: self.getPhotosURLString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: "\(nextPage)")    // page — номер страницы
        ]
        guard let url = urlComponents.url else { fatalError("Failed to create URL") }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
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
    
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping(Result<Void, Error>) -> Void){
        enum likeError: Error {
            case searchedPhotoIndexNotFound
        }
        let request = makeRequest(photoId: photoId, isLike: !isLike)
        let task = session.objectTask(for: request) { [weak self] (result: Result<likeResult, Error>) in
            guard let self = self else { return }
            switch result {
            case .success:
                DispatchQueue.main.async {
                    // search elements index
                    if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                        // current photo
                        let photo = self.photos[index]
                        // a copy of photo with
                        let updatedPhoto = Photo(
                            id: photo.id,
                            size: photo.size,
                            createdAt: photo.createdAt,
                            welcomeDescription: photo.welcomeDescription,
                            thumbImageURL: photo.thumbImageURL,
                            largeImageURL: photo.thumbImageURL,
                            isLiked: !photo.isLiked
                        )
                        self.photos[index] = updatedPhoto
                        completion(.success(()))
                    } else {
                        completion(.failure(likeError.searchedPhotoIndexNotFound))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    
    private func makeRequest(photoId: String, isLike: Bool) -> URLRequest {
        var urlComponents = URLComponents(string: self.getPhotosURLString)!
        urlComponents.path = "/photos/\(photoId)/like"
        guard let url = urlComponents.url else { fatalError("Failed to create URL") }
        var request = URLRequest(url: url)
        let token = keychain.getBearerToken()
        let method = isLike ? "POST" : "DELETE"
        request.httpMethod = method
        request.setValue("Bearer \(token ?? "")", forHTTPHeaderField: "Authorization")
        return request
    }
    
    
    func getLargeImageCellURL(indexPath: IndexPath) -> URL {
        let stringUrl = photos[indexPath.row].largeImageURL
        guard let url = URL(string: stringUrl) else { fatalError("Don't have URL for large photo")}
        return url
    }
}
