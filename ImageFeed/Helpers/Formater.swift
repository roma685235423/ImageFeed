//
//  StringToDateFormater.swift
//  ImageFeed
//
//  Created by Роман Бойко on 1/24/23.
//

import Foundation

final class Formater {
    
    func stringToDate (stringForConvertation: String?) -> Date? {
        
        if let stringDate = stringForConvertation {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZ"
            let date = dateFormatter.date(from: stringDate)
            
            return date
        } else {
            return nil
        }
    }
}
