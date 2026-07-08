import UIKit
import SwiftData

class GalleryViewController: UIViewController {

    // MARK: - Properties
    private let galleryView: GalleryView = GalleryView()
    var aesthetic: AestheticModel = .placeholder
    private var allReferences: [ImageModel] = []
    var reloadDataInPreviousViewController: (() -> Void)?

    // MARK: - Lifecycle
    override func loadView() {
        super.loadView()
        self.view = galleryView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        allReferences = aesthetic.allReferences ?? []
        galleryView.aesthetic = aesthetic

        prepareCollectionView()
        updateEmptyState()
        setupToolbar()
    }

    func prepareCollectionView() {
        galleryView.collectionView.register(
            ImageCardCell.self,
            forCellWithReuseIdentifier: ImageCardCell.identifier
        )
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

    private func setupToolbar() {
        let deleteButton = UIBarButtonItem(
            barButtonSystemItem: .trash,
            target: self,
            action: #selector(deleteButtonTapped)
        )
        navigationItem.rightBarButtonItem = deleteButton

        navigationController?.setToolbarHidden(false, animated: false)
    }

    // MARK: - Actions
    func navigateToImageDetail(with imageModel: ImageModel) {
        let imageDetailVC = ImageDetailViewController()
        imageDetailVC.imageModel = imageModel
        navigationController?.pushViewController(imageDetailVC, animated: true)
        imageDetailVC.reloadDataInPreviousViewController = { [weak self] image in
            self?.reloadDeleteImage(image)
        }
    }

    @objc
    func deleteButtonTapped() {
        let alert = UIAlertController(
            title: "Delete Aesthetic",
            message:
                "Are you sure you want to delete this aesthetic? This action cannot be undone.",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(
            UIAlertAction(
                title: "Delete", style: .destructive,
                handler: { [weak self] _ in
                    self?.deleteAesthetic()
                    self?.navigateBackAndReloadData()
                }))

        present(alert, animated: true, completion: nil)
    }

    func navigateBackAndReloadData() {
        navigationController?.popViewController(animated: true)
        reloadDataInPreviousViewController?()
    }

    func reloadDeleteImage(_ image: ImageModel) {
        allReferences.removeAll { $0.id == image.id }
        galleryView.collectionView.reloadData()
        updateEmptyState()
        reloadDataInPreviousViewController?()
    }

    func deleteAesthetic() {
        let context: ModelContext = SwiftDataContainer.container.mainContext

        print("Deleting aesthetic: \(aesthetic.name)")

        context.delete(aesthetic)

        do {
            try context.save()
        } catch {
            print("Failed to delete aesthetic: \(error)")
        }
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
                withReuseIdentifier: ImageCardCell.identifier,
                for: indexPath
            ) as! ImageCardCell

        let dataItem = allReferences[indexPath.row]
        cell.configure(with: dataItem)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = allReferences[indexPath.row]
        navigateToImageDetail(with: selectedItem)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
