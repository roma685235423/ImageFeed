import Foundation

extension Date {
    var stringFromDate: String { dateToStringFormatter.string(from: self) }
}


private let dateToStringFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .none
    return formatter
}()
