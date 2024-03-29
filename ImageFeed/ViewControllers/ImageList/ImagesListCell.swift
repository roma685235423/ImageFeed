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
    
    private var gradientWasAdded = false
    private let imagesListCellImageGradient = CAGradientLayer()
    // MARK: - Actions
    @IBAction func didTapLikeButton(_ sender: Any) {
        likeButtonClicked()
    }
}



// MARK: - Extension
extension ImagesListCell {
    
    func resizeImageGradient(){
        if imagesListCellImageGradient.frame.size != imagesListCellImage.frame.size {
            imagesListCellImageGradient.frame.size = imagesListCellImage.frame.size
        }
    }
    func removeimagesListCellImageGradient() {
        imagesListCellImage.removeGradient(gradient: imagesListCellImageGradient)
    }
    
    func configureCurrentCellContent(photo: Photo, createdAt: String) {
        configureImageView()
        createGradient()
        imagesListCellImage.configureGragient(
            gradient: imagesListCellImageGradient,
            cornerRadius: 16,
            size: imagesListCellImage.frame.size,
            position: .center)
        if let createdAt = photo.createdAt {
            imagesListCellTextLabel.text = createdAt.stringFromDate
        }
        changeLikeButtonImage(isLiked: photo.isLiked )
        prepareForReuse()
    }
    
    
    func changeLikeButtonImage(isLiked: Bool) {
        let likeButtonImage = isLiked ? UIImage(named: "like_button_on"): UIImage(named: "like_button_off")
        self.imagesListCellLikeButton.setImage(likeButtonImage, for: .normal)
    }
    
    
    private func configureImageView() {
        imagesListCellImage.layer.cornerRadius = 16
        imagesListCellImage.layer.masksToBounds = true
        imagesListCellImage.clipsToBounds = true
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView?.kf.cancelDownloadTask()
    }
    
    
    @objc private func likeButtonClicked(){
        delegate?.imageListCellDidTapLike(cell: self)
    }
    
    private func createGradient() {
        if gradientWasAdded == true {
            return
        } else {
            let cellSize = self.bounds.size
            let widthDif = cellSize.width - imagesListCellImage.bounds.width - 2
            let width = imagesListCellGradient.bounds.width - widthDif
            let gradient = CAGradientLayer()
            let colorTop = UIColor(named: "gradientTop")?.cgColor
            let colorBottom = UIColor(named: "gradientBottom")?.cgColor
            gradient.colors = [colorTop!, colorBottom!]
            gradient.frame = CGRect(
                x: 0,
                y: 0,
                width: width,
                height: imagesListCellGradient.frame.height)
            let maskLayer = CAShapeLayer()
            let path = UIBezierPath(
                roundedRect: gradient.bounds,
                byRoundingCorners: [.bottomLeft, .bottomRight],
                cornerRadii: CGSize(
                    width: imagesListCellImage.layer.cornerRadius,
                    height: imagesListCellImage.layer.cornerRadius))
            maskLayer.path = path.cgPath
            gradient.mask = maskLayer
            imagesListCellGradient.layer.addSublayer(gradient)
            gradientWasAdded = true
        }
    }
}
