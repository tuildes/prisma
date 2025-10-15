import UIKit

class GalleryViewController: UIViewController {

    // MARK: - Properties
    private let galleryView: GalleryView = GalleryView()
    var aesthetic: AestheticModel = .placeholder
    private var allReferences: [ImageModel] = []

    // MARK: - Lifecycle
    override func loadView() {
        super.loadView()
        self.view = galleryView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        allReferences = aesthetic.allReferences
        galleryView.aesthetic = aesthetic

        prepareCollectionView()
        updateEmptyState()
    }

    func prepareCollectionView() {
        galleryView.collectionView.register(
            ImageCardCell.self, forCellWithReuseIdentifier: ImageCardCell.identifier)
        galleryView.collectionView.dataSource = self
        galleryView.collectionView.delegate = self
    }

    private func updateEmptyState() {
        if allReferences.isEmpty {
            let message = "Nenhum item encontrado."
            galleryView.showEmptyState(message: message)
        } else {
            galleryView.hideEmptyState()
        }
    }

    // MARK: - Actions
    func navigateToImageDetail(with imageModel: ImageModel) {
        let imageDetailVC = ImageDetailViewController()
        imageDetailVC.imageModel = imageModel
        navigationController?.pushViewController(imageDetailVC, animated: true)
    }
}

extension GalleryViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)
        -> Int
    {
        return allReferences.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell
    {
        let cell =
            collectionView.dequeueReusableCell(
                withReuseIdentifier: ImageCardCell.identifier, for: indexPath) as! ImageCardCell
        // ✨ Usa a lista filtrada
        let dataItem = allReferences[indexPath.row]
        cell.configure(with: dataItem)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // ✨ Usa a lista filtrada
        let selectedItem = allReferences[indexPath.row]
        navigateToImageDetail(with: selectedItem)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
