import Foundation

struct AestheticModel: Identifiable {
    var id: UUID
    var name: String
    var image: String
    var description: String
    var allReferences: [ImageModel]

    var totalReferences: Int {
        return allReferences.count
    }

    init(name: String, image: String, description: String, allReferences: [ImageModel] = []) {
        self.id = UUID()
        self.name = name
        self.image = image
        self.description = description
        self.allReferences = allReferences
    }
}

extension AestheticModel {
    static let sampleData: [AestheticModel] = [
        AestheticModel(
            name: "Nostalgia", image: "bk", description: "Aesthetic of the past",
            allReferences: [ImageModel.placeholder, ImageModel.placeholder, ImageModel.placeholder])
    ]
}
