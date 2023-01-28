//
//  ViewController.swift
//  ImageFeed
//
//  Created by Роман Бойко on 11/19/22.
//

import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {
    
    // MARK: - Properties
    
    private var photosName = [String]()
    private var photos = [Photo]()
    private let ShowSingleImageSegueIdentifier = "ShowSingleImage"
    private let profileImageService = ProfileImageService.shared
    private var imagesListService = ImagesListService.shared
    
    private var imagesListViewControllerObserver: NSObjectProtocol?
    
    // MARK: - Outlets
    
    @IBOutlet weak var imagesListTableView: UITableView!
    
    
    // MARK: - Helpers
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    
    // MARK: - Life Cycle
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIBlockingProgressHUD.show()
        setNeedsStatusBarAppearanceUpdate()
        NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNontification,
                object: nil,
                queue: .main
            ){ [weak self] _ in
                guard let self = self else { return }
                self.updateTableViewAnimated()
                UIBlockingProgressHUD.dismiss()
            }
        imagesListService.fetchPhotosNextPage()
    }
    
    
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
        return imagesListService.photos.count
    }
    
    
    // This method is responsible for the actions that will be performed when tapping on a table cell.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id =  String(describing: ImagesListCell.self)
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configureCell(cell: cell, indexPath: indexPath)
        
        return cell
    }
    
    
    // This method is responsible for call fetchPhotosNextPage
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == imagesListService.photos.count {
            self.imagesListService.fetchPhotosNextPage()
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return photos[indexPath.row].size.height
    }
}



extension ImagesListViewController {
    
    func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        if oldCount != newCount {
            self.imagesListTableView.performBatchUpdates {
                var indexPaths: [IndexPath] = []
                for i in oldCount..<newCount {
                    indexPaths.append(IndexPath(row: i, section: 0))
                }
                imagesListTableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
    
    private func configureCell (cell: ImagesListCell, indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        cell.configureCurrentCellContent(photo: photo){ [weak self] in
            guard let self = self else { return }
            self.imagesListTableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}
