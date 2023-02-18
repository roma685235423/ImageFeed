import XCTest
import Foundation
import UIKit

@testable import ImageFeed

final class ProfileViewTests: XCTestCase {
    func testProfileViewControllerCallsViewDidLoad() {
        //given
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        viewController.presenter = presenter
        //when
        _ = viewController.view
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterCallsFetchProfileImageURL() {
        //given
        let helper = ProfileViewHelperSpy()
        let presenter = ProfileViewPresenter(helper: helper)
        //when
        presenter.fetchProfileImageURL()
        //then
        XCTAssertTrue(helper.fetchProfileImageURLCalled)
    }
    func testPresenterCallsFetchProfile() {
        //given
        let helper = ProfileViewHelperSpy()
        let presenter = ProfileViewPresenter(helper: helper)
        let token = ""
        //when
        presenter.fetchProfile(token: token)
        //then
        XCTAssertTrue(helper.fetchProfileCalled)
    }
    
    func testViewControllerCallsGetAvatarURL() {
        //given
        let viewController = ProfileViewController()
        let helper = ProfileViewHelperSpy()
        let presenter = ProfileViewPresenter(helper: helper)
        presenter.view = viewController
        viewController.presenter = presenter
        //when
        let avatarUrl = viewController.presenter?.getAvatarURL()
        let result = avatarUrl?.absoluteString
        //then
        XCTAssertTrue(result == "testURL")
    }
    
    func testViewControllerCallsAvatarUrlEqualNil() {
        //given
        let viewController = ProfileViewController()
        let helper = ProfileViewHelperSpy()
        let presenter = ProfileViewPresenter(helper: helper)
        presenter.view = viewController
        viewController.presenter = presenter
        //when
        guard let avatarUrlEqualNil = viewController.presenter?.avatarURLEqualNil() else {
            XCTAssertTrue(false)
            return
        }
        //then
        XCTAssertTrue(avatarUrlEqualNil)
    }
    
    func testViewControllerCallsProfileEqualNil() {
        //given
        let viewController = ProfileViewController()
        let helper = ProfileViewHelperSpy()
        let presenter = ProfileViewPresenter(helper: helper)
        presenter.view = viewController
        viewController.presenter = presenter
        //when
        guard let profileEqualNil = viewController.presenter?.profileEqualNil() else {
            XCTAssertTrue(false)
            return
        }
        //then
        XCTAssertTrue(profileEqualNil)
    }
    
    func testViewControllerCallsCleanCurrentSessionContext() {
        //given
        let viewController = ProfileViewController()
        let helper = ProfileViewHelperSpy()
        let presenter = ProfileViewPresenter(helper: helper)
        presenter.view = viewController
        viewController.presenter = presenter
        //when
        viewController.presenter?.cleanCurrentSessionContext()
        //then
        XCTAssertTrue(helper.cleanCurrentSessionContextCalled)
    }
    
    func testPresenterCallsConfigureProfileDetails() {
        //given
        let viewController = ProfileViewControllerSpy()
        let helper = ProfileViewHelperSpy()
        let presenter = ProfileViewPresenter(helper: helper)
        presenter.view = viewController
        //when
        presenter.view?.configureProfileDetails()
        //then
        XCTAssertTrue(viewController.configureProfileDetailsCalled)
    }
}


final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var configureProfileDetailsCalled: Bool = false
    var updateAvatarCalled: Bool = false
    
    var presenter: ImageFeed.ProfileViewPresenterProtocol?
    
    func configureProfileDetails() {
        configureProfileDetailsCalled = true
    }
    
    func updateAvatar() {
        updateAvatarCalled = true
    }
    
    func showDefaultAlert() {
    }
    
    func removeProfileGradients() {
    }
    
    func updateProfileDetails(profile: ImageFeed.Profile) {
    }
}

final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    var view: ImageFeed.ProfileViewControllerProtocol?
    var viewDidLoadCalled: Bool = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func avatarURLEqualNil() -> Bool {
        return true
    }
    
    func profileEqualNil() -> Bool {
        return true
    }
    
    func fetchProfileImageURL() {
    }
    
    func cleanCurrentSessionContext() {
    }
    
    func getAvatarURL() -> URL? {
        return nil
    }
}

final class ProfileViewHelperSpy: ProfileViewHelperProtocol {
    var fetchProfileCalled: Bool = false
    var fetchProfileImageURLCalled: Bool = false
    var cleanCurrentSessionContextCalled: Bool = false
    fileprivate var profileImageService = ProfileImageService(
        avatarURL: URL(string: "testURL"),
        token: "testToken")
    
    func fetchProfileImageURL(completion: @escaping (Result<String, Error>) -> Void) {
        fetchProfileImageURLCalled = true
    }
    
    func fetchProfile(token: String, completion: @escaping (Result<ImageFeed.Profile, Error>) -> Void) {
        fetchProfileCalled = true
    }
    
    func avatarURLEqualNil() -> Bool {
        return true
    }
    
    func profileEqualNil() -> Bool {
        return true
    }
    
    func getBearerToken() -> String? {
        return profileImageService.token
    }
    
    func cleanCurrentSessionContext() {
        cleanCurrentSessionContextCalled = true
    }
    
    func getAvatarURL() -> URL? {
        return profileImageService.avatarURL
    }
}

fileprivate struct ProfileImageService {
    var avatarURL: URL?
    var token: String
}
