import Combine
import UIKit
import SwiftData

final class CreateImageViewModel: ObservableObject {
    // MARK: - Form Properties
    @Published
    var title: String = ""
    @Published
    var author: String = ""
    @Published
    var sourceURL: String?
    @Published
    var isLightMode: Bool = false
    @Published
    var image: UIImage?
    @Published
    var selectedAestheticID: UUID?
    @Published
    var imageDescription: String = ""

    // MARK: - Data Source
    @Published
    var aesthetics: [AestheticModel] = []

    private var context: ModelContext = SwiftDataContainer.container.mainContext

    // MARK: - Actions
    func fetchAesthetics() {
        do {
            let descriptor = FetchDescriptor<AestheticModel>(sortBy: [SortDescriptor(\.name)])
            aesthetics = try context.fetch(descriptor)

            if let firstAesthetic = aesthetics.first {
                selectedAestheticID = firstAesthetic.id
            }
        } catch {
            print("Failed to fetch aesthetics: \(error)")
        }
    }

    func createImage() {
        guard checkValidForm(), let image = image,
            let imageData = convertImage(image: image)
        else {
            return
        }

        let newImage = ImageModel(
            title: title,
            author: author,
            image: imageData,
            imageDescription: imageDescription,
            sourceURL: sourceURL,
            isLightMode: isLightMode
        )

        if let aestheticID = selectedAestheticID {
            newImage.aesthetic = aesthetics.first { $0.id == aestheticID }
        }

        context.insert(newImage)

        do {
            try context.save()
            print("Image saved successfully")
        } catch {
            print("Error saving image: \(error)")
        }
    }

    func checkValidForm() -> Bool {
        guard !title.isEmpty else {
            print("Invalid form: Title is empty.")
            return false
        }

        guard !author.isEmpty else {
            print("Invalid form: Author is empty.")
            return false
        }

        guard image != nil else {
            print("Invalid form: Image is required.")
            return false
        }

        guard !imageDescription.isEmpty else {
            print("Invalid form: Image description is empty.")
            return false
        }

        guard selectedAestheticID != nil else {
            print("Invalid form: Aesthetic must be selected.")
            return false
        }

        return true
    }

    private func convertImage(image: UIImage) -> Data? {
        return image.jpegData(compressionQuality: 0.8)
    }

    func verifyUrl(urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
}
