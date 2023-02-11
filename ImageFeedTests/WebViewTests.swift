//
//  ImageFeedTests.swift
//  ImageFeedTests
//
//  Created by Роман Бойко on 2/10/23.
//

import XCTest
import Foundation
import UIKit

@testable import ImageFeed

final class WebViewTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        //given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
        let presenter = WebViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        //when
        _ = viewController.view
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled) //behaviour verification
    } 

    
    func testPresenterCallsLoadRequest() {
        //given
        let viewControler = WebViewControllerSpy()
        let helper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: helper)
        presenter.view = viewControler
        //when
        presenter.viewDidload()
        //then
        XCTAssertTrue(viewControler.loadRequestCalled)
    }
    
    
    func testProgressVisileWhenLesshenOne() {
        //given
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 0.6
        //when
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        //then
        XCTAssertFalse(shouldHideProgress)
    }
    
    
    func testProgressViewHiddenThenEqualOne() {
        //given
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 1.0
        //when
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        //then
        XCTAssertTrue(shouldHideProgress)
    }
    
    
    func testAuthHelperAuthURL() {
        //given
        let cofiguration = AuthConfiguration.standard
        let authHelper = AuthHelper(configuration: cofiguration)
        //when
        let url = authHelper.authUrl()
        let urlString = url.absoluteString
        //then
        XCTAssertTrue(urlString.contains(cofiguration.authURLString))
        XCTAssertTrue(urlString.contains(cofiguration.redirectURI))
        XCTAssertTrue(urlString.contains(cofiguration.accessKey))
        XCTAssertTrue(urlString.contains("code"))
        XCTAssertTrue(urlString.contains(cofiguration.accessScope))
    }
    
    
    func testCodeFromURL() {
        //given
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize/native")!
        urlComponents.queryItems = [URLQueryItem(name: "code", value: "test code")]
        let url = urlComponents.url!
        let authHelper = AuthHelper()
        //when
        let code = authHelper.code(from: url)
        //then
        XCTAssertEqual(code, "test code")
    }
}



final class WebViewPresenterSpy: WebViewPresenterProtocol  {
    var view: WebViewViewControllerProtocol?
    
    var viewDidLoadCalled: Bool = false
    
    func viewDidload() {
        viewDidLoadCalled = true
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
    
    }
    
    func code(from url: URL) -> String? {
        return nil
    }
}



final class WebViewControllerSpy: WebViewViewControllerProtocol {
    var presenter: ImageFeed.WebViewPresenterProtocol?
    var loadRequestCalled = false
    
    func load(request: URLRequest) {
        loadRequestCalled = true
    }
    
    func setProgressValue(_ newValue: Float) {
    }
    
    func setProgressHidden(_ isHidden: Bool) {
    }
    
    
}
