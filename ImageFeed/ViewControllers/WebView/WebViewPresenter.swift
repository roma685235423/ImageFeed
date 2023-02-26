import UIKit

// MARK: - Protocol
internal protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
    func viewDidload()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?
}



final class WebViewPresenter: WebViewPresenterProtocol {
    // MARK: - Properties
    weak var view: WebViewViewControllerProtocol?
    var authHelper: AuthHelperProtocol
    
    
    // MARK: - Methods
    func viewDidload() {
        self.didUpdateProgressValue(0)
        let request = self.authHelper.authRequest()
        self.view?.load(request: request)
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }
    
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
    
    func code(from url: URL) -> String? {
        authHelper.code(from: url)
    }
    
    
    // MARK: - Init
    init(authHelper: AuthHelperProtocol){
        self.authHelper = authHelper
    }
}
