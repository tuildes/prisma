import Foundation
import SwiftData

@Model
final class AestheticModel: Identifiable {
    @Attribute(.unique)
    var id: UUID

    var name: String

    @Relationship(deleteRule: .nullify, inverse: \ImageModel.aesthetic)
    var allReferences: [ImageModel]?

    @Attribute(.externalStorage)
    var coverImage: Data

    var imageDescription: String

    var totalReferences: Int {
        return allReferences?.count ?? 0
    }

    init(name: String, coverImage: Data, imageDescription: String) {
        self.id = UUID()
        self.name = name
        self.allReferences = []
        self.coverImage = coverImage
        self.imageDescription = imageDescription
    }
}

extension AestheticModel {
    static let placeholder = AestheticModel(
        name: "Placeholder",
        coverImage: Data(),
        imageDescription: "A nostalgic aesthetic"
    )
}
