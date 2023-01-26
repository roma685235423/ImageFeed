//
//  ImageListCells.swift
//  ImageFeed
//
//  Created by Роман Бойко on 11/23/22.
//

import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    
    @IBOutlet private weak var imagesListCellImage: UIImageView!
    
    @IBOutlet private weak var imagesListCellTextLabel: UILabel!
    
    @IBOutlet private weak var imagesListCellLikeButton: UIButton!
    
    @IBOutlet private weak var imagesListCellGradient: UIView!
    
    
    // MARK: - Helpers
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
}



// MARK: - Extension

extension ImagesListCell {
    
    func configureCurrentCellContent(photo: Photo, completion: @escaping () -> Void) {
        self.imageView?.image = nil
        let createdAt = dateFormatter.string(from: photo.createdAt ?? Date())
        guard let thumbImageUrl = URL(string: photo.thumbImageURL),
              let placeholderImage = UIImage(named: "card") else {
            return
        }
        self.imageView?.kf.indicatorType = .activity
        self.imageView?.kf.setImage(
            with: thumbImageUrl,
            placeholder: placeholderImage
        ){ [weak self] _ in
            guard let self = self else { return }
            
            self.imagesListCellTextLabel.text = createdAt
            self.createGradient()
            let likeButtonImage = photo.isLiked ? UIImage(named: "like_button_on"): UIImage(named: "like_button_off")
            self.imagesListCellLikeButton.setImage(likeButtonImage, for: .normal)
            self.prepareForReuse()
        }
    }
    
    
    private func createGradient() {
        
        let gradient = CAGradientLayer()
        let colorTop = UIColor(named: "gradientTop")?.cgColor
        let colorBottom = UIColor(named: "gradientBottom")?.cgColor
        gradient.colors = [colorTop!, colorBottom!]
        gradient.frame = imagesListCellGradient.bounds
        imagesListCellGradient.layer.addSublayer(gradient)
        
    }
    
    
    override func prepareForReuse() {
        self.imageView?.kf.cancelDownloadTask()
    }
}
