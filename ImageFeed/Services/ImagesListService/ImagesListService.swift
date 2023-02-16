import Foundation

protocol ImagesListServiceProtocol {
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping(Result<Void, Error>) -> Void)
    func fetchPhotosNextPage()
    func getPhotos() -> [Photo]
    func cleanPhotos()
    func getLargeImageCellURL(indexPath: IndexPath) -> URL
}

final class ImagesListService: ImagesListServiceProtocol {
    
    // MARK: - Properties
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private let getPhotosURLString  = "https://api.unsplash.com/photos"
    private let session = URLSession.shared
    private var task: URLSessionTask?
    private let keychain = ProfileImageService.shared.keychainWrapper
    
    
    //MARK: - Notification
    static let didChangeNontification = Notification.Name("ImagesListServiceDidChange")
    
    
    //MARK: - Methods
    
    func getPhotos() -> [Photo] {
        photos
    }
    
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        if task != nil { return }
        guard let token = keychain.getBearerToken() else { return }
        
        var nextPage: Int
        if let lastLoadedPage {
            nextPage = lastLoadedPage + 1
        } else {
            nextPage = 1
        }
        let request = makeRequest(token: token, nextPage: nextPage)
        let task = self.session.objectTask(for: request) { [weak self]
            (result: Result<[PhotoResult], Error>) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                guard case .success(let result) = result else { return }
                    self.lastLoadedPage = nextPage
                    self.addNewPhotosToArray(photoResults: result)
                }
                self.task = nil
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
            URLQueryItem(name: "per_page", value: "10"),
            URLQueryItem(name: "page", value: "\(nextPage)")    // page number
        ]
        guard let url = urlComponents.url else { fatalError("Failed to create URL") }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    
    private func addNewPhotosToArray(photoResults: [PhotoResult]) {
        let newPhotos = photoResults.map{ $0.convertToViewModel() }
        photos.append(contentsOf: newPhotos)
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
    
    
    func cleanPhotos(){
        photos = []
    }
}
