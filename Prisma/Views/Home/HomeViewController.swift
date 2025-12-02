import UIKit

class HomeViewController: UIViewController {

    // MARK: - Properties
    private let homeView: HomeView = HomeView()
    private let viewModel: HomeViewModel = HomeViewModel()

    // MARK: - Lifecycle
    override func loadView() {
        super.loadView()
        self.view = homeView

        setupActions()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        homeView.setupEmptyState(isEmpty: viewModel.isEmptyState)
        updatePolaroidViews()
    }

    // MARK: - Functions
    func setupActions() {
        homeView.tappedAestheticAction = { [weak self] in
            self?.navigateToGalleryView()
        }

        homeView.nextAestheticAction = { [weak self] in
            self?.onNextTapped()
        }

        homeView.previousAestheticAction = { [weak self] in
            self?.onPreviousTapped()
        }
    }

    func navigateToGalleryView() {
        // Verificar existencia
        guard viewModel.canNavigateToGallery else { return }
        guard let actualAesthetic = viewModel.getCurrentAesthetic() else { return }

        let galleryVC = GalleryViewController()
        galleryVC.aesthetic = actualAesthetic

        navigationController?.pushViewController(galleryVC, animated: true)
    }

    private func updatePolaroidViews() {
        guard let topAesthetic = viewModel.getCurrentAesthetic(),
            let bottomAesthetic = viewModel.getNextAesthetic()
        else {
            return
        }

        homeView.configureCards(topAesthetic: topAesthetic, bottomAesthetic: bottomAesthetic)
    }

    private func onNextTapped() {
        viewModel.nextIndex()
        updatePolaroidViews()
    }

    private func onPreviousTapped() {
        viewModel.previousIndex()
        updatePolaroidViews()
    }
}
