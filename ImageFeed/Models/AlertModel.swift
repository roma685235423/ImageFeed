import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    var completion: () -> Void
}

struct AlertModelTwoButtons {
    let title: String
    let message: String
    let buttonText: String
    var completionForLeftButton: () -> Void
    var completionFoRightButton: () -> Void
}
