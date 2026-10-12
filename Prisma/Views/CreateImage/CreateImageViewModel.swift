import Foundation
import SwiftData
import UIKit

@Observable
@MainActor
final class CreateImageViewModel {
    var title: String = ""
    var author: String = ""
    var sourceURL: String = ""
    var isLightMode: Bool = false
    var image: UIImage?
    var imageDescription: String = ""
    var selectedAestheticID: UUID?
    var aesthetics: [AestheticModel] = []
    var errorMessage: String?
    var didSucceed = false

    private let preselectedAestheticID: UUID?
    private var modelContext: ModelContext?

    init(preselectedAestheticID: UUID? = nil) {
        self.preselectedAestheticID = preselectedAestheticID
        self.selectedAestheticID = preselectedAestheticID
    }

    func configure(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchAesthetics()
    }

    func fetchAesthetics() {
        guard let modelContext else { return }

        do {
            let descriptor = FetchDescriptor<AestheticModel>(
                sortBy: [SortDescriptor(\.name)]
            )
            aesthetics = try modelContext.fetch(descriptor)

            if selectedAestheticID == nil {
                selectedAestheticID = aesthetics.first?.id
            }
        } catch {
            print("Failed to fetch aesthetics: \(error)")
        }
    }

    var selectedAestheticName: String {
        aesthetics.first { $0.id == selectedAestheticID }?.name ?? "Select Aesthetic"
    }

    func createImage() {
        errorMessage = nil

        do {
            try validate()
        } catch {
            errorMessage = error.localizedDescription
            return
        }

        guard let image,
            let imageData = image.jpegData(compressionQuality: 0.8),
            let modelContext,
            let selectedAestheticID,
            let aesthetic = aesthetics.first(where: { $0.id == selectedAestheticID })
        else {
            errorMessage = FormError.invalidImage.localizedDescription
            return
        }

        let trimmedURL = sourceURL.trimmingCharacters(in: .whitespacesAndNewlines)
        let newImage = ImageModel(
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            author: author.trimmingCharacters(in: .whitespacesAndNewlines),
            image: imageData,
            imageDescription: imageDescription.trimmingCharacters(in: .whitespacesAndNewlines),
            sourceURL: trimmedURL.isEmpty ? nil : trimmedURL,
            isLightMode: isLightMode
        )

        modelContext.insert(newImage)
        // Keep every image already on this aesthetic. Assigning `image.aesthetic`
        // replaces that collection and cascade-deletes the previous references.
        var references = aesthetic.allReferences ?? []
        references.append(newImage)
        aesthetic.allReferences = references

        do {
            try modelContext.save()
            didSucceed = true
        } catch {
            print("Could not save image: \(error)")
            errorMessage = "Could not save image."
        }
    }

    private func validate() throws {
        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw FormError.emptyField(fieldName: "Title")
        }
        guard !author.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw FormError.emptyField(fieldName: "Author")
        }
        guard image != nil else {
            throw FormError.emptyField(fieldName: "Image")
        }
        guard !imageDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw FormError.emptyField(fieldName: "Image Description")
        }
        guard selectedAestheticID != nil else {
            throw FormError.emptyField(fieldName: "Aesthetic")
        }
    }
}
