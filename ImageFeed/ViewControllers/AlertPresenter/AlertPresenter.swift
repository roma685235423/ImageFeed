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
        vc.view.layer.backgroundColor = UIColor(named: "black")?.cgColor
        vc.present(alertController, animated: true)
    }
    
    
    static func showError(in vc: UIViewController) {
        let alertController = UIAlertController (
            title: "Что-то пошло не так",
            message: "Попробовать ещё раз?",
            preferredStyle: .alert)
        let okAaction = UIAlertAction(title: "Ок", style: .cancel)
        alertController.addAction(okAaction)
        vc.present(vc, animated: true)
        
    }
}
