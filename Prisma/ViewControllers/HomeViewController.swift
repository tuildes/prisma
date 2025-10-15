import UIKit

class HomeViewController: UIViewController {

    // MARK: - Properties
    private let homeView: HomeView = HomeView()
    private let allEsthetics: [AestheticModel] = AestheticModel.sampleData

    private var currentEstheticIndex: Int = 0 {
        didSet {
            updatePolaroidViews()
        }
    }

    // MARK: - Lifecycle
    override func loadView() {
        super.loadView()
        self.view = homeView

        homeView.onAestheticButtonTapped = { [weak self] in
            self?.navigateToGalleryView()
        }

        homeView._onNextTapped = { [weak self] in
            self?.onNextTapped()
        }

        homeView._onPreviousTapped = { [weak self] in
            self?.onPreviousTapped()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updatePolaroidViews()
    }

    // MARK: - Functions
    func navigateToGalleryView() {
        guard allEsthetics[currentEstheticIndex].allReferences.count > 0 else { return }

        let galleryVC = GalleryViewController()
        galleryVC.aesthetic = allEsthetics[currentEstheticIndex]

        navigationController?.pushViewController(galleryVC, animated: true)
    }

    private func updatePolaroidViews() {
        let topIndex = currentEstheticIndex
        let bottomIndex = (currentEstheticIndex + 1) % allEsthetics.count

        let topAesthetic = allEsthetics[topIndex]
        let bottomAesthetic = allEsthetics[bottomIndex]

        homeView.configureCards(topAesthetic: topAesthetic, bottomAesthetic: bottomAesthetic)
    }

    private func onNextTapped() {
        currentEstheticIndex = (currentEstheticIndex + 1) % allEsthetics.count
    }

    private func onPreviousTapped() {
        currentEstheticIndex = (currentEstheticIndex - 1 + allEsthetics.count) % allEsthetics.count
    }
}
