//
//  CustomErrors.swift
//  ImageFeed
//
//  Created by Роман Бойко on 1/11/23.
//

import Foundation


enum NetworkError: Error {
case decodeError
case incorrectStatusCode(code: Int)
}


extension NetworkError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .decodeError:
            return "Decode data error"
        case .incorrectStatusCode(_):
            return "Wrong response code"
        }
    }
}


extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .decodeError:
            return NSLocalizedString("Decode data error", comment: "Failed to decode received data")
        case .incorrectStatusCode(let code):
            return NSLocalizedString("Wrong response code", comment: "Received an invalid response code: \(code)")
        }
    }
}
