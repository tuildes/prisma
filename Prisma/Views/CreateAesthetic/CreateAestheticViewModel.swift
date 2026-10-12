import Foundation
import SwiftData
import UIKit

@Observable
@MainActor
final class CreateAestheticViewModel {
    var aestheticName: String = ""
    var image: UIImage?
    var imageDescription: String = ""
    var errorMessage: String?
    var didSucceed = false

    private var modelContext: ModelContext?

    func configure(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func createAesthetic() {
        errorMessage = nil

        do {
            try validate()
        } catch {
            errorMessage = error.localizedDescription
            return
        }

        guard let image,
            let imageData = image.jpegData(compressionQuality: 0.8),
            let modelContext
        else {
            errorMessage = FormError.invalidImage.localizedDescription
            return
        }

        let aesthetic = AestheticModel(
            name: aestheticName.trimmingCharacters(in: .whitespacesAndNewlines),
            coverImage: imageData,
            imageDescription: imageDescription.trimmingCharacters(in: .whitespacesAndNewlines)
        )

        modelContext.insert(aesthetic)

        do {
            try modelContext.save()
            didSucceed = true
        } catch {
            errorMessage = "Could not save aesthetic."
        }
    }

    private func validate() throws {
        let name = aestheticName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !name.isEmpty else {
            throw FormError.emptyField(fieldName: "Aesthetic Name")
        }
        guard name.count <= 30 else {
            throw FormError.maxLengthExceeded(fieldName: "Aesthetic Name", maxLength: 30)
        }
        guard image != nil else {
            throw FormError.emptyField(fieldName: "Image")
        }
        guard !imageDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw FormError.emptyField(fieldName: "Image Description")
        }
    }
}
