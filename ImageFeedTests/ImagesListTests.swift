import XCTest
import Foundation
import UIKit

@testable import ImageFeed

final class ImagesListTests: XCTestCase {
    let photos = [Photo(id: "test id 1",
                        size: CGSize(width: 50, height: 50),
                        createdAt: nil,
                        welcomeDescription: "test 1 welcomeDescription",
                        thumbImageURL: "test 1 thumbImageURL",
                        largeImageURL: "test 1 largeImageURL",
                        isLiked: true)]
    func testViewControllerCallsViewDidLoad() {
        //given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        let presenter = ImagesListPresenterSpy()
        viewController.presenter = presenter
        //when
        _ = viewController.view
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterCallsFetchPhotosNextPage() {
        //given
        let service = ImagesListServiceSpy()
        let presenter = ImagesListPresenter(imagesListService: service)
        let viewController = ImagesListViewControllerSpy()
        viewController.presenter = presenter
        //when
        viewController.presenter?.isNeedToFetchNextPage(actualRow: 1)
        //then
        XCTAssertTrue(service.fetchPhotosNextPageWasCalled)
    }
    
    func testPresenterCallsChangeLike() {
        //given
        let service = ImagesListServiceSpy()
        let presenter = ImagesListPresenter(imagesListService: service)
        let viewController = ImagesListViewControllerSpy()
        viewController.presenter = presenter
        //when
        viewController.presenter?.changeLikeInPhotosService(photo: photos[0], cell: ImagesListCell(), index: 1)
        //then
        XCTAssertTrue(service.changeLikeWasCalled)
    }
    
    func testPresenterCallsGetLargeImageCellURL() {
        //given
        let service = ImagesListServiceSpy()
        let presenter = ImagesListPresenter(imagesListService: service)
        let viewController = ImagesListViewControllerSpy()
        viewController.presenter = presenter
        //when
        guard let url = viewController.presenter?.getLargeImageCellURL(indexPath: IndexPath()) else
        { return }
        let urlString = url.absoluteString
        //then
        XCTAssertTrue(urlString == "https://url.test")
    }
    
    func testPresenterCallsCleanPhotos() {
        //given
        let service = ImagesListServiceSpy()
        let presenter = ImagesListPresenter(imagesListService: service)
        let viewController = ImagesListViewControllerSpy()
        viewController.presenter = presenter
        //when
        viewController.presenter?.cleanPhotos()
        //then
        XCTAssertTrue(service.cleanPhotosWasCalled)
    }
}



final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var presenter: ImageFeed.ImagesListPresenterProtocol?
    
    func showDefaultAlert() {
    }
    
    func updateTableViewAnimated() {
    }
}


final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var viewDidLoadCalled: Bool = false
    
    var view: ImageFeed.ImagesListViewControllerProtocol?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func photosInServiceAndPhotosArrayCounters() -> ImageFeed.photosCounts {
        return photosCounts(localPhotosCount: 0, servicePhotosCount: 1)
    }
    
    func getPhotoFromArray(index: Int) -> ImageFeed.Photo? {
        return nil
    }
    
    func changeLikeInPhotosService(photo: ImageFeed.Photo, cell: ImageFeed.ImagesListCell, index: Int) {
        
    }
    
    func isNeedToFetchNextPage(actualRow: Int) {
        
    }
    
    func cleanPhotos() {
        
    }
    
    func getLargeImageCellURL(indexPath: IndexPath) -> URL {
        URL(string: "URL")!
    }
}


final class ImagesListServiceSpy: ImagesListServiceProtocol {
    var fetchPhotosNextPageWasCalled: Bool = false
    var changeLikeWasCalled: Bool = false
    var cleanPhotosWasCalled: Bool = false
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        changeLikeWasCalled = true
    }
    
    func fetchPhotosNextPage() {
        fetchPhotosNextPageWasCalled = true
    }
    
    func getPhotos() -> [ImageFeed.Photo] {
        [Photo(id: "test id 1",
               size: CGSize(width: 50, height: 50),
               createdAt: nil,
               welcomeDescription: "test 1 welcomeDescription",
               thumbImageURL: "test 1 thumbImageURL",
               largeImageURL: "test 1 largeImageURL",
               isLiked: true),
         Photo(id: "test id 2",
               size: CGSize(width: 50, height: 50),
               createdAt: Date(),
               welcomeDescription: "test 1 welcomeDescription",
               thumbImageURL: "test 1 thumbImageURL",
               largeImageURL: "test 1 largeImageURL",
               isLiked: false)]
    }
    
    func cleanPhotos() {
        cleanPhotosWasCalled = true
    }
    
    func getLargeImageCellURL(indexPath: IndexPath) -> URL {
        URL(string: "https://url.test")!
    }
}
