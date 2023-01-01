//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Роман Бойко on 12/5/22.
//

import UIKit


class SingleImageViewController: UIViewController {
    
    // MARK: - Properties
    
    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
            rescaleAndCenterInScrollView(image: image)
        }
    }
    
    //MARK: - Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 1.25
        rescaleAndCenterInScrollView(image: image)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    
    //MARK: - Actions
    
    @IBAction func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapShareButton(_ sender: Any) {
        guard let unwrapImage = image else { return }
        let shareMenu = UIActivityViewController(
            activityItems: [unwrapImage],
            applicationActivities: nil
        )
        present(shareMenu, animated: false)
        
    }
    
    
    
    
    private func rescaleAndCenterInScrollView(image: UIImage) {
        
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        
        view.layoutIfNeeded()
        
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        
        // Width scale
        let vScale = visibleRectSize.width / imageSize.width
        
        // Height scale
        let hScale = visibleRectSize.height / imageSize.height
        
        let theoreticalScale = max(hScale, vScale)
        let scale = min(maxZoomScale, max(minZoomScale, theoreticalScale))
        
        self.scrollView.setZoomScale(scale, animated: false)
        
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
}


extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        rescaleAndCenterInScrollView(image: image)
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        rescaleAndCenterInScrollView(image: image)
    }
}
