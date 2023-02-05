//
//  StringToDateFormater.swift
//  ImageFeed
//
//  Created by Роман Бойко on 1/24/23.
//

import Foundation

final class Formatter {
    static func stringToDate (stringForConvertation: String?) -> Date? {
        if let stringDate = stringForConvertation {
            let dateFormatter = ISO8601DateFormatter()
            let date = dateFormatter.date(from: stringDate)
            return date
        } else {
            return nil
        }
    }
    
    static func dateToString(dateForConvertation: Date?) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        var result = String()
        if dateForConvertation != nil {
            result = formatter.string(from: dateForConvertation!)
        } else {
            result = ""
        }
        return result
    }
}
