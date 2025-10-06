import UIKit

class GalleryViewController: UIViewController {

    // MARK: - Properties
    private let galleryView: GalleryView = GalleryView()
    var aesthetic: AestheticModel = .placeholder

    // MARK: - Lifecycle
    override func loadView() {
        super.loadView()

        galleryView.aesthetic = aesthetic
        galleryView.onImageCardTapped = navigateToImageDetail

        self.view = galleryView
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
