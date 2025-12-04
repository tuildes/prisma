import UIKit

// Essa tela não tem divisão entre View e ViewController
class FullScreenImageViewController: UIViewController {

    // MARK: - Properties
    var image: UIImage?
    private var fullScreenImageView: FullScreenImageView = FullScreenImageView()

    // MARK: - Setup
    override func viewDidLoad() {
        super.viewDidLoad()

        view = fullScreenImageView
        fullScreenImageView.configure(with: image)

        setupActions()
    }

    private func setupActions() {
        fullScreenImageView.onDismissFullScreen = { [weak self] in
            self?.dismissFullScreen()
        }
    }

    // MARK: - Actions
    private func dismissFullScreen() {
        dismiss(animated: true, completion: nil)
    }
}
