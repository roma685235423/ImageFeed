//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by Роман Бойко on 1/11/23.
//

import UIKit

class AlertPresenter {
    
    func show(in vc: UIViewController, model: AlertModel) {
        let alertController = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)
        
        alertController.view.accessibilityIdentifier = "error_alert"
        
        let action = UIAlertAction(title: model.buttonText, style: .default
        ){ _ in
            model.completion()
        }
        alertController.addAction(action)
            vc.present(alertController, animated: true)
    }
}
