import Combine
import UIKit
import SwiftData

final class CreateImageViewModel: ObservableObject {

    // MARK: - View Controllers actions
    var onError: ((String, String) -> Void)?
    var onSuccess: (() -> Void)?

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
        do {
            try checkValidForm()
        } catch {
            onError?(NSLocalizedString("Form Error", comment: ""), error.localizedDescription)
            return
        }

        guard let image = image,
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

        print("isLightMode: \(isLightMode)")

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

        onSuccess?()
    }

    func checkValidForm() throws {
        guard !title.isEmpty else {
            throw FormError.emptyField(fieldName: "Title")
        }

        guard !author.isEmpty else {
            throw FormError.emptyField(fieldName: "Author")
        }

        guard image != nil else {
            throw FormError.emptyField(fieldName: "Image")
        }

        guard !imageDescription.isEmpty else {
            throw FormError.emptyField(fieldName: "Image Description")
        }

        guard selectedAestheticID != nil else {
            throw FormError.emptyField(fieldName: "Aesthetic")
        }
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
