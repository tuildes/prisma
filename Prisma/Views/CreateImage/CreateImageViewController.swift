import UIKit
import PhotosUI
import SwiftData

class CreateImageViewController: UIViewController {
    // MARK: - Properties
    let imageView = CreateImageView()
    let viewModel = CreateImageViewModel()

    var onCompletionAction: (() -> Void)?

    // MARK: - Lifecycle
    override func loadView() {
        super.loadView()
        view = imageView
        imageView.configure(with: viewModel)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
    }

    private func setupActions() {
        imageView.onSelectImageTapped = { [weak self] in
            self?.presentPhotoPicker()
        }

        imageView.onCloseCreation = { [weak self] in
            self?.handleCloseCreation()
        }

        viewModel.onError = { [weak self] title, message in
            self?.showErrorAlert(title: title, message: message)
        }

        viewModel.onSuccess = { [weak self] in
            self?.showSuccessAlert()
        }
    }

    private func showSuccessAlert() {
        let alert = UIAlertController(
            title: NSLocalizedString("Success", comment: ""),
            message: NSLocalizedString("Aesthetic created successfully!", comment: ""),
            preferredStyle: .alert
        )
        alert.addAction(
            UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) {
                [weak self] _ in
                self?.handleCloseCreation()
            })
        present(alert, animated: true, completion: nil)
    }

    private func showErrorAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(
            UIAlertAction(
                title: NSLocalizedString("OK", comment: ""),
                style: .default,
                handler: nil
            )
        )
        present(alert, animated: true, completion: nil)
    }

    // MARK: - Actions
    private func presentPhotoPicker() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .images

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self

        present(picker, animated: true, completion: nil)
    }

    private func handleCloseCreation() {
        navigationController?.popViewController(animated: true)
        onCompletionAction?()
    }
}

extension CreateImageViewController: PHPickerViewControllerDelegate {

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        guard let provider = results.first?.itemProvider,
            provider.canLoadObject(ofClass: UIImage.self)
        else {
            return
        }

        provider.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
            guard let self = self,
                let selectedImage = image as? UIImage,
                error == nil
            else {
                print("Erro ao carregar imagem: \(String(describing: error))")
                return
            }

            DispatchQueue.main.async {
                self.viewModel.image = selectedImage
            }
        }
    }
}
