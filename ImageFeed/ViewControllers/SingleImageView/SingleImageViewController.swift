import UIKit
import Kingfisher



final class SingleImageViewController: UIViewController {
    // MARK: - Properties
    var largeImageUrl: URL?
    
    //MARK: - Layout
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    // MARK: - Life Cycle
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        downloadLargeImage()
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 1.25
    }
    
    
    //MARK: - Actions
    @IBAction func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapShareButton(_ sender: Any) {
        guard let unwrapImage = imageView.image else { return }
        let shareMenu = UIActivityViewController(
            activityItems: [unwrapImage],
            applicationActivities: nil
        )
        present(shareMenu, animated: false)
        
    }
    
    
    //MARK: - Methods
    private func rescaleAndCenterInScrollView(image: UIImage) {
        DispatchQueue.main.async {
            let minZoomScale = self.scrollView.minimumZoomScale
            let maxZoomScale = self.scrollView.maximumZoomScale
            self.view.layoutIfNeeded()
            let visibleRectSize = self.scrollView.bounds.size
            let imageSize = image.size
            // Width scale
            let vScale = visibleRectSize.width / imageSize.width
            // Height scale
            let hScale = visibleRectSize.height / imageSize.height
            let theoreticalScale = max(hScale, vScale)
            let scale = min(maxZoomScale, max(minZoomScale, theoreticalScale))
            self.scrollView.setZoomScale(scale, animated: false)
            self.scrollView.layoutIfNeeded()
            let newContentSize = self.scrollView.contentSize
            
            let x = (newContentSize.width - visibleRectSize.width) / 2
            let y = (newContentSize.height - visibleRectSize.height) / 2
            self.scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
        }
    }
    
    
    func downloadLargeImage() {
        UIBlockingProgressHUD.show()
        DispatchQueue.main.async {
            self.imageView.kf.indicatorType = .activity
            self.imageView.kf.setImage(
                with: self.largeImageUrl!,
                options: [.cacheSerializer(FormatIndicatedCacheSerializer.png)]
            ){ [weak self] result in
                guard let self = self else { return }
                switch result{
                case .success(let imageResult):
                    UIBlockingProgressHUD.dismiss()
                    self.rescaleAndCenterInScrollView(image: imageResult.image)
                case .failure:
                    UIBlockingProgressHUD.dismiss()
                    self.showError()
                    return
                }
            }
        }
    }
}



//MARK: - Extensions
extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        rescaleAndCenterInScrollView(image: (self.imageView.image ?? UIImage(named: "card"))!)
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        rescaleAndCenterInScrollView(image: (self.imageView.image ?? UIImage(named: "card"))!)
    }
}


extension SingleImageViewController {
    func showError(){
        let alertController = UIAlertController(
            title: "Что-то пошло не так",
            message: "Попробовать ещё раз?",
            preferredStyle: .alert
        )
        let cancelAction = UIAlertAction(title: "Не надо", style: .default)
        let repeatAction = UIAlertAction(title: "Повторить", style: .cancel) { [weak self] _ in
            self?.downloadLargeImage()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(repeatAction)
        present(alertController, animated: true)
    }
}

