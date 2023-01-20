//
//  UIBlockingProgressHUD.swift
//  ImageFeed
//
//  Created by Роман Бойко on 1/3/23.
//

import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {
    
    private static var window: UIWindow? {
        return UIApplication.shared.windows.first
    }
    
    static func show() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.show()
        print("\n‼️‼️❌\nUIBlockingProgressHUD.show()\nisUserInteractionEnabled = false\n")
    }
    
    static func dismiss() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
        print("\n‼️‼️✅\nUIBlockingProgressHUD.dismiss()\nisUserInteractionEnabled = true\n")
    }
}
