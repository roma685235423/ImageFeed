//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by Роман Бойко on 1/11/23.
//

import UIKit


final class SplashViewAlertPresenter {
    
    func show(in vc: UIViewController) {
            let alertController = UIAlertController(
                title: "Что-то пошло не так",
                message: "Не удалось войти в систему",
                preferredStyle: .alert)
            
            alertController.view.accessibilityIdentifier = "error_alert"
            let action = UIAlertAction(
                title: "Ок",
                style: .default
            ) { _ in
                //
            }
            alertController.addAction(action)
            vc.present(alertController, animated: true)
    }
}
