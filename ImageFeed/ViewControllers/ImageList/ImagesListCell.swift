//
//  ImageListCells.swift
//  ImageFeed
//
//  Created by Роман Бойко on 11/23/22.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    
    @IBOutlet private weak var imagesListCellImage: UIImageView!
    
    @IBOutlet private weak var imagesListCellTextLabel: UILabel!
    
    @IBOutlet private weak var imagesListCellLikeButton: UIButton!
    
    @IBOutlet private weak var imagesListCellGradient: UIView!
    
}



// MARK: - Extension

extension ImagesListCell {
    // This method is responsible for configutation of cell
    func configureCell(image: UIImage?, date: String?, isLiked: Bool) {
        
        imagesListCellImage.image = image
        imagesListCellTextLabel.text = date
        let likeButtonImage = isLiked ? UIImage(named: "like_button_on"): UIImage(named: "like_button_off")
        imagesListCellLikeButton.setImage(likeButtonImage, for: .normal)
        
        let gradient = CAGradientLayer()
        
        let colorTop = UIColor(named: "gradientTop")?.cgColor
        let colorBottom = UIColor(named: "gradientBottom")?.cgColor
        
        gradient.colors = [colorTop!, colorBottom!]
        gradient.frame = imagesListCellGradient.bounds
        
        imagesListCellGradient.layer.addSublayer(gradient)
        
    }
}
