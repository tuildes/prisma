import Foundation
import SwiftData

@Model
final class ImageModel: Identifiable {
    @Attribute(.unique)
    var id: UUID

    var image: Data
    var imageDescription: String
    var title: String
    var author: String
    var sourceURL: String?
    var isLightMode: Bool

    var aesthetic: AestheticModel?

    init(
        title: String,
        author: String,
        image: Data,
        imageDescription: String,
        sourceURL: String? = nil,
        isLightMode: Bool = false
    ) {
        self.id = UUID()
        self.image = image
        self.imageDescription = imageDescription
        self.isLightMode = isLightMode
        self.title = title
        self.author = author
        self.sourceURL = sourceURL
    }
}

extension ImageModel {
    static let placeholder = ImageModel(
        title: "Image",
        author: "Unknown",
        image: Data(),
        imageDescription: "A beautiful scenery",
        sourceURL: "https://example.com",
        isLightMode: false
    )
}
