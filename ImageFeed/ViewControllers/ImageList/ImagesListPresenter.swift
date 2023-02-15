import UIKit

protocol ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    func photosInServiceAndPhotosArrayNotEqual() -> photosCounts
    func getPhotoFromArray(index: Int) -> Photo?
    func changeLike(index: Int)
    func getCurrentPhotoLike(index: Int) -> Bool
    func changeLikeInPhotosService(photo: Photo, cell: ImagesListCell, index: Int)
    func viewDidLoad()
    func isNeedToFetchNextpage(actualRow: Int)
    func cleanPhotos()
}


final class ImagesListPresenter: ImagesListPresenterProtocol {
    weak var view: ImagesListViewControllerProtocol?
    var imagesListService: ImagesListServiceProtocol
    private var photos = [Photo]()
    
    
    func viewDidLoad() {
        print("\n✅\nImagesListPresenter\n✅ ")
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
    
    
    func isNeedToFetchNextpage(actualRow: Int) {
        if actualRow + 1 == imagesListService.getPhotos().count {
            imagesListService.fetchPhotosNextPage()
        }
    }
    
    
    func getPhotoFromArray(index: Int) -> Photo? {
        photos[index]
    }
    
    func photosInServiceAndPhotosArrayNotEqual() -> photosCounts {
        let oldCount = photos.count
        let newCount = imagesListService.getPhotos().count
        //        helper.updatePhotos()
        photos = imagesListService.getPhotos()
        let result = photosCounts(
            oldCount: oldCount,
            newCount: newCount)
        return result
    }
    
    func changeLike(index: Int) {
        photos[index].isLiked.toggle()
    }
    
    func getCurrentPhotoLike(index: Int) -> Bool {
        photos[index].isLiked
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
                //self.showDefaultAlertPresenter()
                UIBlockingProgressHUD.dismiss()
                return
            }
        }
    }
    init(imagesListService: ImagesListServiceProtocol) {
        self.imagesListService = imagesListService
    }
    
    func cleanPhotos() {
        photos = []
        imagesListService.cleanPhotos()
    }
}
struct photosCounts {
    let oldCount: Int
    let newCount: Int
}
