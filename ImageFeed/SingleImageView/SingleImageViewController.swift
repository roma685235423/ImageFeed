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
        }
    }
    
    //MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
}
