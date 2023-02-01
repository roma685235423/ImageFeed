//
//  ImageListCells.swift
//  ImageFeed
//
//  Created by Роман Бойко on 11/23/22.
//

import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    
    // MARK: - Properties
    
    weak var delegate: ImagesListCellDelegate?
    
    
    // MARK: - Layout
    @IBOutlet weak var imagesListCellImage: UIImageView!
    @IBOutlet private weak var imagesListCellTextLabel: UILabel!
    @IBOutlet private weak var imagesListCellLikeButton: UIButton!
    @IBOutlet private weak var imagesListCellGradient: UIView!
    
    
    // MARK: - Actions
    @IBAction func didTapLikeButton(_ sender: Any) {
        likeButtonClicked()
    }
    
}



// MARK: - Extension

extension ImagesListCell {
    
    func configureCurrentCellContent(photo: Photo, createdAt: String) {
        self.createGradient()
        self.imagesListCellTextLabel.text = createdAt
        let likeButtonImage = photo.isLiked ? UIImage(named: "like_button_on"): UIImage(named: "like_button_off")
        self.imagesListCellLikeButton.setImage(likeButtonImage, for: .normal)
        self.prepareForReuse()
    }
    
    func changeLikeButtonImage(isLiked: Bool) {
        let likeButtonImage = isLiked ? UIImage(named: "like_button_on"): UIImage(named: "like_button_off")
        self.imagesListCellLikeButton.setImage(likeButtonImage, for: .normal)
    }
    
    private func createGradient() {
        
        let gradient = CAGradientLayer()
        let colorTop = UIColor(named: "gradientTop")?.cgColor
        let colorBottom = UIColor(named: "gradientBottom")?.cgColor
        gradient.colors = [colorTop!, colorBottom!]
        gradient.frame = imagesListCellGradient.bounds
        imagesListCellGradient.layer.addSublayer(gradient)
    }
    
    
    private func configureImagesCellSize(photo: Photo) {
        self.layer.bounds.size = photo.size
    }
    
    func getImageFromCell() -> UIImage {
        return self.imagesListCellImage.image ?? UIImage()
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView?.kf.cancelDownloadTask()
    }
    
    @objc private func likeButtonClicked(){
        delegate?.imageListCellDidTapLike(cell: self)
    }
}
