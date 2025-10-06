import Foundation

struct AestheticModel: Identifiable {
    var id: UUID
    var name: String
    var image: String
    var allReferences: [ImageModel]

    var totalReferences: Int {
        return allReferences.count
    }

    init(name: String, image: String, allReferences: [ImageModel] = []) {
        self.id = UUID()
        self.name = name
        self.image = image
        self.allReferences = allReferences
    }
}

extension AestheticModel {
    static let placeholder = AestheticModel(
        name: "Placeholder", image: "nostalgia",
        allReferences: [ImageModel.placeholder, ImageModel.placeholder, ImageModel.placeholder])

    static let sampleData: [AestheticModel] = [
        AestheticModel(
            name: "Nostalgia",
            image: "nostalgia",
            allReferences: [
                ImageModel.placeholder,
                ImageModel.placeholder,
                ImageModel.placeholder,
                ImageModel.placeholder,
                ImageModel.placeholder,
                ImageModel.placeholder,
            ]
        ),
        AestheticModel(
            name: "Anime",
            image: "nostalgia",
            allReferences: [
                ImageModel.placeholder,
                ImageModel.placeholder,
                ImageModel.placeholder,
                ImageModel.placeholder,
                ImageModel.placeholder,
                ImageModel.placeholder,
            ]
        ),
        AestheticModel(
            name: "Teste",
            image: "nostalgia",
            allReferences: [
                ImageModel.placeholder,
                ImageModel.placeholder,
                ImageModel.placeholder,
                ImageModel.placeholder,
                ImageModel.placeholder,
                ImageModel.placeholder,
            ]
        ),
    ]
}
