import UIKit

class ImageDetailViewController: UIViewController {
    // MARK: - Properties
    private var imageDetailView: ImageDetailView = ImageDetailView()

    // MARK: - Lifecycle
    override func loadView() {
        view = imageDetailView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
