import UIKit

class GalleryViewController: UIViewController {

    // MARK: - Properties
    private let galleryView: GalleryView = GalleryView()

    // MARK: - Lifecycle
    override func loadView() {
        super.loadView()
        self.view = galleryView
        self.galleryView.onImageCardTapped = navigateToImageDetail
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Actions
    func navigateToImageDetail() {
        let imageDetailVC = ImageDetailViewController()
        navigationController?.pushViewController(imageDetailVC, animated: true)
    }
}
