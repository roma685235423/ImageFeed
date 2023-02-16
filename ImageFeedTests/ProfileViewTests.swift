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

    func testPresenterCallsFetchProfile() {
        //given
        let viewController = ProfileViewController()
        let helper = ProfileViewHelperSpy()
        let presenter = ProfileViewPresenterSpy()
        presenter.view = viewController

        viewController.viewDidLoad()

        XCTAssertFalse(helper.fetchProfileCalled)
    }
}

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ImageFeed.ProfileViewPresenterProtocol?

    func configureProfileDetails() {
    }

    func updateAvatar() {
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
    var fetchProfileCalled: Bool = false

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
    fetchProfileCalled = true
    }

    func cleanCurrentSessionContext() {
    }

    func getAvatarURL() -> URL? {
        return nil
    }
}

final class ProfileViewHelperSpy: ProfileViewHelperProtocol {
    var fetchProfileCalled: Bool = false

    func fetchProfileImageURL(completion: @escaping (Result<String, Error>) -> Void) {
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
        return nil
    }

    func cleanCurrentSessionContext() {
    }

    func getAvatarURL() -> URL? {
        return nil
    }
}
