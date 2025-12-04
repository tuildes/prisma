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
