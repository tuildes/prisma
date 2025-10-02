import UIKit

class HomeViewController: UIViewController {

    // MARK: - Properties
    private let homeView: HomeView = HomeView()

    // MARK: - Lifecycle
    override func loadView() {
        super.loadView()
        self.view = homeView

        homeView.onAestheticButtonTapped = { [weak self] in
            self?.navigateToGalleryView()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Functions
    func navigateToGalleryView() {
        let galleryVC = GalleryViewController()
        navigationController?.pushViewController(galleryVC, animated: true)
    }
}
