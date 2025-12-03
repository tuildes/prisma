import UIKit

class ImageDetailViewController: UIViewController {
    // MARK: - Properties
    private let imageDetailView: ImageDetailView = ImageDetailView()
    private let viewModel: ImageDetailViewModel = ImageDetailViewModel()
    var imageModel: ImageModel?

    // MARK: - Lifecycle
    override func loadView() {
        super.loadView()
        view = imageDetailView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let imageModel = imageModel else {
            fatalError("ImageDetailViewController initialized without ImageModel")
        }

        imageDetailView.configure(with: imageModel)
        viewModel.configure(with: imageModel)

        setupActions()
    }

    private func setupActions() {
        imageDetailView.onOpenImageViewTapped = { [weak self] image in
            self?.presentFullScreenImage(image: image)
        }

        imageDetailView.onURLButtonTapped = { [weak self] in
            self?.viewModel.openURL()
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
