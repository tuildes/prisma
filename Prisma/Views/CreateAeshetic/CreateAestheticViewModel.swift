import Combine
import UIKit
import SwiftData

final class CreateAestheticViewModel {

    // MARK: - View Controllers actions
    var onError: ((String, String) -> Void)?
    var onSuccess: (() -> Void)?

    // MARK: - Properties
    @Published
    var aestheticName: String = ""
    @Published
    var image: UIImage? = nil
    @Published
    var imageDescription: String = ""

    private var context: ModelContext = SwiftDataContainer.container.mainContext

    // MARK: - Initializer

    // MARK: - Actions
    func checkValidForm() throws {
        guard !aestheticName.isEmpty else {
            throw FormError.emptyField(fieldName: "Aesthetic Name")
        }

        guard image != nil else {
            throw FormError.emptyField(fieldName: "Image")
        }

        guard !imageDescription.isEmpty else {
            throw FormError.emptyField(fieldName: "Image Description")
        }
    }

    func createAesthetic() {
        do {
            try checkValidForm()
        } catch {
            onError?(NSLocalizedString("Form Error", comment: ""), error.localizedDescription)
            return
        }

        guard let image = image else { return }
        guard let image = convertImage(image: image) else { return }

        let aesthetic = AestheticModel(
            name: aestheticName,
            coverImage: image,
            imageDescription: imageDescription
        )

        context.insert(aesthetic)

        do {
            try context.save()
            print("Aesthetic created successfully")
        } catch {
            print("Error saving aesthetic: \(error)")
        }

        onSuccess?()
    }

    private func convertImage(image: UIImage) -> Data? {
        if let imageData = image.jpegData(compressionQuality: 0.8) {
            return imageData
        }

        return nil
    }
}
