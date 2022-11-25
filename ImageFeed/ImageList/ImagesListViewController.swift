//
//  ViewController.swift
//  ImageFeed
//
//  Created by Роман Бойко on 11/19/22.
//

import UIKit
//
class ImagesListViewController: UIViewController {
    
    private var photosName = [String]()
    @IBOutlet weak var imageListTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        photosName = Array(0..<20).map{"\($0)"}
    }
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
}



extension ImagesListViewController: UITableViewDelegate {
    
    // This method is responsible for the action that is performed when tapping on a table cell.
    func tableView (_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}



extension ImagesListViewController: UITableViewDataSource {
    
    // This method is responsible for determining the number of cells in the table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosName.count
    }
    
    // This method is responsible for the actions that will be performed when tapping on a table cell.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reusedIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
    
}



extension ImagesListViewController {
    
    // This method is responsible for configutation of cell
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            print("Image \(photosName[indexPath.row]) not found ❌")
            return
        }
        
        cell.imagesListCellImage.image = image
        cell.imagesListCellTextLabel.text = dateFormatter.string(from: Date())
        
        let isLikedImage = indexPath.row == 0 || indexPath.row % 2 == 0
        let likeButtonImage = isLikedImage ? UIImage(named: "like_button_on"): UIImage(named: "like_button_off")
        cell.imagesListCellLikeButton.setImage(likeButtonImage, for: .normal)
    }
    
}
