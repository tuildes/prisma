import UIKit
import SwiftData

class ImageDetailViewController: UIViewController {
    // MARK: - Properties
    private let imageDetailView: ImageDetailView = ImageDetailView()
    private let viewModel: ImageDetailViewModel = ImageDetailViewModel()
    var imageModel: ImageModel?

    var reloadDataInPreviousViewController: ((_ image: ImageModel) -> Void)?

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }

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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
        setupToolbar()
    }

    private func setupActions() {
        imageDetailView.onOpenImageViewTapped = { [weak self] image in
            self?.presentFullScreenImage(
                image: image,
                imageDescription: self?.imageModel?.imageDescription
            )
        }

        imageDetailView.onURLButtonTapped = { [weak self] in
            self?.viewModel.openURL()
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
    private func presentFullScreenImage(image: UIImage?, imageDescription: String?) {
        let fullScreenVC = FullScreenImageViewController()

        fullScreenVC.image = image
        fullScreenVC.imageDescription = imageDescription
        fullScreenVC.modalPresentationStyle = .overFullScreen
        fullScreenVC.modalTransitionStyle = .crossDissolve

        present(fullScreenVC, animated: true, completion: nil)
    }

    @objc
    func deleteButtonTapped() {
        let alert = UIAlertController(
            title: "Delete Reference",
            message:
                "Are you sure you want to delete this reference? This action cannot be undone.",
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
        guard let imageModel = imageModel else { return }

        navigationController?.popViewController(animated: true)
        reloadDataInPreviousViewController?(imageModel)
    }

    func deleteAesthetic() {
        guard let imageModel = imageModel else { return }

        let context: ModelContext = SwiftDataContainer.container.mainContext

        context.delete(imageModel)

        do {
            try context.save()
        } catch {
            print("Failed to delete image: \(error)")
        }
    }
}
