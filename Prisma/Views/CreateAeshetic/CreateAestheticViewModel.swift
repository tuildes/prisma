import Combine
import UIKit
import SwiftData

final class CreateAestheticViewModel {
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
    func checkValidForm() -> Bool {
        guard !aestheticName.isEmpty else {
            print("Invalid form: Aesthetic name is empty")
            return false
        }

        guard image != nil else {
            print("Invalid form: Image is not selected")
            return false
        }

        guard !imageDescription.isEmpty else {
            print("Invalid form: Image description is empty")
            return false
        }

        return true
    }

    func createAesthetic() {
        // Verificaoes antes de criar a esttica
        guard checkValidForm() else {
            return
        }

        guard let image = image else {
            return
        }

        guard let image = convertImage(image: image) else {
            return
        }

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
    }

    private func convertImage(image: UIImage) -> Data? {
        if let imageData = image.jpegData(compressionQuality: 0.8) {
            return imageData
        }

        return nil
    }
}
