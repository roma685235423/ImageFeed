//
//  ViewController.swift
//  ImageFeed
//
//  Created by Роман Бойко on 11/19/22.
//

import UIKit

final class ImagesListViewController: UIViewController {
    
    // MARK: - Properties
    
    private var photosName = [String]()
    private let ShowSingleImageSegueIdentifier = "ShowSingleImage"
    private let profileImageService = ProfileImageService.shared
    private var imageListService = ImagesListService.shared
    var i: Int = 0
    
    // MARK: - Outlets
    
    @IBOutlet weak var imagesListTableView: UITableView!
    
    
    // MARK: - Life Cycle
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        photosName = Array(0..<20).map{"\($0)"}
    }
    
    
    // MARK: - Helpers
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    
    //MARK: - Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == ShowSingleImageSegueIdentifier {
            let viewController = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            let image = UIImage(named: photosName[indexPath.row])
            viewController.image = image
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}



// MARK: - Extensions

extension ImagesListViewController: UITableViewDelegate {
    // This method is responsible for the action that is performed when tapping on a table cell.
    func tableView (_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: ShowSingleImageSegueIdentifier, sender: indexPath)
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
        
        return cell
    }
    
    // This method is responsible for call fetchPhotosNextPage
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("\n❤️💙\nindexPath.row: \(indexPath.row)\n")
        if indexPath.row == imageListService.photos.count {
            DispatchQueue.main.async {
                self.i = self.i + 1
                print("\n🟢\nImagesListService.fetchPhotosNextPage() CALLED\n\(self.i) Times‼️")
                self.imageListService.fetchPhotosNextPage()
            }
        }
    }
}
