import Foundation

extension PhotoResult {
    
    func convertToViewModel() -> Photo {
        let size = CGSize(width: Double(self.width), height: Double(self.height))
        let createdAt: Date?
        if let dateOfCreation = self.createdAt {
            createdAt = formatter.date(from: dateOfCreation)
        } else {
            createdAt = nil
        }
        let photo = Photo(
            id: self.id,
            size: size,
            createdAt: createdAt,
            welcomeDescription: description,
            thumbImageURL: urls.thumbImageURL,
            largeImageURL: urls.largeImageURL,
            isLiked: isLiked
        )
        return photo
    }
}


private let formatter: ISO8601DateFormatter = {
    let formatter = ISO8601DateFormatter()
    return formatter
}()
