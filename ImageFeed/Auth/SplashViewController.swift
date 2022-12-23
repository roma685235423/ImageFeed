//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Роман Бойко on 12/23/22.
//

import UIKit

class SplashViewController: UIViewController {
    
    let ShowAuthenticationScreenSegueIdentifier = ""
    //MARK: - LifeCicle
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        
        let tokenStorage = OAuth2TokenStorage()
        let token = tokenStorage.token
        
        super.viewDidAppear(animated)
        if token != "" {
            print(token)
        } else {
            
        }
        
    }
}
