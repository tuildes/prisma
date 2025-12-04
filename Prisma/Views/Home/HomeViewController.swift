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

        homeView.headerView.onCreateAesthetic = { [weak self] in
            self?.navigateToCreateAestheticView()
        }

        homeView.headerView.onCreateImage = { [weak self] in
            self?.navigateToCreateImageView()
        }
    }

    func navigateToGalleryView() {
        guard viewModel.canNavigateToGallery else { return }
        guard let actualAesthetic = viewModel.getCurrentAesthetic() else { return }

        let galleryVC = GalleryViewController()
        galleryVC.aesthetic = actualAesthetic

        navigationController?.pushViewController(galleryVC, animated: true)
    }

    func navigateToCreateAestheticView() {
        let createAestheticVC = CreateAestheticViewController()
        navigationController?.pushViewController(createAestheticVC, animated: true)
        createAestheticVC.onCompletionAction = { [weak self] in
            self?.viewModel.loadAesthetics()
            self?.updatePolaroidViews()
            self?.homeView.setupEmptyState(isEmpty: self?.viewModel.isEmptyState ?? true)
        }
    }

    func navigateToCreateImageView() {
        let createImageVC = CreateImageViewController()
        navigationController?.pushViewController(createImageVC, animated: true)
        createImageVC.onCompletionAction = { [weak self] in
            self?.viewModel.loadAesthetics()
            self?.updatePolaroidViews()
        }
    }

    private func updatePolaroidViews() {
        if viewModel.totalAesthetics == 1 {
            guard let onlyAesthetic = viewModel.getCurrentAesthetic() else { return }
            homeView.configureCards(topAesthetic: onlyAesthetic, bottomAesthetic: onlyAesthetic)
            return
        }

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
