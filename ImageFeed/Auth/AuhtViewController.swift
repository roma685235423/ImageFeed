//
//  AuhtViewController.swift
//  ImageFeed
//
//  Created by Роман Бойко on 12/16/22.
//

import UIKit


class AuthViewController: UIViewController {
    
    private let ShowWebViewSegueIdentifier = "ShowWebView"
    
    private let oAuth2Service = OAuth2Service()
    
    private var tokenStorage = OAuth2TokenStorage()
    
    
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
        
        self.oAuth2Service.fetchAuthToken(code: code){ [self] result in
                switch result {
                case .success(let bearerToken):
                    print("\n✅✅✅\nSUCCESS. Token value is \n \(bearerToken) ")
                    tokenStorage.token = bearerToken
                    let result = tokenStorage.token
                    print("\n✅✅✅\nSUCCESS. Token stored to User Defaults. Value is \n \(String(describing: result)) ")
                case .failure(let error):
                    print("\n❌\nERROR ===> \(error)\n")
                    return
            }
        }
    }

    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
