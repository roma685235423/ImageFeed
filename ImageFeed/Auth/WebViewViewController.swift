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



//MARK: - Protocols

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}



//MARK: - WebViewViewController
class WebViewViewController: UIViewController {
    
    weak var delegate: WebViewViewControllerDelegate?
    
    @IBOutlet private var webView: WKWebView!
    @IBOutlet weak var progressView: UIProgressView!
    
    
//MARK: - LifeCicle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), context: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        
        var urlComponents = URLComponents(string: UnsplashAuthorizeURLString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: AccessKey),
            URLQueryItem(name: "redirect_url", value: RedirectURI),
            URLQueryItem(name: "responce_type", value: "code"),
            URLQueryItem(name: "scope", value: AccessScope)
        ]
        let url = urlComponents.url!
        
        let request = URLRequest(url: url)
        webView.load(request)
        
        updateProgress()
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), context: nil)
        updateProgress()
    }
    
    
//MARK: - Methods
    
    override func observeValue(forKeyPath keyPath: String?,of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            updateProgress()
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0)  <= 0.0001
    }
    
    
//MARK: - Actions
    
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
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        
        let url = navigationAction.request.url
        let urlComponents = URLComponents(string: url?.absoluteString ?? "")
        let items = urlComponents?.queryItems
        let codeItem = items?.first(where: {$0.name == "code"})
        if (url != nil) && (urlComponents != nil) && (items != nil) && (codeItem != nil) && urlComponents?.path == "/oauth/authorize/native"
        {
            print("\n✅\n URL ---> \(url)\n urlComponents ---> \(urlComponents)\n items ---> \(items)\n codeItem ---> \(codeItem)\n")
            return codeItem?.value
        } else {
            print("\n❌\n URL ---> \(url)\n urlComponents ---> \(urlComponents)\n items ---> \(items)\n codeItem ---> \(codeItem)\n")
            return nil
        }
    }
    
}
