import Foundation

struct ImageModel: Identifiable {
    var id: UUID

    var imageURL: String
    var title: String
    var author: String

    init(title: String, author: String, imageURL: String) {
        self.id = UUID()

        self.imageURL = imageURL
        self.title = title
        self.author = author
    }
}

extension ImageModel {
    static let placeholder = ImageModel(
        title: "Placeholder Image",
        author: "Unknown",
        imageURL: "bk"
    )
}
