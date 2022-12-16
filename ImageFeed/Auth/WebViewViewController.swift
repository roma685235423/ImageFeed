//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Роман Бойко on 12/16/22.
//

import WebKit
import UIKit

class WebViewViewControllew:    UIViewController {
    
    var UnsplashAuthorizeURLString = String()
    
    @IBOutlet private var webView: WKWebView!
    
//MARK: - LifeCicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        webView.navigationDelegate = self
    }
    
    @IBAction func didTapBackButton(_ sender: Any?) {
        dismiss(animated: true)
    }
    
}

extension WebViewViewControllew: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {   if let code = code(from: navigationAction) {
            //TODO: process code
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if let url = navigationAction.request.url,
           let urlComponents = URLComponents(string: url.absoluteString),
           urlComponents.path == "oauth/authorize/native",
           let items = urlComponents.queryItems,
           let codeItem = items.first(where: {$0.name == "code"}) {
            return codeItem.value
        } else {
            return nil
        }
    }
    
    
}
