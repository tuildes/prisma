import UIKit

class ImageDetailViewController: UIViewController {
    // MARK: - Properties
    private let imageDetailView: ImageDetailView = ImageDetailView()
    var imageModel: ImageModel?

    // MARK: - Lifecycle
    override func loadView() {
        super.loadView()
        view = imageDetailView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let model = imageModel {
            imageDetailView.configure(with: model)
        }

        imageDetailView.onOpenImageViewTapped = { [weak self] image in
            self?.presentFullScreenImage(image: image)
        }
    }

    // MARK: - Actions
    private func presentFullScreenImage(image: UIImage?) {
        let fullScreenVC = FullScreenImageViewController()
        fullScreenVC.image = image
        fullScreenVC.modalPresentationStyle = .overFullScreen
        fullScreenVC.modalTransitionStyle = .crossDissolve
        present(fullScreenVC, animated: true, completion: nil)
    }
}
