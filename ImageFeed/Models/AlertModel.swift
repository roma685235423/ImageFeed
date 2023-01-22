//
//  AlertModel.swift
//  ImageFeed
//
//  Created by Роман Бойко on 1/12/23.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    var completion: () -> Void
}
