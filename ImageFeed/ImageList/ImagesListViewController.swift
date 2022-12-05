//
//  ViewController.swift
//  ImageFeed
//
//  Created by Роман Бойко on 11/19/22.
//

import UIKit

class ImagesListViewController: UIViewController {
    
    // MARK: - Properties
    private var photosName = [String]()
    
    // MARK: - Outlets
    @IBOutlet weak var imagesListTableView: UITableView! {
        didSet {
            let id =  String(describing: ImagesListCell.self)
            imagesListTableView.register(UINib(nibName: id, bundle: nil), forCellReuseIdentifier: id)
        }
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photosName = Array(0..<20).map{"\($0)"}
    }
    
    // MARK: - Helpers
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
}



// MARK: - Extensions
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
        
        let id =  String(describing: ImagesListCell.self)
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as? ImagesListCell else {
            return UITableViewCell()
        }
        
        let image = UIImage(named: photosName[indexPath.row])
        let date = dateFormatter.string(from: Date())
        let isLikedImage = indexPath.row % 2 == 1
        
        cell.configureCell(image: image, date: date, isLiked: isLikedImage)
        //configCell(for: imageListCell, with: indexPath)
        return cell
        
    }
    
}



/*extension ImagesListViewController {
    

    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            print("Image \(photosName[indexPath.row]) not found ❌")
            return
        }
        
    }
    
}
*/
