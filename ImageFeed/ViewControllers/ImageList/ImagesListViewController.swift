import UIKit
import Kingfisher

protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListPresenterProtocol? { get set }
    func showDefaultAlert()
    func updateTableViewAnimated()
}

final class ImagesListViewController: UIViewController & ImagesListViewControllerProtocol{
    // MARK: - Properties
    private let ShowSingleImageSegueIdentifier = "ShowSingleImage"
    var presenter: ImagesListPresenterProtocol?
    
    // MARK: - Layout
    @IBOutlet weak var imagesListTableView: UITableView!
    
    
    // MARK: - Life Cycle
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.view = self
        presenter?.viewDidLoad()
    }
    
    
    //MARK: - Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowSingleImageSegueIdentifier {
            let vc = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            vc.largeImageUrl = presenter?.getLargeImageCellURL(indexPath: indexPath)
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
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    // This method is responsible for determining the number of cells in the table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let photosCount = presenter?.photosInServiceAndPhotosArrayNotEqual() else { fatalError("Presenter not exist") }
        return photosCount.servicePhotosCount
    }
    
    // This method is responsible for the actions that will be performed when tapping on a table cell.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id =  String(describing: ImagesListCell.self)
        guard let cell = imagesListTableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as? ImagesListCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        self.configureCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    // This method is responsible for call fetchPhotosNextPage
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let presenter = presenter else { return }
        presenter.isNeedToFetchNextPage(actualRow: indexPath.row)
    }
}


extension ImagesListViewController: ImagesListCellDelegate{
    func imageListCellDidTapLike(cell: ImagesListCell) {
        guard let indexPath = imagesListTableView.indexPath(for: cell) else {return}
        guard let photo = presenter?.getPhotoFromArray(index: indexPath.row) else { return }
        UIBlockingProgressHUD.show()
        presenter?.changeLikeInPhotosService(photo: photo, cell: cell, index: indexPath.row)
    }
}


extension ImagesListViewController {
    func showDefaultAlert() {
        self.showDefaultAlertPresenter()
    }
    
    func updateTableViewAnimated() {
        guard let photosCount = presenter?.photosInServiceAndPhotosArrayNotEqual() else { return }
        if photosCount.localPhotosCount != photosCount.servicePhotosCount {
            self.imagesListTableView.performBatchUpdates {
                var indexPaths: [IndexPath] = []
                for i in photosCount.localPhotosCount..<photosCount.servicePhotosCount {
                    indexPaths.append(IndexPath(row: i, section: 0))
                }
                imagesListTableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
    
    private func configureCell(cell: ImagesListCell, indexPath: IndexPath) {
        guard let photo = self.presenter?.getPhotoFromArray(index: indexPath.row) else { return }
        let date = photo.createdAt
        guard let createdAt = date?.stringFromDate else { return }
        cell.configureCurrentCellContent(photo: photo, createdAt: createdAt)
        guard let thumbImageUrl = URL(string: photo.thumbImageURL),
              let placeholderImage = UIImage(named: "card") else {
            return
        }
        cell.imagesListCellImage.kf.setImage(
            with: thumbImageUrl,
            placeholder: placeholderImage
        ) { [weak self] _ in
            guard let self = self else { return }
            self.imagesListTableView.reloadRows(at: [indexPath], with: .automatic)
            cell.removeimagesListCellImageGradient()
            cell.prepareForReuse()
        }
        cell.resizeImageGradient()
    }
}
