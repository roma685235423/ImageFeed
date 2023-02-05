import Foundation

fileprivate var descriptionError: String = ""

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
            switch code {
            case 400:
                descriptionError = "Код ошибки: \(code)\nНекорректный запрос. Отсутствует обязательный параметр."
            case 401:
                descriptionError = "Код ошибки: \(code)\nНекорректный токен авторизации."
            case 403:
                descriptionError = "Код ошибки: \(code)\nОтсутствует разрешение для выполнения запроса."
            case 404:
                descriptionError = "Код ошибки: \(code)\nЗапрошенный ресурс не существует."
            case 500, 503:
                descriptionError = "Код ошибки: \(code)\nЧто-то не так на стороне сервера."
            default:
                descriptionError = "Код ошибки: \(code)."
            }
            return NSLocalizedString(descriptionError, comment: "Received an invalid response code: \(code)")
        }
    }
}
