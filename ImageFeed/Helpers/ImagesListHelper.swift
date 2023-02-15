//import Foundation
//
//protocol ImagesListHelperProtocol {
//    var photos: [Photo] { get set }
//    func cleanPhotos()
//    func getPhotosQuantity() -> Int
//    func getPhotosQuantityFromService() -> Int
//    func updatePhotos()
//    func changeLikeInPhotosService(photo: Photo, completion: @escaping (Result<Void, Error>) -> Void)
//}
//
//final class ImagesListHelper: ImagesListHelperProtocol {
//    private var imagesListService = ImagesListService.shared
//    var photos = [Photo]()
//    
//    func updatePhotos() {
//        photos = imagesListService.photos
//    }
//    
//        func getPhotosQuantity() -> Int {
//            photos.count
//        }
//    
//    func getPhotosQuantityFromService() -> Int {
//        imagesListService.photos.count
//    }
//    
//    func cleanPhotos() {
//        photos = []
//    }
//    
//    func changeLikeInPhotosService(photo: Photo, completion: @escaping (Result<Void, Error>) -> Void) {
//        imagesListService.changeLike(photoId: photo.id, isLike: photo.isLiked) { result in
//            switch result {
//            case .success:
//                completion(.success(()))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
//    
//    private func changeLike(index: Int) {
//        photos[index].isLiked.toggle()
//    }
//}
