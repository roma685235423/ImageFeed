import UIKit


extension UIViewController {
    
    func showDefaultAlertPresenter() {
        let alertController = UIAlertController (
            title: "Что-то пошло не так",
            message: "Попробовать ещё раз?",
            preferredStyle: .alert)
        let okAaction = UIAlertAction(title: "Ок", style: .cancel)
        alertController.addAction(okAaction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func showCustomAlertPresenter(model: AlertModel) {
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
        self.view.layer.backgroundColor = UIColor(named: "black")?.cgColor
        self.present(alertController, animated: true)
    }
}

