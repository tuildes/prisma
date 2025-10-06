import Foundation

enum ImageType {
    case image
    case video
    case figma

    func description() -> String {
        switch self {
        case .image:
            return "Apenas imagem"
        case .video:
            return "Apenas video"
        case .figma:
            return "Aprendizados"
        }
    }
}

struct ImageModel: Identifiable {
    var id: UUID

    var imageURL: String
    var title: String

    var author: String
    var sourceURL: String?

    var type: ImageType

    init(
        title: String, author: String, imageURL: String, sourceURL: String? = nil
    ) {
        self.id = UUID()

        self.type = .image
        self.imageURL = imageURL
        self.title = title
        self.author = author
        self.sourceURL = sourceURL
    }
}

extension ImageModel {
    static let placeholder = ImageModel(
        title: "Image",
        author: "Unknown",
        imageURL: "bk"
    )
}
