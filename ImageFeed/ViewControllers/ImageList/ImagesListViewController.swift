import UIKit
import Kingfisher

protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListPresenterProtocol? { get set }
        //func showDefaultAlert()
    func updateTableViewAnimated()
}

final class ImagesListViewController: UIViewController & ImagesListViewControllerProtocol{
    
    var presenter: ImagesListPresenterProtocol?
    // MARK: - Properties
    //----------------------------------
    //private var photos = [Photo]()
    //----------------------------------
    private let ShowSingleImageSegueIdentifier = "ShowSingleImage"
    //----------------------------------
    //var imagesListService = ImagesListService.shared
    //----------------------------------
    static let shared = ImagesListViewController()
    
    // MARK: - Layout
    @IBOutlet weak var imagesListTableView: UITableView!
    
    
    // MARK: - Life Cycle
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\n✅\nImagesListViewController\n✅ ")
        presenter?.view = self
        presenter?.viewDidLoad()
        print("\n‼️\nPresenter is : \(presenter)\n‼️\n")
    }
    
    
    //MARK: - Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowSingleImageSegueIdentifier {
            let vc = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            //vc.largeImageUrl = imagesListService.getLargeImageCellURL(indexPath: indexPath)
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}



// MARK: - Extensions
extension ImagesListViewController: UITableViewDelegate {
    
    // This method is responsible for the action that is performed when tapping on a table cell.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: ShowSingleImageSegueIdentifier, sender: indexPath)
    }
}



extension ImagesListViewController: UITableViewDataSource {
    // This method is responsible for determining the number of cells in the table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //----------------------------------
        10
        //imagesListService.photos.count
        //----------------------------------
    }
    
    
    // This method is responsible for the actions that will be performed when tapping on a table cell.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id =  String(describing: ImagesListCell.self)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as? ImagesListCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        self.configureCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    
    // This method is responsible for call fetchPhotosNextPage
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let presenter = presenter else { return }
        //----------------------------------
        //if indexPath.row + 1 == imagesListService.photos.count {
        //----------------------------------
        presenter.isNeedToFetchNextpage(actualRow: indexPath.row)
            //----------------------------------
            //self.imagesListService.fetchPhotosNextPage()
            //----------------------------------
        //}
    }
}



extension ImagesListViewController {
    func updateTableViewAnimated() {
        //----------------------------------
        //let oldCount = photos.count
        //let newCount = imagesListService.photos.count
        //photos = imagesListService.photos
        //if oldCount != newCount {
        guard let photosCount = presenter?.photosInServiceAndPhotosArrayNotEqual() else { return }
        if photosCount.oldCount != photosCount.newCount {
            //----------------------------------
            self.imagesListTableView.performBatchUpdates {
                var indexPaths: [IndexPath] = []
                for i in photosCount.oldCount..<photosCount.newCount {
                    indexPaths.append(IndexPath(row: i, section: 0))
                }
                imagesListTableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
    
   // func showDefaultAlert() {
   //     self.showDefaultAlert()
   //     return
   // }
    
    //
    private func configureCell(cell: ImagesListCell, indexPath: IndexPath) {
        //----------------------------------
        let gradient = CAGradientLayer()
        //----------------------------------
        //let photo = photos[indexPath.row]
        guard let photo = presenter?.getPhotoFromArray(index: indexPath.row) else { return }
        let date = photo.createdAt
        guard let createdAt = date?.stringFromDate else { return }
        cell.configureCurrentCellContent(photo: photo, createdAt: createdAt)
        cell.imagesListCellImage.configureGragient(
            gradient: gradient,
            cornerRadius: 16,
            size: cell.imagesListCellImage.frame.size,
            position: .bottom
        )
        //----------------------------------
        guard let thumbImageUrl = URL(string: photo.thumbImageURL),
              let placeholderImage = UIImage(named: "card") else {
            return
        }
        //----------------------------------
        cell.imagesListCellImage.kf.setImage(
            with: thumbImageUrl,
            placeholder: placeholderImage
        ) { [weak self] _ in
            guard let self = self else { return }
            cell.imagesListCellImage.removeGradient(gradient: gradient)
            self.imagesListTableView.reloadRows(at: [indexPath], with: .automatic)
        }
        //----------------------------------
    }
    
    
   // func cleanPhotos(){
   //     photos = []
   // }
}



extension ImagesListViewController: ImagesListCellDelegate{
    
    func imageListCellDidTapLike(cell: ImagesListCell) {
        guard let indexPath = imagesListTableView.indexPath(for: cell) else {return}
        //let photo = photos[indexPath.row]
        guard let photo = presenter?.getPhotoFromArray(index: indexPath.row) else { return }
        UIBlockingProgressHUD.show()
        presenter?.changeLikeInPhotosService(photo: photo, cell: cell, index: indexPath.row)
//        imagesListService.changeLike(photoId: photo.id, isLike: photo.isLiked) { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .success:
//                DispatchQueue.main.async {
//                    //self.photos[indexPath.row].isLiked.toggle()
//                    self.presenter?.changeLike(index: indexPath.row)
//                    //cell.changeLikeButtonImage(isLiked: self.photos[indexPath.row].isLiked)
//                    cell.changeLikeButtonImage(isLiked: presenter?.getCurrentPhotoLike(index: indexPath.row)!)
//                    UIBlockingProgressHUD.dismiss()
//                }
//            case.failure:
//                self.showDefaultAlertPresenter()
//                UIBlockingProgressHUD.dismiss()
//                return
//            }
//        }
    }
}
