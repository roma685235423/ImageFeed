//
//  AuhtViewController.swift
//  ImageFeed
//
//  Created by Роман Бойко on 12/16/22.
//

import UIKit


class AuthViewController: UIViewController {
    
    private let ShowWebViewSegueIdentifier = "ShowWebView"
    
    var oAuth2ServiceDelegate: OAuth2ServiceDelegate?
    
    var tokenStorage: OAuth2TokenStorageDelegate?
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowWebViewSegueIdentifier {
            guard let webViewViewController = segue.destination as? WebViewViewController
            else {fatalError("Failed to prepare for \(ShowWebViewSegueIdentifier)")}
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        
        print("\n⏩️✅\nCode is: ===> \(code)\n")
        self.oAuth2ServiceDelegate?.fetchAuthToken(code: code){ result in
                switch result {
                case .success(let bearerToken):
                    self.tokenStorage?.token = bearerToken
                    print(bearerToken)
                    print(code)
                case .failure(let error):
                    print(error)
                    print(code)
            }
        }
    }

    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
