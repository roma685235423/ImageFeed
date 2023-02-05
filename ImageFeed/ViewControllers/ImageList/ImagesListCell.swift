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
    func configureCurrentCellContent(photo: Photo) {
        configureImageView()
        createGradient()
        if let createdAt = photo.createdAt {
            imagesListCellTextLabel.text = Formatter.dateToString(dateForConvertation: createdAt)
        }
        changeLikeButtonImage(isLiked: photo.isLiked )
        imagesListCellImage.layer.masksToBounds = true
        prepareForReuse()
    }
    
    
    func changeLikeButtonImage(isLiked: Bool) {
        let likeButtonImage = isLiked ? UIImage(named: "like_button_on"): UIImage(named: "like_button_off")
        self.imagesListCellLikeButton.setImage(likeButtonImage, for: .normal)
    }
    
    
    private func createGradient() {
        let cellSize = super.bounds.size
        let widthDif = cellSize.width - imagesListCellImage.bounds.width - 3
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
        imagesListCellImage.layer.masksToBounds = true
        imagesListCellGradient.layer.addSublayer(gradient)
    }
    
    
    private func configureImageView() {
        imagesListCellImage.layer.cornerRadius = 16
        imagesListCellImage.layer.masksToBounds = true
    }
    
    private func configureImagesCellSize(photo: Photo) {
        self.layer.bounds.size = photo.size
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView?.kf.cancelDownloadTask()
    }
    
    
    @objc private func likeButtonClicked(){
        delegate?.imageListCellDidTapLike(cell: self)
    }
}
