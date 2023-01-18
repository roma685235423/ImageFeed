//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Роман Бойко on 12/16/22.
//

import WebKit
import UIKit

//MARK: - fileprivate Properties

fileprivate let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
fileprivate var progress = Float()
private var estimatedProgressObservation: NSKeyValueObservation?



//MARK: - Protocol

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}



//MARK: - WebViewViewController
class WebViewViewController: UIViewController {
    
    //MARK: - Propertie
    weak var delegate: WebViewViewControllerDelegate?
    private let profileImageService = ProfileImageService.shared
    
    
    //MARK: - Outlets
    @IBOutlet private var webView: WKWebView!
    @IBOutlet weak var progressView: UIProgressView!
    
    
    //MARK: - LifeCicle
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func viewDidLoad() {
        setNeedsStatusBarAppearanceUpdate()
        super.viewDidLoad()
        
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: { [ weak self] _, _ in
                 guard let self = self else {return}
                 self.updateProgress()
             })
        webView.navigationDelegate = self
        
        var urlComponents = URLComponents(string: UnsplashAuthorizeURLString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: constants.AccessKey),
            URLQueryItem(name: "redirect_uri", value: constants.RedirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: constants.AccessScope)
        ]
        let url = urlComponents.url!
        DispatchQueue.main.async {
            let request = URLRequest(url: url)
            self.webView.load(request)
        }
    }
    
    
    //MARK: - Methods
    
    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0)  <= 0.0001
    }
    
    
    //MARK: - Action
    
    @IBAction func didTapBackButton(_ sender: Any?) {
        delegate?.webViewViewControllerDidCancel(self)
    }
}


//MARK: - Extension

extension WebViewViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    // Function to get code
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString ),
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: {$0.name == "code"}),
            urlComponents.path == "/oauth/authorize/native"
        {
            profileImageService.keychainWrapper.setAuthToken(token: codeItem.value)
            return codeItem.value
        } else {
            return nil
        }
    }
}
