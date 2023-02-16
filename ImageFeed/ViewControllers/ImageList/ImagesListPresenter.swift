import UIKit

struct photosCounts {
    let localPhotosCount: Int
    let servicePhotosCount: Int
}

// MARK: - Protocol
protocol ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    func viewDidLoad()
    func photosInServiceAndPhotosArrayNotEqual() -> photosCounts
    func getPhotoFromArray(index: Int) -> Photo?
    func changeLikeInPhotosService(photo: Photo, cell: ImagesListCell, index: Int)
    func isNeedToFetchNextPage(actualRow: Int)
    func cleanPhotos()
    func getLargeImageCellURL(indexPath: IndexPath) -> URL
}


final class ImagesListPresenter: ImagesListPresenterProtocol {
    // MARK: - Properties
    weak var view: ImagesListViewControllerProtocol?
    private var imagesListService: ImagesListServiceProtocol
    private var photos = [Photo]()
    
    // MARK: - Methods
    func viewDidLoad() {
        NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNontification,
                object: nil,
                queue: .main
            ){ [weak self] _ in
                guard let self = self else { return }
                self.view?.updateTableViewAnimated()
                UIBlockingProgressHUD.dismiss()
            }
        imagesListService.fetchPhotosNextPage()
    }
    
    func getLargeImageCellURL(indexPath: IndexPath) -> URL {
        imagesListService.getLargeImageCellURL(indexPath: indexPath)
    }
    
    func cleanPhotos() {
        photos = []
        imagesListService.cleanPhotos()
    }
    
    func isNeedToFetchNextPage(actualRow: Int) {
        if actualRow + 1 == imagesListService.getPhotos().count {
            imagesListService.fetchPhotosNextPage()
        }
    }
    
    func getPhotoFromArray(index: Int) -> Photo? {
        if !photos.isEmpty{
            return photos[index]
        } else {
            return nil
        }
    }
    
    
    func photosInServiceAndPhotosArrayNotEqual() -> photosCounts {
        let oldCount = photos.count
        let newCount = imagesListService.getPhotos().count
        photos = imagesListService.getPhotos()
        let result = photosCounts(
            localPhotosCount: oldCount,
            servicePhotosCount: newCount)
        return result
    }
    
    func changeLikeInPhotosService(photo: Photo, cell: ImagesListCell, index: Int) {
        imagesListService.changeLike(photoId: photo.id, isLike: photo.isLiked) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.photos[index].isLiked.toggle()
                    cell.changeLikeButtonImage(isLiked: self.photos[index].isLiked)
                    UIBlockingProgressHUD.dismiss()
                }
            case.failure:
                self.view?.showDefaultAlert()
                UIBlockingProgressHUD.dismiss()
                return
            }
        }
    }
    
    // MARK: - Initializer
    init(imagesListService: ImagesListServiceProtocol) {
        self.imagesListService = imagesListService
    }
}
